import 'dart:async';
import 'package:zwave/command/util.dart';
import 'package:zwave/command/zw_command.dart';
import 'package:zwave/zwave.dart';

/// `AddDeviceCommand` enables manually adding a device to a Z-Wave network.
class AddDeviceCommand extends ZWCommand {
  AddDeviceCommand(ZWave zwave, ProgressHandler progressHandler)
      : super(
          zwave,
          'addDevice',
          description: 'Puts the zwave controller into "add" mode\n'
              'so that a new device can be manually added to the zwave network',
          argumentDescription: '[<network id>]',
          aliases: ['add', 'a'],
          progressHandler: progressHandler,
        );

  @override
  runWith(StringBuffer buf) async {
    var rest = argResults.rest;
    String networkArg;
    if (rest.isEmpty) {
      if (hasMultipleNetworks) {
        missingArgument(buf, 'network id');
        return;
      }
      networkArg = null;
    } else if (rest.length == 1) {
      networkArg = rest[0];
    } else {
      unknownArguments(buf, rest.sublist(1));
      return;
    }

    int networkId = parseInt(networkArg);
    if (networkId == -1) {
      invalidArgument(buf, 'network id', networkArg);
      return;
    }

    Device device;
    try {
      Future<Device> result;
      if (networkId == null) {
        result = zwave.addDevice();
      } else {
        result = zwave.addDevice(networkId: networkId);
      }
      progress('Waiting for device to be added...');
      var timeout = new Duration(minutes: 5);
      device = await result.timeout(timeout, onTimeout: () => null);
    } catch (e) {
      buf.writeln('Failed to add device:\n  $e');
      return;
    }
    if (device == null) {
      buf.writeln('Gave up waiting for device to be added.');
      return;
    }
    buf.writeln('Added device: ${device.nodeId} $device');
    progress('Waiting for device configuration...');
    var notification = await device.onNotification
        .firstWhere(
            (n) => n.notificationIndex == NotificationType.NodeQueriesComplete)
        .timeout(new Duration(minutes: 5), onTimeout: () => null);
    if (notification == null) {
      buf.writeln('Gave up waiting for device to be configured.');
      return;
    }
    zwave.writeConfig();
    buf.writeln('Device configured: $device');
  }
}
