import 'dart:isolate';

import 'package:zwave/port/zw_port.dart';

import 'dart-ext:rpi_zw_port_ext';

/// [RpiZwPort] is a concrete subclass of [ZwPort] for interacting
/// with a Z-Wave controller connected to a Raspberry Pi
/// or other similar Linux system.
class RpiZwPort extends ZwPort {
  @override
  int get lastError => _lastError();

  @override
  int openPort(String portPath) {
    // TODO have native return the file descriptor and cache it here
    // rather than a global native variable tty_fd holding the file descriptor
    return _openPort(portPath, notificationPort.sendPort);
  }

  @override
  int write(List<int> data) => _write(data);

  @override
  int closePort() => _closePort();

  int _closePort() native "closePort";
  int _lastError() native "lastError";
  int _openPort(String portPath, SendPort sendPort) native "openPort";
  int _write(List<int> bytes) native "write";
}
