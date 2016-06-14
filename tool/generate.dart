import 'dart:io';

Map<String, EnumValue> notificationTypes;
Map<String, EnumValue> valueTypes;
Map<String, EnumValue> valueGenres;

main() {
  readNotificationTypes();
  readValueInfo();
  print('--- analysis complete');

  StringBuffer out = new StringBuffer('''
part of zwave;

// Generated code

class NotificationType {
  final int index;
  final String name;

  NotificationType._(this.index, this.name);
''');
  List sorted = new List.from(notificationTypes.values)
    ..sort(sortEnumValueByName);
  for (EnumValue type in sorted) {
    out.writeln('');
    out.writeln(formatComment(type.comment, 2));
    out.writeln('  static NotificationType ${type.name} =');
    out.writeln('      new NotificationType._(${type.index}, "${type.name}");');
  }
  out.write('''

  /// A list of notification types sorted by index.
  static List<NotificationType> list = <NotificationType>[
''');
  sorted = new List.from(notificationTypes.values)..sort(sortEnumValueByIndex);
  for (EnumValue type in sorted) {
    out.write('    ');
    out.write(type.name);
    out.write(',');
    for (int i = 0; i < 30 - type.name.length; ++i) out.write(' ');
    out.write('// ');
    out.writeln(type.index.toString());
  }
  out.writeln('  ];');
  out.writeln('}');

  generateIndices(out, notificationTypes, addPrefix: 'NotificationIndex_');
  generateIndices(out, valueTypes, addPrefix: 'ValueTypeIndex_');
  generateIndices(out, valueGenres, addPrefix: 'ValueGenreIndex_');

  String path = Platform.script.resolve('../lib/zwave_g.dart').toFilePath();
  print('writing $path');
  new File(path).writeAsStringSync(out.toString());
  print('--- generation complete');
}

void generateIndices(StringBuffer out, Map<String, EnumValue> values,
    {String addPrefix: ''}) {
  out.writeln();
  List<EnumValue> sorted = new List.from(values.values)
    ..sort(sortEnumValueByName);
  for (EnumValue value in sorted) {
    out.writeln('const int $addPrefix${value.name} = ${value.index};');
  }
}

void readNotificationTypes() {
  List<String> lines = new File(Platform.script
          .resolve('../../open-zwave/cpp/src/Notification.h')
          .toFilePath())
      .readAsLinesSync();
  Iterator<String> iter = lines.iterator;
  while (iter.moveNext()) {
    if (iter.current.contains('enum NotificationType')) {
      notificationTypes = readEnumValues(iter, stripPrefix: 'Type_');
    }
  }
}

void readValueInfo() {
  List<String> lines = new File(Platform.script
          .resolve('../../open-zwave/cpp/src/value_classes/ValueID.h')
          .toFilePath())
      .readAsLinesSync();
  Iterator<String> iter = lines.iterator;
  while (iter.moveNext()) {
    if (iter.current.contains('enum ValueType')) {
      valueTypes = readEnumValues(iter,
          stripPrefix: 'ValueType_', ignore: 'ValueType_Max');
    }
    if (iter.current.contains('enum ValueGenre')) {
      valueGenres = readEnumValues(iter,
          stripPrefix: 'ValueGenre_', ignore: 'ValueGenre_Count');
    }
  }
}

Map<String, EnumValue> readEnumValues(Iterator<String> iter,
    {String stripPrefix, String ignore, String appendSuffix: ''}) {
  Map<String, EnumValue> values = {};
  EnumValue value;
  EnumValue.resetCurrentIndex();
  while (iter.moveNext()) {
    String line = iter.current.trim();
    if (line == '};') break;
    if (line == '{') continue;
    if (ignore != null && line.startsWith(ignore)) continue;
    if (line.startsWith(stripPrefix)) {
      int start = stripPrefix.length;
      int end = start;
      while (isIdentifier(line.codeUnitAt(end))) ++end;
      value = new EnumValue(line.substring(start, end) + appendSuffix);
      values[value.name] = value;
      start = end + 1;
      if (line.substring(start).startsWith(' = ')) {
        start += 3;
        end = line.indexOf(',', start);
        int actualIndex = int.parse(line.substring(start, end));
        if (actualIndex != value.index) {
          throw 'Expected ${value.name} index = ${value.index},'
              ' but found $actualIndex';
        }
      }
      start = line.indexOf('/**<', start) + 4;
      String comment = line.substring(start).trim();
      if (comment.endsWith('*/')) {
        comment = comment.substring(0, comment.length - 2).trim();
      }
      value.comment = comment;
    } else if (line.startsWith('*')) {
      String comment = line.substring(1);
      if (comment.endsWith('*/')) {
        comment = comment.substring(0, comment.length - 2).trim();
      }
      value.comment += ' $comment';
    }
  }
  return values;
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

class EnumValue {
  static int _currentIndex;
  static void resetCurrentIndex() {
    _currentIndex = -1;
  }

  final int index = ++_currentIndex;
  final String name;
  String comment = '';

  EnumValue(this.name) {}
}

int cA = 'A'.codeUnitAt(0);
int cZ = 'Z'.codeUnitAt(0);
int ca = 'a'.codeUnitAt(0);
int cz = 'z'.codeUnitAt(0);
int c_ = '_'.codeUnitAt(0);

bool isIdentifier(int c) =>
    (cA <= c && c <= cZ) || (ca <= c && c <= cz) || c == c_;

int sortEnumValueByName(EnumValue a, EnumValue b) => a.name.compareTo(b.name);

int sortEnumValueByIndex(EnumValue a, EnumValue b) => a.index - b.index;
