import 'dart:io';

main() {
  Map<String, NotificationType> notificationTypes = {};

  List<String> lines = new File(Platform.script
          .resolve('../../open-zwave/cpp/src/Notification.h')
          .toFilePath())
      .readAsLinesSync();

  Iterator<String> iter = lines.iterator;
  while (iter.moveNext()) {
    // Extract notification types
    if (iter.current.contains('enum NotificationType')) {
      NotificationType type;
      while (iter.moveNext()) {
        String line = iter.current.trim();
        if (line == '};') break;
        if (line == '{') continue;
        if (line.startsWith('Type_')) {
          int start = 5;
          int end = start;
          while (isIdentifier(line.codeUnitAt(end))) ++end;
          type = new NotificationType(line.substring(start, end));
          notificationTypes[type.name] = type;
          start = end + 1;
          if (line.substring(start).startsWith(' = ')) {
            start += 3;
            end = line.indexOf(',', start);
            int actualIndex = int.parse(line.substring(start, end));
            if (actualIndex != type.index) {
              throw 'Expected ${type.name} index = ${type.index},'
                  ' but found $actualIndex';
            }
          }
          start = line.indexOf('/**<', start) + 4;
          String comment = line.substring(start).trim();
          if (comment.endsWith('*/')) {
            comment = comment.substring(0, comment.length - 2).trim();
          }
          type.comment = comment;
        } else if (line.startsWith('*')) {
          String comment = line.substring(1);
          if (comment.endsWith('*/')) {
            comment = comment.substring(0, comment.length - 2).trim();
          }
          type.comment += ' $comment';
        }
      }
    }
  }
  print('--- analysis complete');

  StringBuffer out = new StringBuffer('''
part of zwave;

// Generated code

class NotificationType {
  final int index;
  final String name;

  NotificationType._(this.index, this.name);
''');
  List<NotificationType> sorted = notificationTypes.values.toList()
    ..sort(sortNotificationTypeByName);
  for (NotificationType type in sorted) {
    out.writeln('');
    out.writeln(formatComment(type.comment, 2));
    out.writeln('  static NotificationType ${type.name} =');
    out.writeln('      new NotificationType._(${type.index}, "${type.name}");');
  }
  out.write('''

  /// A list of notification types sorted by index.
  static List<NotificationType> list = <NotificationType>[
''');
  sorted = notificationTypes.values.toList()..sort(sortNotificationTypeByIndex);
  for (NotificationType type in sorted) {
    out.write('    ');
    out.write(type.name);
    out.write(',');
    for (int i = 0; i < 30 - type.name.length; ++i) out.write(' ');
    out.write('// ');
    out.writeln(type.index.toString());
  }
  out.write('''  ];
}

''');
  sorted = notificationTypes.values.toList()..sort(sortNotificationTypeByName);
  for (NotificationType type in sorted) {
    out.writeln('const int NotificationIndex_${type.name} = ${type.index};');
  }
  new File(Platform.script.resolve('../lib/zwave.g.dart').toFilePath())
      .writeAsStringSync(out.toString());
  print('--- generation complete');
}

String formatComment(String comment, int indent) {
  int maxLen = 80 - indent - 4;
  StringBuffer out = new StringBuffer();
  while (true) {
    for (int i = 0; i < indent; ++i) out.write(' ');
    out.write('/// ');
    comment = comment.trim();
    if (comment.length <= maxLen) {
      out.write(comment);
      break;
    }
    int index = maxLen;
    while (comment.substring(index, index + 1) != ' ') --index;
    out.writeln(comment.substring(0, index).trim());
    comment = comment.substring(index);
  }
  return out.toString();
}

class NotificationType {
  static int _currentIndex = -1;

  final int index = ++_currentIndex;
  final String name;
  String comment = '';

  NotificationType(this.name);
}

int cA = 'A'.codeUnitAt(0);
int cZ = 'Z'.codeUnitAt(0);
int ca = 'a'.codeUnitAt(0);
int cz = 'z'.codeUnitAt(0);
int c_ = '_'.codeUnitAt(0);

bool isIdentifier(int c) =>
    (cA <= c && c <= cZ) || (ca <= c && c <= cz) || c == c_;

int sortNotificationTypeByName(NotificationType a, NotificationType b) =>
    a.name.compareTo(b.name);

int sortNotificationTypeByIndex(NotificationType a, NotificationType b) =>
    a.index - b.index;
