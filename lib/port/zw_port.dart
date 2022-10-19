import 'dart:async';
import 'dart:isolate';

import 'package:logging/logging.dart';
import 'package:zwave/src/zw_decoder.dart';
import 'package:zwave/zw_driver.dart';
import 'package:zwave/zw_exception.dart';

/// [ZwPort] handles low level communication with the Z-Wave controller.
/// Low level ACK (acknowledge) and NAK (corrupt message) responses
/// are automatically sent and higher level message data is forwarded
/// to the provided request/response handlers.
abstract class ZwPort {
  /// The driver used by this port to process Z-Wave messages
  ZwDriver? driver;

  late ZwDecoder _decoder;
  ReceivePort? notificationPort;
  StreamSubscription? _notificationSubscription;

  ZwPort() {
    driver = ZwDriver(write);
    _decoder = ZwDecoder(driver);
  }

  /// Open the ZWave serial port on [portPath]
  /// where [portPath] defaults to [defaultPortPath] if unspecified.
  Future<void> open(String? portPath) async {
    if (notificationPort != null) _error('already open');
    if (portPath == null) _error('invalid port path');
    notificationPort = ReceivePort();
    _notificationSubscription = notificationPort!.listen(process);
    await openPort(portPath);
    _logger.config('opened $portPath');

    // Initialize the connection
    driver!.sendNak();
    // TODO Consider sending FUNC_ID_SERIAL_API_SOFT_RESET and waiting 1 1/2 sec
  }

  void process(dynamic data) => _decoder.process(data);

  /// Low level method for opening the Z-Wave port.
  /// Clients should call [open] which calls this method.
  Future<void> openPort(String? portPath);

  /// Send raw data over the port to the Z-Wave controller.
  void write(List<int?>? data);

  Future<void> close() async {
    if (notificationPort == null) return;
    await _notificationSubscription?.cancel();
    _notificationSubscription = null;
    notificationPort?.close();
    notificationPort = null;
    _decoder.clear();
    await closePort();
    _logger.config('closed');
  }

  /// Low level method for closing the Z-Wave port.
  /// Clients should call [close] which calls this method.
  Future<void> closePort();
}

final Logger _logger = Logger('ZwPort');

void _error(String message, {int? error}) {
  final buf = StringBuffer(message);
  if (error != null) buf.write(', error: $error');
  _logger.warning(buf.toString());
  throw ZwException(message);
}
