import 'dart:async';

import 'package:logging/logging.dart';
import 'package:zwave/capability/network_management_proxy.dart';
import 'package:zwave/command/zw_command.dart';
import 'package:zwave/command/zw_request.dart';
import 'package:zwave/handler/command_handler.dart';
import 'package:zwave/handler/message_dispatcher.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/node/unknown_node.dart';
import 'package:zwave/node/zw_node.dart';
import 'package:zwave/report/api_library_version.dart';
import 'package:zwave/zw_driver.dart';
import 'package:zwave/zw_exception.dart';

/// [ZwManager] manages a collection of Z-Wave nodes
/// on a single Z-Wave network. Messages sent from the physical
/// devices are forwarded to the corresponding [ZwNode].
/// Messages destine for physical devices are queue and sent sequentially.
class ZwManager extends MessageDispatcher<void> implements CommandHandler {
  final logger = Logger('ZwManager');
  final controller = PrimaryController();
  final ZwDriver driver;
  final int retryDelayMsForTesting;

  /// A list of tasks being processed or `null` if processing is complete.
  List<_Task> _tasks;

  ZwManager(this.driver, {this.retryDelayMsForTesting}) {
    driver.requestHandler = dispatch;
    initHandlers();
    add(controller);
  }

  Future<ApiLibraryVersion> apiLibraryVersion() => request(ZwRequest(
        logger,
        1, // controller node id
        buildFunctRequest(FUNC_ID_ZW_GET_VERSION),
        processResponse: (data) => ApiLibraryVersion(data),
      ));

  // ===== nodes ==========================================================

  /// A list of [ZwNode]s indexed by their node ids
  final _nodes = <ZwNode>[];

  /// The current [ZwNode]s managed by the receiver
  Iterable<ZwNode> get nodes => _nodes.where((node) => node != null).toList();

  /// Insert a [node] into the list of nodes at the [node]'s id
  void add(ZwNode node) {
    while (_nodes.length <= node.id) {
      _nodes.add(null);
    }
    final oldNode = _nodes[node.id];
    if (oldNode != null) {
      logger.log(oldNode is UnknownNode ? Level.FINE : Level.WARNING,
          'replacing existing ${oldNode.runtimeType} ${oldNode.id}');
    }
    _nodes[node.id] = node;
    node.zwManager = this;
  }

  /// Return the node with the specified [nodeId],
  /// creating an [UnknownNode] if a node with that id does not already exist.
  ZwNode nodeWithId(int nodeId) {
    return existingNodeWithId(nodeId) ?? createUnknownNode(nodeId);
  }

  /// Return the node with the specified [nodeId] or `null` if none.
  ZwNode existingNodeWithId(int nodeId) =>
      nodeId < _nodes.length ? _nodes[nodeId] : null;

  /// Create an [UnknownNode] and add it to the receiver's collection of nodes.
  ZwNode createUnknownNode(int nodeId) {
    if (existingNodeWithId(nodeId) != null) throw 'node $nodeId already exists';
    logger.config('creating unknown node $nodeId');
    ZwNode node = UnknownNode(nodeId);
    add(node);
    return node;
  }

  // ===== requests from devices ==========================================

  @override
  void handleApplicationCommandHandler(List<int> data) {
    /*
    application command handler message:
    data[0] - 0x01 SOF
    data[1] - message length excluding SOF and checksum
    data[2] - 0x00 request or 0x01 response
    data[3] - function id 0x04 application command
    data[4] - rxStatus
    data[5] - source node
    data[6] - command length
    data[7] - command class (e.g. COMMAND_CLASS_METER)
    data[*] - command data
    data[n] - checksum
    */
    nodeWithId(data[5]).dispatchApplicationCommand(data);
  }

  @override
  void handleZwApplicationUpdate(List<int> data) {
    /*
    application update message:
    data[0] - 0x01 SOF
    data[1] - message length excluding SOF and checksum
    data[2] - 0x00 request or 0x01 response
    data[3] - function id 0x49 application update
    data[4] - sub command (e.g. UPDATE_STATE_NODE_INFO_RECEIVED)
    data[5] - source node
    data[6] - command length
    data[*] - command data
    data[n] - checksum
     */
    nodeWithId(data[5]).dispatchApplicationUpdate(data);
  }

  void handleZwSendData(List<int> data) {
    /*
    send data message:
    data[0] - 0x01 SOF
    data[1] - message length excluding SOF and checksum
    data[2] - 0x00 request or 0x01 response
    data[3] - function id 0x13 FUNC_ID_ZW_SEND_DATA
    data[4] - source node
    data[5] - command length
    data[6] - command class
    data[*] - command data
    data[n-1] - transmit options (0x02 low power) <-- is this optional?
    data[n] - checksum
    */
    if (data.length < 10) {
      if (data.length < 7) {
        logger.warning('invalid send data received: $data');
        return;
      } else if (data.length == 7) {
        if (data[5] /* command length */ == 0) {
          //  0x01, // SOF
          //  0x05, // length 5 excluding SOF and checksum
          //  0x00, // request
          //  0x13, // FUNC_ID_ZW_SEND_DATA
          //  0x25, // source node 37
          //  0x00, // command length 0
          //  0xCC, // checksum
          logger.fine('ping controller from node # ${data[4]}');
        } else {
          logger.warning('invalid send data received: $data');
        }
        return;
      } else {
        if (data[5] /* command length */ == 0 &&
            data[6] == COMMAND_CLASS_NO_OPERATION) {
          //  0x01, // SOF
          //  0x07, // length 7 excluding SOF and checksum
          //  0x00, // request
          //  0x13, // FUNC_ID_ZW_SEND_DATA
          //  0x25, // source node 37
          //  0x00, // command length 0
          //  0x00, // COMMAND_CLASS_NO_OPERATION
          //  0x04, // transmit options: auto route (may not be included)
          //  0xCA, // checksum
          logger.fine('ping controller from node # ${data[4]}');
        } else {
          logger.warning('invalid send data received: $data');
        }
        return;
      }
    }
    var nodeId = data[4];
    var node = existingNodeWithId(nodeId) ?? createUnknownNode(nodeId);
    node.dispatchSendData(data);
  }

  // ===== requests to devices ============================================

  @override
  Future<T> request<T>(ZwRequest<T> request) {
    final task = _RequestTask(this, request);
    _process(task);
    return request.completer.future;
  }

  /// Called when a node has processed an unsolicited request so that any
  /// outstanding request waiting for that information can be completed.
  /// Returns `true` if an outstanding request was satisified, else `false`.
  bool processedResult<T>(int nodeId, T result) {
    if (T == Type) throw 'missing result type';
    for (int index = 0; index < _resultPool.length; ++index) {
      final request = _resultPool[index];
      if (request.nodeId == nodeId && request.resultKey == T) {
        _resultPool.removeAt(index);
        request.completer.complete(result);
        _startResultTimer();
        return true;
      }
    }
    return false;
  }

  /// Send the specified request message
  /// and return a [Future] that completes when the message is acknowledged.
  /// This should only be called from [ZwCommand] send.
  Future<void> send(ZwCommand command) async {
    if (command.responseCompleter == null)
      throw const ZwException('call ZwCommand.send rather than this method');
    final task = _CommandTask(this, command);
    _process(task);
    return task.sendCompleter.future;
  }

  /// Add the task to the list of tasks being processed
  /// and start processing tasks if they are not already being processed.
  void _process(_Task task) async {
    if (_tasks != null) {
      // If tasks are already being processed, add the task and return
      _tasks.add(task);
      return;
    }
    _tasks = <_Task>[task];
    while (_tasks.isNotEmpty) {
      task = _tasks[0];
      try {
        await task.run();
      } catch (e, s) {
        logger.warning('task exception', e, s);
        task.handleException(e, s);
      }
      _tasks.remove(task);
    }
    // Discard the empty task list to indicate that processing is complete
    _tasks = null;
  }

  /// A collection of requests awaiting a result from the device.
  final _resultPool = <ZwRequest>[];

  /// A timer for triggering removal of timed-out requests in [_resultPool].
  Timer _resultTimer;

  /// Add the [request] to the pool of requests awaiting additional data
  /// from the device to complete the request. When the node receives
  /// and processes the additional data, the node should call
  /// [processedResult] with this request's resultKey to indicate that
  /// the request is complete.
  void _awaitResult(ZwRequest request) {
    request.resultEndTime = DateTime.now().add(request.resultTimeout);
    _resultPool.add(request);
    _startResultTimer();
  }

  /// Start a timer for removal of timed-out requests in [_resultPool].
  void _startResultTimer() {
    _resultTimer?.cancel();
    if (_resultPool.isNotEmpty) {
      DateTime nextTime = _resultPool.fold<DateTime>(
        _resultPool.first.resultEndTime,
        (endTime, request) {
          final otherTime = request.resultEndTime;
          return endTime.isBefore(otherTime) ? endTime : otherTime;
        },
      );
      Duration duration = nextTime.difference(DateTime.now());

      _resultTimer = Timer(duration, () {
        final now = DateTime.now();
        _resultPool.removeWhere((request) {
          if (now.isBefore(request.resultEndTime)) return false;
          if (!request.completer.isCompleted) {
            request.completer.completeError(ZwException.resultTimeout);
          } else {
            request.logger.warning('request completed but processedResult'
                '(${request.nodeId}, ${request.resultKey}) not called');
          }
          return true;
        });
        _startResultTimer();
      });
    } else {
      _resultTimer = null;
    }
  }
}

class PrimaryController extends ZwNode with NetworkManagementProxy {
  PrimaryController() : super(1);
}

class _RequestTask extends _Task {
  final ZwManager manager;
  final ZwRequest request;
  final List<int> requestData;
  final responseCompleter = Completer<List<int>>();

  _RequestTask(this.manager, this.request) : requestData = request.data;

  @override
  Future<void> run() {
    Future<void> responseProcessed =
        responseCompleter.future.then((List<int> response) {
      processResponse(response);
    }).catchError((exception, StackTrace trace) {
      handleException(exception, trace);
    });
    return sendRequest().then((bool sent) {
      return sent ? responseProcessed : Future.value();
    });
  }

  Future<bool> sendRequest() async {
    int retryCount = 0;
    while (true) {
      try {
        // Send command and wait for ACK indicating command was received
        await manager.driver.send(requestData,
            responseCompleter: responseCompleter,
            responseTimeout: request.responseTimeout);

        if (retryCount > 0) request.logger.warning('sent on retry $retryCount');
        return true;
      } on ZwException catch (e) {
        request.logger.warning('${e.message}, data: ${requestData}');

        // If the send was canceled, corrupted, or timeout, retry up to 3 times
        if (e.isSendCanceledCorruptedOrTimeout && retryCount < 3) {
          await Future.delayed(Duration(
              milliseconds:
                  manager.retryDelayMsForTesting ?? retryCount * 1000 + 100));
          ++retryCount;
        } else {
          handleException(e, null);
          return false;
        }
      }
    }
  }

  void processResponse(List<int> data) {
    if (_isSimpleResponse(request.functId, data)) {
      if (request.resultKey != null) {
        manager._awaitResult(request);
      } else {
        request.completer.complete(null);
      }
    } else {
      if (request.processResponse != null) {
        request.completer.complete(request.processResponse(data));
      } else {
        request.logger.warning('unexpected response: $data');
        request.completer.complete(null);
      }
    }
  }

  @override
  void handleException(exception, StackTrace trace) {
    if (!responseCompleter.isCompleted) {
      responseCompleter.completeError(exception, trace);
    } else if (!request.completer.isCompleted) {
      request.completer.completeError(exception, trace);
    } else {
      request.logger
          .warning('exception after operation complete', exception, trace);
    }
  }
}

/// A background task which is processed in sequence with other background tasks.
abstract class _Task {
  /// Start the task and return a future that completes when the task is done.
  Future<void> run();

  /// Handle an exception that occurred while running the task.
  void handleException(error, StackTrace trace);
}

class _CommandTask extends _Task {
  final ZwManager manager;
  final ZwCommand command;
  final sendCompleter = Completer<void>();
  final responseCompleter = Completer<List<int>>();

  _CommandTask(this.manager, this.command);

  @override
  Future<void> run() async {
    final finished = Completer<void>();

    // ignore: unawaited_futures
    responseCompleter.future.then((List<int> response) {
      command.responseCompleter.complete(response);
      finished.complete();
    }).catchError((exception, StackTrace trace) {
      handleException(exception, trace);
      if (!finished.isCompleted) finished.complete();
    });

    int retryCount = 0;
    while (true) {
      try {
        // Send command and wait for ACK indicating command was received
        await manager.driver.send(command.data,
            responseCompleter: responseCompleter,
            responseTimeout: command.responseTimeout);

        if (retryCount > 0) manager.logger.warning('sent on retry $retryCount');
        sendCompleter.complete();
        break;
      } on ZwException catch (e) {
        manager.logger.warning('${e.message}, data: ${command.data}');

        // If the send was canceled or corrupted, retry up to 3 times
        if (e.isSendCanceledCorruptedOrTimeout && retryCount < 3) {
          await Future.delayed(Duration(
              milliseconds:
                  manager.retryDelayMsForTesting ?? retryCount * 1000 + 100));
          ++retryCount;
        } else {
          handleException(e, null);
          finished.complete();
          return;
        }
      }
    }

    // Await the command result from the device
    await finished.future;
    return;
  }

  @override
  void handleException(exception, StackTrace trace) {
    if (!sendCompleter.isCompleted) {
      sendCompleter.completeError(exception, trace);
    } else if (!responseCompleter.isCompleted) {
      responseCompleter.completeError(exception, trace);
    } else if (!command.responseCompleter.isCompleted) {
      command.responseCompleter.completeError(exception, trace);
    } else {
      manager.logger
          .warning('exception after response processed', exception, trace);
    }
  }
}

bool _isSimpleResponse(int functId, List<int> data) {
  /*
  Check for a response such as ...

  0x01, // SOF
  0x04, // length excluding SOF and checksum
  0x01, // response
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x00 or 0x01 // callback and no callback ???
  0xE8, // checksum

  ... indicating that the device has acknowledged the request
  but that there is no additional data associated with the response.
  */
  return data.length == 6 &&
      data[3] == functId &&
      (data[4] == 0x00 || data[4] == 0x01);
}
