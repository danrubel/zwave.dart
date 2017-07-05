import 'package:zwave/command/util.dart';
import 'package:zwave/command/zw_command.dart';
import 'package:zwave/zwave.dart';

/// `SetValueCommand` changes a value in a particular device
class SetValueCommand extends ZWCommand {
  SetValueCommand(ZWave zwave)
      : super(
          zwave,
          'setValue',
          description:
              'Change bool, double, and int values for a specific device',
          argumentDescription:
              '[<network id>] <node id> <value id> <new value>',
          aliases: const ['set', 's'],
        );

  @override
  runWith(StringBuffer buf) {
    String networkArg;
    String nodeArg;
    String valueArg;
    String newValue;
    var rest = argResults.rest;
    if (rest.isEmpty) {
      missingArgument(buf, 'node id');
      return;
    } else if (rest.length == 1) {
      missingArgument(buf, 'value id');
      return;
    } else if (rest.length == 2) {
      missingArgument(buf, 'new value');
      return;
    } else if (rest.length == 3) {
      if (hasMultipleNetworks) {
        missingArgument(buf, 'network id');
        return;
      }
    }
    if (hasMultipleNetworks) {
      networkArg = rest[0];
      nodeArg = rest[1];
      valueArg = rest[2];
      newValue = rest.sublist(3).join(' ');
    } else {
      networkArg = null;
      nodeArg = rest[0];
      valueArg = rest[1];
      newValue = rest.sublist(2).join(' ');
    }

    Device device = findDevice(buf, networkArg, nodeArg);
    if (device == null) return;

    int valueId = parseInt(valueArg);
    if (valueId == -1) {
      invalidArgument(buf, 'value id', valueArg);
      return;
    }

    Value value;
    if (1 <= valueId && valueId <= device.values.length) {
      value = sortedValues(device)[valueId - 1];
    } else {
      value = device.values
          .firstWhere((Value value) => value.id == valueId, orElse: () => null);
    }
    if (value == null) {
      buf.writeln('Value $valueArg not found');
      return;
    }
    if (value.readOnly) {
      buf.writeln('Value $valueArg is read only');
      return;
    }

    if (value is BoolValue) {
      bool boolValue;
      if (['true', 't', 'on'].contains(newValue)) {
        boolValue = true;
      } else if (['false', 'f', 'off'].contains(newValue)) {
        boolValue = false;
      } else {
        buf.writeln('Invalid value "$newValue" for $value');
        return;
      }
      try {
        value.current = boolValue;
      } catch (e) {
        buf.write('Failed to set int value to $boolValue\n  $e');
        return;
      }
      buf.writeln('Value $valueArg set to $boolValue');
      return;
    }
    if (value is DoubleValue) {
      double doubleValue = double.parse(newValue, (_) => null);
      if (doubleValue == null) {
        buf.writeln('Invalid value "$newValue" for $value');
        return;
      }
      try {
        value.current = doubleValue;
      } catch (e) {
        buf.write('Failed to set double value to $doubleValue\n  $e');
        return;
      }
      buf.writeln('Value $valueArg set to $doubleValue');
      return;
    }
    if (value is IntValue) {
      int intValue = int.parse(newValue, onError: (_) => null);
      if (intValue == null) {
        buf.writeln('Invalid value "$newValue" for $value');
        return;
      }
      try {
        value.current = intValue;
      } catch (e) {
        buf.write('Failed to set int value to $intValue\n  $e');
        return;
      }
      buf.writeln('Value $valueArg set to $intValue');
      return;
    }
    buf.writeln('Can only set bool, double, and int values');
    buf.writeln();
    buf.writeln(usage);
    return;
  }
}
