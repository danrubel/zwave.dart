import 'package:zwave/command/util.dart';
import 'package:zwave/command/zw_command.dart';
import 'package:zwave/zwave.dart';

/// `NeighborsCommand` displays battery state for each known Z-Wave device.
class NeighborsCommand extends ZWCommand {
  NeighborsCommand(ZWave zwave)
      : super(
          zwave,
          'neighbors',
          description: 'Display neighbors for each known device',
          aliases: const ['n'],
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
      writeDeviceNeighbors(buf, zwave, device);
    }
  }
}
