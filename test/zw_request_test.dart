import 'dart:async';

import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'package:zwave/command/zw_request.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/zw_driver.dart';
import 'package:zwave/zw_manager.dart';

import 'zw_driver_test.dart';

/// Common infrastructure for testing zwave request/response/result.
abstract class ZwRequestTest {
  late ZwDriver driver;
  late ZwManager manager;
  late TestHandler requestHandler;
  late TestHandler defaultResponseHandler;
  late TestPort port;

  // This should be called once from the main() method to initialize tests.
  // Do not override this method but override defineTests instead.
  void init() {
    setUp(() {
      port = TestPort();
      driver = ZwDriver(port.sendData, sendTimeoutMsForTesting: 25);
      manager = ZwManager(driver, retryDelayMsForTesting: 10);
      requestHandler = TestHandler();
      driver.requestHandler = requestHandler.process;
      defaultResponseHandler = TestHandler();
      driver.defaultResponseHandler = defaultResponseHandler.process;
    });

    defineTests();
  }

  /// Override this method to define tests.
  void defineTests();

  /// Add a request with no response
  void expectingRequestNoResponse(List<int> request) {
    assertValidMessage(request);
    if (request[2] != 0x00) throw 'invalid request';

    port.expectedMessages.add(request);
    port.responses.add(() {
      sendAck();
    });
  }

  /// Add a request/response pair
  void expectingRequestResponse(List<int> request, List<int> response) {
    assertValidMessage(request);
    if (request[2] != 0x00) throw 'invalid request';
    assertValidMessage(response);
    if (response[2] != 0x01) throw 'invalid response';

    port.expectedMessages.add(request);
    port.responses.add(() {
      sendAck();
      sendData(response);
    });
    port.expectedMessages.add(ackMsg);
  }

  /// Add a request/simple-response/result pair
  void expectingRequestResult(List<int> request, List<int> result) {
    assertValidMessage(request);
    if (request[2] != 0x00) throw 'invalid request';
    assertValidMessage(result);
    if (result[2] != 0x00) throw 'invalid result';

    port.expectedMessages.add(request);
    port.responses.add(() {
      sendAck();
      sendSimpleResponse(request[3]);
      // TODO find a better way than using a delay
      Future.delayed(const Duration(milliseconds: 1)).then((_) {
        manager.dispatch(result);
      });
    });
    port.expectedMessages.add(ackMsg);
  }

  /// Add a request/simple-response pair
  void expectingRequestSimpleResponse(List<int> request) {
    assertValidMessage(request);
    if (request[2] != 0x00) throw 'invalid request';

    port.expectedMessages.add(request);
    port.responses.add(() {
      sendAck();
      sendSimpleResponse(request[3]);
    });
    port.expectedMessages.add(ackMsg);
  }

  /// Assert that the given id references an existing node.
  void assertValidMessage(List<int> data) {
    expect(data, isNotNull, reason: 'null message');

    int nodeId;
    if (data[3] == FUNC_ID_ZW_SEND_DATA) {
      nodeId = data[4];
    } else if (data[3] == FUNC_ID_APPLICATION_COMMAND_HANDLER) {
      nodeId = data[5];
    } else {
      return;
    }

    manager.nodes.firstWhere((node) => node!.id == nodeId, orElse: () {
      fail('missing node $nodeId');
    });
  }

  void expectComplete() {
    expect(requestHandler.expectedData, isNull);
    expect(defaultResponseHandler.expectedData, isNull);
    expect(port.expectedMessages, isEmpty);
    expect(port.responses, isEmpty);
  }

  void sendAck() {
    Future(driver.handleAck);
  }

  void sendNak() {
    Future(driver.handleNak);
  }

  void sendCancel() {
    Future(driver.handleCan);
  }

  void sendData(List<int> data) {
    Future(() {
      driver.handleDataFrame(data);
    });
  }

  void sendSimpleResponse([int functId = FUNC_ID_ZW_SEND_DATA]) {
    sendData([
      0x01, // SOF
      0x04, // length excluding SOF and checksum
      0x01, // response
      functId,
      0x00,
      0xE8, // checksum
    ]);
  }
}

class TestRequest extends ZwRequest<String?> {
  TestRequest(
    ZwManager manager,
    int? nodeId,
    List<int>? data, {
    String? Function(List<int> data)? processResponse,
    Object? resultKey,
  }) : super(
          manager.logger,
          nodeId,
          data,
          processResponse: processResponse,
          responseTimeout: const Duration(milliseconds: 25),
          resultKey: resultKey,
          resultTimeout: const Duration(milliseconds: 25),
        );

  @override
  String toString() => '$runtimeType $data';
}

List<int> injectTestSeqNum(List<int> rawData, int seqNumIndex) {
  var data = List<int>.from(rawData);
  data[seqNumIndex] = nextTestSequenceNumber;
  data.removeLast();
  appendCrc(data);
  return data;
}

/// Redirect logging output to the console for test debugging purposes.
void startLogger() {
  if (_loggingStarted) return;
  _loggingStarted = true;
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
    if (rec.error != null) print(rec.error);
    if (rec.stackTrace != null) print(rec.stackTrace);
  });
}

bool _loggingStarted = false;

printData(String constName, List<int> data) {
  entry(int value, [String? description]) {
    final buf = StringBuffer();
    buf.write(' 0x');
    buf.write(value.toRadixString(16).toUpperCase().padLeft(2, '0'));
    buf.write(', // ');
    if (description != null) {
      buf.write(description);
    }
    print(buf.toString());
  }

  String requestOrResponse(int value) {
    switch (value) {
      case 0:
        return 'request';
      case 1:
        return 'response';
      default:
        return '<<< ???';
    }
  }

  print('const $constName = [');
  entry(data[0], 'SOF');
  entry(data[1], 'length excluding SOF and checksum');
  entry(data[2], requestOrResponse(data[2]));
  int index = 3;
  final functId = data[index];
  switch (functId) {
    case FUNC_ID_APPLICATION_COMMAND_HANDLER:
      entry(functId, 'FUNC_ID_APPLICATION_COMMAND_HANDLER');
      if (data.length > 6) {
        ++index;
        entry(data[index], 'rxStatus');
        ++index;
        entry(data[index], 'source node ${data[index]}');
        ++index;
        entry(data[index], 'command length');
        ++index;
      }
      break;
    case FUNC_ID_ZW_SEND_DATA:
      entry(functId, 'FUNC_ID_ZW_SEND_DATA');
      if (data.length > 6) {
        ++index;
        entry(data[index], 'source node ${data[index]}');
        ++index;
        entry(data[index], 'command length');
        ++index;
      }
      break;
    default:
      break;
  }
  while (index < data.length - 1) entry(data[index++]);
  entry(data[index], 'checksum');
  print('];');
}
