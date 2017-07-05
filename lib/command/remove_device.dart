import 'dart:async';
import 'package:zwave/command/util.dart';
import 'package:zwave/command/zw_command.dart';
import 'package:zwave/zwave.dart';

/// `RemoveDeviceCommand` remove an existing device from the Z-Wave network
class RemoveDeviceCommand extends ZWCommand {
  RemoveDeviceCommand(ZWave zwave, ProgressHandler progressHandler)
      : super(
          zwave,
          'removeDevice',
          description: 'Puts the zwave controller into "remove" mode\n'
              'so that an existing device can be manually removed from the zwave network',
          argumentDescription: '[<network id>]',
          aliases: ['remove'],
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

    int nodeId;
    try {
      Future<int> result;
      if (networkId == null) {
        result = zwave.removeDevice();
      } else {
        result = zwave.removeDevice(networkId: networkId);
      }
      progress('Waiting for device to be removed...');
      nodeId =
          await result.timeout(new Duration(minutes: 5), onTimeout: () => null);
    } catch (e) {
      buf.writeln('Failed to remove device:\n  $e');
      return;
    }
    if (nodeId == null) {
      buf.writeln('Gave up waiting for device to be removed.');
      return;
    }
    zwave.writeConfig();
    buf.writeln('Removed device $nodeId');
  }
}
