import 'dart:async';
import 'dart:isolate';

import 'package:logging/logging.dart';
import 'package:zwave/port/zw_port.dart';

import 'dart-ext:rpi_zw_port_ext';

/// [RpiZwPort] is a concrete subclass of [ZwPort] for interacting
/// with a Z-Wave controller connected to a Raspberry Pi
/// or other similar Linux system.
class RpiZwPort extends ZwPort {
  Isolate? isolate;
  SendPort? cmdSendPort;
  ReceivePort? exitPort;
  ReceivePort? errorPort;

  @override
  Future<void> openPort(String portPath) async {
    _logger.fine('starting isolate');
    final setupPort = ReceivePort();
    exitPort = ReceivePort();
    errorPort = ReceivePort()..listen(_processError);

    isolate = await Isolate.spawn(
      startIsolate,
      [portPath, setupPort.sendPort, notificationPort!.sendPort],
      debugName: 'zw_port_isolate',
      errorsAreFatal: true,
      onExit: exitPort!.sendPort,
      onError: errorPort!.sendPort,
    );

    _logger.fine('awaiting command port');
    cmdSendPort = (await setupPort.first) as SendPort;
    setupPort.close();

    // TODO move all native operations to the isolate

    _logger.fine('isolate started');
  }

  void _processError(message) {
    if (message is List<dynamic>)
      _logger.severe('IsolateException\n  ${message[0]}\n${message[1]}');
    else
      _logger.severe('unexpected isolate errorPort message: $message');
    closePort();
  }

  @override
  void write(List<int> data) {
    cmdSendPort!.send(data);
  }

  @override
  Future<void> closePort() async {
    if (isolate == null) return;

    _logger.fine('isolate stopping');
    cmdSendPort?.send(null);
    try {
      await exitPort?.first.timeout(const Duration(seconds: 10));
    } on TimeoutException {
      _logger.warning('killing isolate');
      isolate?.kill();
    } catch (error, trace) {
      _logger.warning('error closing port', error, trace);
    }
    isolate = null;
    _logger.fine('isolate stopped');
    exitPort?.close();
    exitPort = null;
    errorPort?.close();
    errorPort = null;
  }
}

final Logger _logger = Logger('RpiZwPort');

void startIsolate(List info) {
  final portPath = info[0] as String;
  final setupSendPort = info[1] as SendPort;
  final notificationSendPort = info[2] as SendPort;

  RpiZwIsolate(portPath, notificationSendPort).start(setupSendPort);
}

class RpiZwIsolate {
  final String portPath;
  final ReceivePort cmdPort = ReceivePort();
  final SendPort notificationSendPort;
  int? ttyFd;

  RpiZwIsolate(this.portPath, this.notificationSendPort);

  void start(SendPort setupSendPort) async {
    log('starting');
    ttyFd = _openPort(portPath);
    if (ttyFd! <= 0)
      throw 'open port failed: $ttyFd, ${_lastError()}, $portPath';

    cmdPort.listen(processCmds);
    setupSendPort.send(cmdPort.sendPort);

    // Read and forward any messages from the port
    while (ttyFd != null) {
      log('reading...');
      var data = _read(ttyFd!);
      log('read ${data.runtimeType} : $data');
      if (data is int) {
        log('one byte read');
        notificationSendPort.send(data);
        if (data < 0) {
          notificationSendPort.send(_lastError());
        }
      } else if (data != null) {
        log('multiple bytes read');
        notificationSendPort.send(data);
      } else {
        log('sleep before trying to read again');
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
    log('exit read loop');
  }

  void processCmds(message) {
    if (ttyFd == null) {
      log('command ignored - port closed');
      return;
    }
    log('command received');

    int? writeResult;
    if (message != null) {
      log('writing ${message.runtimeType} : $message');
      writeResult = _write(ttyFd!, message as List<int>);
      if (writeResult >= 0) {
        log('bytes written');
        return;
      }
    }
    log('write failed');

    var closeResult = _closePort(ttyFd!);
    cmdPort.close();
    ttyFd = null;

    if (writeResult != null && writeResult < 0) {
      throw 'write failed: $writeResult, ${_lastError()}, $message';
    } else if (closeResult < 0) {
      throw 'close failed: $closeResult, ${_lastError()}';
    }
  }

  void log(String message) {
    // print('isolate: $message');
  }

  int _closePort(int ttyFd) native 'closePort';
  int _lastError() native 'lastError';
  int _openPort(String portPath) native 'openPort';
  dynamic _read(int ttyFd) native 'read';
  int _write(int ttyFd, List<int> bytes) native 'write';
}
