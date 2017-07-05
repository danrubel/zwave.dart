import 'package:zwave/command/zw_command.dart';
import 'package:zwave/zwave.dart';

/// `RenameDeviceCommand` changes the name of a particular device
class RenameDeviceCommand extends ZWCommand {
  RenameDeviceCommand(ZWave zwave)
      : super(
          zwave,
          'renameDevice',
          description: 'Change the name of a specific device',
          argumentDescription: '[<network id>] <node id> <device name>',
          aliases: const ['rename'],
        );

  @override
  runWith(StringBuffer buf) {
    String networkArg;
    String nodeArg;
    String newName;
    var rest = argResults.rest;
    if (rest.isEmpty) {
      missingArgument(buf, 'node id');
      return;
    } else if (rest.length == 1) {
      missingArgument(buf, 'device name');
      return;
    } else if (rest.length == 2) {
      if (hasMultipleNetworks) {
        missingArgument(buf, 'network id');
        return;
      }
    }
    if (hasMultipleNetworks) {
      networkArg = rest[0];
      nodeArg = rest[1];
      newName = rest.sublist(2).join(' ');
    } else {
      networkArg = null;
      nodeArg = rest[0];
      newName = rest.sublist(1).join(' ');
    }
    newName = newName.trim();
    if (newName.isEmpty) {
      missingArgument(buf, 'new name');
      return;
    }

    Device device = findDevice(buf, networkArg, nodeArg);
    if (device == null) return;

    device.name = newName;
    buf.write('Renamed device $nodeArg to "$newName"');
  }
}
