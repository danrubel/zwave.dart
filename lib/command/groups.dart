import 'package:zwave/command/util.dart';
import 'package:zwave/command/zw_command.dart';
import 'package:zwave/zwave.dart';

/// `GroupsCommand` displays groupds for each known Z-Wave device.
class GroupsCommand extends ZWCommand {
  GroupsCommand(ZWave zwave)
      : super(
          zwave,
          'groups',
          description: 'Display groups/associations for each known device',
          argumentDescription: '',
          aliases: ['g', 'associations', 'assoc'],
        );

  @override
  runWith(StringBuffer buf) {
    if (!checkNoMoreArgs(buf)) return;
    int networkId = 0;
    for (Device device in devicesSortedById) {
      if (networkId != device.networkId) {
        networkId = device.networkId;
        buf.writeln('Devices in network 0x${networkId.toRadixString(16)}');
      }
      buf.writeln('  ${device.nodeId} ${device.name}');
      writeDeviceGroups(buf, zwave, device);
    }
  }
}
