import 'package:zwave/command/util.dart';
import 'package:zwave/command/zw_command.dart';
import 'package:zwave/zwave.dart';

/// `DeviceCommand` displays information about a particular device
class DeviceCommand extends ZWCommand {
  DeviceCommand(ZWave zwave)
      : super(
          zwave,
          'device',
          description: 'Display information about a specific device',
          argumentDescription: '[<network id>] <node id>',
          aliases: const ['d'],
        );

  @override
  runWith(StringBuffer buf) {
    var rest = argResults.rest;
    String networkArg;
    String nodeArg;
    if (rest.isEmpty) {
      missingArgument(buf, 'node id');
      return;
    } else if (rest.length == 1) {
      if (hasMultipleNetworks) {
        missingArgument(buf, 'network id');
        return;
      }
      networkArg = null;
      nodeArg = rest[0];
    } else if (rest.length == 2) {
      networkArg = rest[0];
      nodeArg = rest[1];
    } else {
      unknownArguments(buf, rest.sublist(2));
      return;
    }

    Device device = findDevice(buf, networkArg, nodeArg);
    if (device == null) return;

    var manufacturer = device.manufacturerName;
    if (manufacturer?.isNotEmpty != true) manufacturer = device.manufacturerId;
    var product = device.productName;
    if (product?.isNotEmpty != true) product = device.productId;
    buf.writeln('$device - $manufacturer, $product');

    writeDeviceValues(buf, device);
    buf.writeln('  Groups / Associations');
    writeDeviceGroups(buf, zwave, device);
    buf.writeln('  Neighbors');
    writeDeviceNeighbors(buf, zwave, device);
  }
}
