import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:zwave/port/rpi_zw_port.dart';
import 'package:zwave/zw_manager.dart';

Future<void> main(List<String> args) async {
  setupLogger();

  String? zwaveDevicePath = getZWaveDevicePath(args);
  Logger.root.fine('starting...');

  final port = RpiZwPort();
  final manager = ZwManager(port.driver!);

  Logger.root.config('opening Z-Wave port: ${args[0]}');
  await port.open(zwaveDevicePath);

  // Display ZWave controller version
  final version = await manager.apiLibraryVersion();
  Logger.root.info(version.toString());

  await Future.delayed(const Duration(seconds: 3));

  Logger.root.config('closing Z-Wave port');
  await port.close();
  Logger.root.config('exiting');
}

String? getZWaveDevicePath(List<String> args) {
  if (args.isNotEmpty) {
    return args[0];
  }
  print('missing path to Z-Wave device (e.g. /dev/ttyACM0)');
  var deviceFiles = Directory('/dev')
      .listSync()
      .where((f) =>
          f is File &&
          (f.uri.pathSegments.last.startsWith('ttyA') ||
              f.uri.pathSegments.last.startsWith('ttyU')))
      .map((f) => f.path)
      .toList()
    ..sort();
  if (deviceFiles.isNotEmpty) {
    print('  perhaps one of ${deviceFiles.join(', ')} ?');
  }
  exit(1);
}

void setupLogger() {
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord rec) {
    var buffer = StringBuffer();
    buffer
      ..write(rec.time.toString().padRight(26, '0'))
      ..write(' ')
      ..write(rec.level.name.padRight(7))
      ..write(' ')
      ..write(rec.loggerName.padRight(23))
      ..write(': ')
      ..write(rec.message);
    if (rec.error != null) {
      buffer
        ..writeln()
        ..write('  ')
        ..write(rec.error);
    }
    if (rec.stackTrace != null) {
      buffer
        ..writeln()
        ..write(rec.stackTrace);
    }
    print(buffer.toString());
  });
}
