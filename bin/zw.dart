import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:zwave/port/rpi_zw_port.dart';
import 'package:zwave/zw_manager.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty)
    throw 'Expected path to Z-Wave device (e.g. /dev/ttyACM0)';

  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen(printLog);

  final port = new RpiZwPort();
  final manager = new ZwManager(port.driver);

  Logger.root.config('opening Z-Wave port: ${args[0]}');
  await port.open(args[0]);

  // Display ZWave controller version
  final version = await manager.apiLibraryVersion();
  print(version.toString());

  await new Future.delayed(const Duration(seconds: 2));

  // TODO list nodes, then provide command prompt for interacting with nodes

  await port.close();
}

void printLog(LogRecord rec) {
  var buffer = new StringBuffer();
  printLogTo(buffer, rec);
  print(buffer.toString());
  try {
    stdout.flush();
  } catch (e) {
    // ignore
  }
}

void printLogTo(StringBuffer buffer, LogRecord rec) {
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
}
