import 'package:zwave/command/zw_command.dart';
import 'package:zwave/zwave.dart';

/// `PollingCommand` displays battery state for each known Z-Wave device.
class PollingCommand extends ZWCommand {
  PollingCommand(ZWave zwave)
      : super(
          zwave,
          'polling',
          description: 'Display polling intensity for each known device',
          aliases: const ['p'],
        );

  @override
  runWith(StringBuffer buf) {
    if (!checkNoMoreArgs(buf)) return;
    int networkId = 0;
    buf.writeln('  pollInterval: ${zwave.pollInterval} seconds');
    for (Device device in devicesSortedById) {
      if (networkId != device.networkId) {
        networkId = device.networkId;
        buf.writeln('Devices in network 0x${networkId.toRadixString(16)}');
      }

      for (Value value in device?.values ?? []) {
        bool first = true;
        if ((value.pollIntensity ?? 0) > 0) {
          if (first) {
            first = false;
            buf.writeln('  ${device.nodeId} ${device.name}');
          }
          buf.writeln('    $value - pollIntensity: ${value.pollIntensity}');
        }
      }
    }
  }
}
