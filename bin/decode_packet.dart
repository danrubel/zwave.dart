import 'package:logging/logging.dart';
import 'package:zwave/util/packet_to_source.dart';
import 'dart:io';

main(List<String> args) {
  Logger.root.onRecord.listen(printLog);

  // convert arguments into a list of bytes
  final data = <int>[];
  try {
    for (String arg in args) {
      for (String part1 in arg.split('[')) {
        for (String part2 in part1.split(',')) {
          for (String text in part2.split(']')) {
            text = text.trim();
            if (text.isNotEmpty) {
              data.add(int.parse(text));
            }
          }
        }
      }
    }
  } on FormatException catch (e) {
    print('Failed to parse int: ${e.source}');
    usage();
    return;
  }
  if (data.isEmpty) {
    usage();
    return;
  }

  print(packetToSource(data));
}

void printLog(LogRecord rec) {
  var buffer = StringBuffer();
  printLogTo(buffer, rec);
  print(buffer.toString());
}

final defaultLogLevel = Level.CONFIG;

void printLogTo(StringBuffer buffer, LogRecord rec) {
  buffer
    ..write(rec.time.toString().padRight(26, '0'))
    ..write(' ')
    ..write(rec.level.name.padRight(7))
    ..write(' ')
    ..write(rec.loggerName.padRight(27))
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

void usage() {
  var appName = Platform.resolvedExecutable;
  appName = appName.substring(appName.lastIndexOf('bin/'));
  print('usage: dart $appName <bytes>');
  print('  where <bytes> is a list of int values between 0 and 255 inclusive');
  print('  all "[", ",", and "]" characters are ignored');
}
