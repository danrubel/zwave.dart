import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:isolate';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;
import 'package:logging/logging.dart';
import 'package:zwave/port/zw_port.dart';
import 'package:zwave/src/native/zwave_ext.dart';

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
  _log('isolate starting');
  final portPath = info[0] as String;
  final setupSendPort = info[1] as SendPort;
  final notificationSendPort = info[2] as SendPort;

  RpiZwIsolate(portPath, notificationSendPort).start(setupSendPort);
}

class RpiZwIsolate {
  final String portPath;
  final ReceivePort cmdPort = ReceivePort();
  final SendPort notificationSendPort;
  final dylib = NativePgkLib(findDynamicLibrary());
  final buf255 = ffi.malloc.allocate<ffi.Uint8>(255);
  int? ttyFd;

  RpiZwIsolate(this.portPath, this.notificationSendPort);

  void start(SendPort setupSendPort) async {
    _log('opening port');
    copyStringToBuf(portPath);
    ttyFd = dylib.openPortMth(buf255);
    if (ttyFd! <= 0)
      throw 'open port failed: $ttyFd, ${dylib.lastErrorMth()}, $portPath';

    cmdPort.listen(processCmds);
    setupSendPort.send(cmdPort.sendPort);

    // Read and forward any messages from the port
    while (ttyFd != null) {
      _log('reading...');
      var count = dylib.readBytesMth(ttyFd!, 255, buf255);
      if (count > 1) {
        var rxData = Uint8List(count);
        for (var index = 0; index < count; index++) //
          rxData[index] = buf255.elementAt(index).value;
        _log('  read: $rxData');
        notificationSendPort.send(rxData);
      } else if (count == 1) {
        var byteValue = buf255.elementAt(0).value;
        _log('  read: $byteValue');
        notificationSendPort.send(byteValue);
      } else if (count == 0) {
        _log('  sleep before trying to read again');
        await Future.delayed(const Duration(milliseconds: 100));
      } else {
        var byteValue = buf255.elementAt(0).value;
        var lastError = dylib.lastErrorMth();
        _log('  read error: $byteValue, $lastError');
        notificationSendPort.send(byteValue);
        notificationSendPort.send(lastError);
      }
    }
    _log('exit read loop');
  }

  void processCmds(message) {
    if (ttyFd == null) {
      _log('command ignored - port closed: $message');
      return;
    }
    _log('command received: $message');

    int? writeResult;
    if (message != null) {
      _log('writing ${message.runtimeType} : $message');
      var txData = message as List<int>;
      var count = txData.length;
      for (var index = 0; index < count; index++) //
        buf255.elementAt(index).value = txData[index];
      writeResult = dylib.writeBytesMth(ttyFd!, count, buf255);
      if (writeResult >= 0) {
        _log('  $writeResult bytes written');
        return;
      }
      _log('  write failed: $writeResult, ${dylib.lastErrorMth()}');
    }

    _log('closing port');
    var closeResult = dylib.closePortMth(ttyFd!);
    cmdPort.close();
    ttyFd = null;
    if (closeResult >= 0)
      _log('  closed');
    else
      _log('  close failed: $closeResult, ${dylib.lastErrorMth()}');
  }

  /// Copy the characters from [str] into [buf255].
  void copyStringToBuf(String str) {
    if (str.length > 254) throw 'String too long: $str';
    var index = 0;
    for (var value in str.codeUnits) {
      buf255.elementAt(index).value = value;
      ++index;
    }
    // null terminated C string
    buf255.elementAt(index).value = 0;
  }
}

void _log(String message) {
  // print('isolate: $message');
}
