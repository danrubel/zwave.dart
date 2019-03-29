import 'dart:async';
import 'dart:isolate';

import 'package:zwave/src/zw_decoder.dart';
import 'package:zwave/zw_driver.dart';
import 'package:zwave/zw_exception.dart';
import 'package:logging/logging.dart';

/// [ZwPort] handles low level communication with the Z-Wave controller.
/// Low level ACK (acknowledge) and NAK (corrupt message) responses
/// are automatically sent and higher level message data is forwarded
/// to the provided request/response handlers.
abstract class ZwPort {
  /// The driver used by this port to process Z-Wave messages
  ZwDriver driver;

  ZwDecoder _decoder;
  ReceivePort notificationPort;
  StreamSubscription _notificationSubscription;

  ZwPort() {
    driver = new ZwDriver(_sendData);
    _decoder = new ZwDecoder(driver);
  }

  /// Returns the last error if one occurred during a native call.
  int get lastError;

  /// Open the ZWave serial port on [portPath]
  /// where [portPath] defaults to [defaultPortPath] if unspecified.
  Future<void> open(String portPath) async {
    if (notificationPort != null) _error('already open');
    if (portPath == null) _error('invalid port path');
    notificationPort = new ReceivePort();
    _notificationSubscription = notificationPort.listen(_decoder.process);
    int result = openPort(portPath);
    if (result != 0) _error('open failed: $result', error: lastError);
    _logger.config('opened $portPath');

    // Initialize the connection
    if (!driver.sendNak()) throw const ZwException('initialization failed');
    // TODO Consider sending FUNC_ID_SERIAL_API_SOFT_RESET and waiting 1 1/2 sec
  }

  /// Low level method for opening the Z-Wave port.
  /// Clients should call [open] which calls this method.
  int openPort(String portPath);

  /// Send the specified data and return `true` if successful
  bool _sendData(List<int> data, String name) {
    int result = write(data);
    if (result == data.length) return true;

    _logger.warning('==> $name failed $result,'
        ' error: ${lastError}, data: $data');
    return false;
  }

  /// Send raw data over the port to the Z-Wave controller.
  int write(List<int> data);

  Future<void> close() async {
    if (notificationPort == null) return;
    await _notificationSubscription?.cancel();
    _notificationSubscription = null;
    notificationPort?.close();
    notificationPort = null;
    _decoder.clear();

    int result = closePort();

    if (result != 0) _error('close failed: $result', error: lastError);
    _logger.config('closed');
  }

  /// Low level method for closing the Z-Wave port.
  /// Clients should call [close] which calls this method.
  int closePort();
}

final Logger _logger = new Logger('ZwPort');

void _error(String message, {int error}) {
  final buf = new StringBuffer(message);
  if (error != null) buf.write(', error: $error');
  _logger.warning(buf.toString());
  throw new ZwException(message);
}
