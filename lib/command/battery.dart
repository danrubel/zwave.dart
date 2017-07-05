import 'package:zwave/command/util.dart';
import 'package:zwave/command/zw_command.dart';
import 'package:zwave/zwave.dart';

/// `BatteryCommand` displays battery state for each known Z-Wave device.
class BatteryCommand extends ZWCommand {
  BatteryCommand(ZWave zwave)
      : super(
          zwave,
          'battery',
          description: 'Display battery state for each known device',
          aliases: const ['batt', 'b'],
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

      for (Value value in device?.values ?? []) {
        bool first = true;
        if (value.label.startsWith('Battery')) {
          if (first) {
            first = false;
            buf.writeln('  ${device.nodeId} ${device.name}');
          }
          buf.write('    $value - ');
          try {
            buf.write(value.current);
          } catch (e) {
            buf.write(e);
          }
          buf.writeln(' - ${agoText(value.lastChangeTime)}');
        }
      }
    }
  }
}
