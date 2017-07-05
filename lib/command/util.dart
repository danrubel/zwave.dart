import 'package:zwave/zwave.dart';

typedef ProgressHandler(String message);

/// Return human readable text indicating approximately how long ago.
String agoText(DateTime someTime) {
  if (someTime == null) return '--';
  var delta = new DateTime.now().difference(someTime);

  var seconds = delta.inSeconds;
  if (delta.isNegative && seconds < -4) return 'in the future';
  if (seconds < 60) return 'just now';

  var minutes = delta.inMinutes;
  if (minutes == 1) return ' 1 minute ago';
  if (minutes < 10) return ' $minutes minutes ago';
  if (minutes < 60) return '$minutes minutes ago';

  var hours = delta.inHours;
  if (hours == 1) return ' 1 hour ago';
  if (hours < 10) return ' $hours hours ago';
  if (hours < 24) return '$hours hours ago';

  var days = delta.inDays;
  if (days == 1) return ' 1 day ago';
  if (days < 10) return ' $days days ago';
  if (days < 30) return '$days days ago';

  var months = days ~/ 30;
  if (months == 1) return ' 1 month ago';
  if (months < 10) return ' $months months ago';

  if (days < 365) return 'almost a year ago';
  return 'more than a year ago';
}

int parseInt(String arg) {
  if (arg == null) return null;
  if (arg.startsWith('0x'))
    return int.parse(arg.substring(2), radix: 16, onError: (_) => -1);
  return int.parse(arg, onError: (_) => -1);
}

void writeDeviceGroups(StringBuffer buf, ZWave zwave, Device device) {
  for (Group group in device?.groups ?? []) {
    List<int> associations = group.associations;
    var label = group.label;
    var description;
    if (label.length > 20) {
      description = label;
      label = '';
    }
    buf.writeln('    Group ${group.groupIndex} $label'
        ' - $associations'
        ' - ${group.maxAssociations} max');
    if (description != null) buf.writeln('      $description');
    for (int nodeId in associations) {
      try {
        var neighbor = zwave.device(nodeId, networkId: device.networkId);
        buf.writeln('      $neighbor');
      } catch (e) {
        if (e is String && e.startsWith('Expected nodeId to be one of')) {
          buf.writeln('      Unknown node $nodeId');
        } else {
          buf.writeln('      Unknown node $nodeId - $e');
        }
      }
    }
  }
}

void writeDeviceNeighbors(StringBuffer buf, ZWave zwave, Device device) {
  var neighborIds = device.neighborIds;
  if ((neighborIds?.length ?? 0) == 0) {
    buf.writeln('    no neighbors - sleeping? dead?');
  } else {
    for (int neighborId in neighborIds) {
      Device neighbor;
      try {
        neighbor = zwave.device(neighborId, networkId: device.networkId);
      } catch (e) {
        buf.writeln('    unknown device #$neighborId: $e');
        continue;
      }
      buf.writeln('    $neighbor');
    }
  }
}

void writeDeviceValues(StringBuffer buf, Device device) {
  int valueCount = 1;

  showText(String text) {
    while (text.length > 70) {
      int start = 70;
      while (text[start - 1] != ' ') --start;
      buf.writeln('      ${text.substring(0, start)}');
      text = text.substring(start);
    }
    buf.writeln('      $text');
  }

  showValue(Value value) {
    String count = (valueCount++).toString().padLeft(5);
    String label = value.label;
    String description;
    if (label == null || label.trim().isEmpty) {
      label = '$value';
    } else {
      if (label.length > 32) {
        description = label;
        label = label.substring(0, 32);
      }
      label = '$label ${value.id} ${value.index} ';
    }
    label = label.padRight(60, '.');
    var current =
        (value.writeOnly ? '(write only)' : '${value.current}').padRight(17);
    var ago = agoText(value.lastChangeTime);
    var details = value.readOnly ? ' (read only)' : '';
    buf.writeln('$count $label $current $ago $details');
    if (description != null) showText(description);
    if ((value.help?.length ?? 0) > 0) showText(value.help);
  }

  int lastGenre = -107;
  for (Value value in sortedValues(device)) {
    if (lastGenre != value.genre) {
      lastGenre = value.genre;
      if (0 <= lastGenre && lastGenre < ValueGenre.names.length) {
        buf.writeln('  ${ValueGenre.name(lastGenre)}');
      } else {
        buf.writeln('  Other');
      }
    }
    showValue(value);
  }
}

List<Value> sortedValues(Device device) {
  var values = <Value>[];
  for (int genre = 0; genre < ValueGenre.names.length; ++genre) {
    for (Value value in device?.values ?? []) {
      if (value.genre == genre) values.add(value);
    }
  }
  for (Value value in device?.values ?? []) {
    if (value.genre < 0 || value.genre >= ValueGenre.names.length)
      values.add(value);
  }
  return values;
}
