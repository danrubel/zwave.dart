import 'package:zwave/command/zw_command.dart';
import 'package:zwave/zwave.dart';

/// `ListCommand` displays all known Z-Wave devices.
class ListCommand extends ZWCommand {
  ListCommand(ZWave zwave)
      : super(
          zwave,
          'list',
          description: 'List all known devices',
          aliases: const ['l', 'devices'],
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
      buf.write(device.nodeId.toString().padLeft(4));
      buf.write(' ');
      buf.writeln(device.name);
    }
  }
}
