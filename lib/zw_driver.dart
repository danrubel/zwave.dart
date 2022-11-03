import 'dart:async';

import 'package:zwave/src/zw_decoder.dart';
import 'package:zwave/zw_exception.dart';
import 'package:logging/logging.dart';

typedef MessageHandler = void Function(List<int> data);

/// [ZwDriver] handles low level communication with the Z-Wave controller.
/// Low level ACK (acknowledge) and NAK (corrupt message) responses
/// are automatically sent and higher level message data is forwarded
/// to the provided request/response handlers.
class ZwDriver implements ZwDecodeListener {
  final void Function(List<int> data) _sendData;
  final Duration sendTimeout;

  /// [requestHandler] processes requests
  /// sent from the Z-Wave controller or from physical devices in the network.
  MessageHandler? requestHandler;

  /// [defaultResponseHandler] processes responses
  /// sent from the Z-Wave controller or from physical devices in the network.
  /// If a response handler is specified when [send] is called, then
  /// that handler (rather than this handler) will receive the next response.
  /// This handler will receive any subsequent responses.
  MessageHandler? defaultResponseHandler;

  Completer<void>? _sendCompleter;
  Completer<List<int>>? _responseCompleter;
  Timer? _responseTimer;

  int _handleRequestExceptionCount = 0;
  int _handleDefaultResponseExceptionCount = 0;

  ZwDriver(this._sendData, {int? sendTimeoutMsForTesting})
      : sendTimeout = Duration(milliseconds: sendTimeoutMsForTesting ?? 1600);

  /// Send the specified message and return a [Future]
  /// that completes when the message is acknowledged
  /// or completes with an error if the message is canceled or corrupted.
  Future<void> send(List<int> data,
      {Completer<List<int>>? responseCompleter, Duration? responseTimeout}) {
    if (data == null || data.isEmpty) _error('invalid data');
    if (responseCompleter != null && responseTimeout == null)
      _error('must specify responseTimeout with responseCompleter');
    if (_sendCompleter != null) _error('only one send at a time');
    if (_responseCompleter != null) _error('only one send/response at a time');

    _logFiner('==>', data, 'REQ');
    _sendData(data);
    _sendCompleter = Completer<void>();
    _responseCompleter = responseCompleter;

    // From section 6.2.2 of the Serial API Host Appl. Prg. Guide
    // Data frame sender timeout is 1600 ms
    return _sendCompleter!.future.timeout(sendTimeout, onTimeout: () {
      _logger.warning('send timeout $data');
      _sendCompleter = null;
      _responseCompleter = null;
      throw ZwException.sendTimeout;
    }).then((_) {
      _sendCompleter = null;
      if (_responseCompleter != null && responseTimeout != null) {
        _responseTimer = Timer(responseTimeout, () {
          _logger.warning('response timeout $data');
          _responseCompleter!.completeError(ZwException.responseTimeout);
          _responseCompleter = null;
          _responseTimer = null;
        });
      }
    });
  }

  void sendAck() {
    const ackMsg = <int>[ACK];
    _logFinest('==>', ackMsg, 'ACK');
    _sendData(ackMsg);
  }

  void sendNak() {
    const nakMsg = <int>[NAK];
    _logFinest('==>', nakMsg, 'NAK');
    _sendData(nakMsg);
  }

  @override
  void handleAck() {
    if (_sendCompleter != null) {
      _sendCompleter!.complete();
      _sendCompleter = null;
    } else {
      _logger.warning('unexpected ACK');
    }
  }

  @override
  void handleNak() {
    if (_sendCompleter != null) {
      _errorWaitingForAck(ZwException.sendCorrupted);
    } else {
      _logger.warning('unexpected NAK');
    }
  }

  @override
  void handleCan() {
    if (_sendCompleter != null) {
      _errorWaitingForAck(ZwException.sendCanceled);
    } else {
      _logger.warning('unexpected CAN');
    }
  }

  @override
  void handleDataFrame(List<int> dataFrame) {
    switch (dataFrame[2]) {
      case REQ_TYPE:
        sendAck();
        _handleRequest(dataFrame);
        break;
      case RES_TYPE:
        sendAck();
        _handleResponse(dataFrame);
        break;
      default:
        _logger.warning('unknown message type: ${dataFrame[2]} $dataFrame');
        const cancelMsg = <int>[CAN];
        _logFinest('==>', cancelMsg, 'CAN');
        _sendData(cancelMsg);
        break;
    }
  }

  void _handleRequest(List<int> dataFrame) {
    if (requestHandler != null) {
      try {
        requestHandler!(dataFrame);
      } catch (error, trace) {
        ++_handleRequestExceptionCount;
        _logger.warning(
            'request handler failed'
            ' ($_handleRequestExceptionCount): $dataFrame',
            error,
            _handleRequestExceptionCount < 5 ? trace : null);
      }
    } else {
      _logger.warning('Unexpected request: $dataFrame');
    }
  }

  void _handleResponse(List<int> dataFrame) {
    if (_responseCompleter != null) {
      _responseTimer?.cancel();
      _responseTimer = null;
      _responseCompleter!.complete(dataFrame);
      _responseCompleter = null;
    } else if (defaultResponseHandler != null) {
      try {
        defaultResponseHandler!(dataFrame);
      } catch (error, trace) {
        ++_handleDefaultResponseExceptionCount;
        _logger.warning(
            'default response handler failed'
            ' ($_handleDefaultResponseExceptionCount): $dataFrame',
            error,
            _handleDefaultResponseExceptionCount < 5 ? trace : null);
      }
    } else {
      _logger.warning('Unexpected response: $dataFrame');
    }
  }

  @override
  void handleInvalidDataFrame() {
    _logger.warning('invalid data frame');
    sendNak();
  }

  void _errorWaitingForAck(ZwException exception) {
    _logger.warning(exception.message);
    _sendCompleter!.completeError(exception);
    _sendCompleter = null;
    _responseCompleter = null;
    _responseTimer?.cancel();
    _responseTimer = null;
  }
}

final Logger _logger = Logger('ZwDriver');

void _error(String message) {
  _logger.warning(message);
  throw ZwException(message);
}

void _logFiner(String label, data, String tag) {
  if (_logger.level <= Level.FINER) _logger.finer('$label $data $tag');
}

void _logFinest(String label, data, String tag) {
  if (_logger.level <= Level.FINEST) _logger.finest('$label $data $tag');
}
