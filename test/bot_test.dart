// Automated tests run on the build bots

import 'package:test/test.dart';
import 'package:zwave/zwave.dart';

/// Port used by the Open Z-Wave library to access the Z-Wave Controller.
const controllerPort = '/dev/ttyACM0';

/// Configuration directory containing the manufacturer_specific.xml file.
const configPath = '/usr/local/etc/openzwave/';

main(List<String> args) async {
  bool waitForAllUpdated = false;
  Timeout timeout = new Timeout(new Duration(minutes: 1));

  int argIndex = 0;
  while (argIndex < args.length) {
    if (args[argIndex] == '--waitForAllUpdated') {
      waitForAllUpdated = true;
    } else if (args[argIndex].startsWith('--timeout=')) {
      timeout = new Timeout(
          new Duration(minutes: int.parse(args[argIndex].substring(10))));
    } else {
      print('unknown argument: ${args[argIndex]}');
    }
    ++argIndex;
  }

  ZWave zwave;
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
    if (waitForAllUpdated) {
      print('waiting for all nodes to respond...');
      await zwave.allUpdated();
    }
    for (Device device in zwave.devices) {
      print('  $device');
      print('    ${device.nodeBasic} ${device.nodeGeneric}'
          ' ${device.nodeSpecific} ${device.nodeType}');
      print('    ${device.manufacturerId} ${device.manufacturerName}');
      print('    ${device.productId} ${device.productType}'
          ' ${device.productName}');
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
    zwave = null;
  }, timeout: timeout);
  tearDown(() async {
    await zwave?.dispose();
  });
}
