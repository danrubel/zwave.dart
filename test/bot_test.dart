// Automated tests run on the build bots

import 'package:test/test.dart';
import 'package:zwave/zwave.dart';

/// Port used by the Open Z-Wave library to access the Z-Wave Controller.
const controllerPort = '/dev/ttyACM0';

/// Configuration directory containing the manufacturer_specific.xml file.
const configPath = '/usr/local/etc/openzwave/';

main() async {
  ZWave zwave;
  tearDown(() async {
    await zwave?.dispose();
  });
  test('bot', () async {
    print('initializing...');
    zwave = await ZWave.init(configPath);
    String version = zwave.version;
    print('  Open Z-Wave Library $version');
    expect(version, isNotEmpty);
    print('connecting...');
    await zwave.connect(controllerPort);
    print('updating...');
    await zwave.update();
    for (Device device in zwave.devices) {
      print('  $device');
      print('    node basic    ${device.nodeBasic}');
      print('    node generic  ${device.nodeGeneric}');
      print('    node specific ${device.nodeSpecific}');
      print('    node type     ${device.nodeType}');
      for (Value value in device.values) {
        var buf = new StringBuffer('      $value');
        while (buf.length < 50) buf.write(' ');
        buf.write(' = ${value.current}');
        while (buf.length < 60) buf.write(' ');
        if (value is ListSelectionValue) {
          buf.write(' - ${value.currentIndex}');
        }
        print(buf);
        if (value is IntValue) {
          print('        min ${value.min}, max ${value.max}');
        }
        if (value is ListSelectionValue) {
          var buf = new StringBuffer('        ');
          for (String item in value.list) {
            buf.write('$item, ');
          }
          print(buf);
        }
      }
    }
    print('disposing...');
    await zwave.dispose();
  });
}
