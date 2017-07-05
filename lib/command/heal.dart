import 'package:zwave/command/zw_command.dart';
import 'package:zwave/zwave.dart';

/// `HealCommand` displays battery state for each known Z-Wave device.
class HealCommand extends ZWCommand {
  HealCommand(ZWave zwave)
      : super(
          zwave,
          'heal',
          description: 'Heal the zwave network',
        );

  @override
  runWith(StringBuffer buf) {
    if (!checkNoMoreArgs(buf)) return;
    int networkId = 0;
    for (Device device in devicesSortedById) {
      if (networkId != device.networkId) {
        networkId = device.networkId;
        buf.writeln('Healing network 0x${networkId.toRadixString(16)}');
        zwave.heal(networkId: networkId);
      }
    }
  }
}
