// Automated tests run on the build bots

import 'package:test/test.dart';
import 'package:zwave/zwave.dart';
import 'dart:async';

/// Port used by the Open Z-Wave library to access the Z-Wave Controller.
const controllerPort = '/dev/ttyACM0';

/// Configuration directory containing the manufacturer_specific.xml file.
const configPath = '/usr/local/etc/openzwave/';

main(List<String> args) async {
  bool allValues = false;
  Timeout timeout = new Timeout(new Duration(minutes: 1));
  List<dynamic> boolTest;
  List<dynamic> selectionTest;
  bool waitForAllUpdated = false;

  int argIndex = 0;
  while (argIndex < args.length) {
    // optionally dispaly all values associated with each device
    // rather than just the interesting user level values
    if (args[argIndex] == '--allValues') {
      allValues = true;

    // test a boolean value by toggling that value
    // --testBool=<nodeId>/<value-label>
    } else if (args[argIndex].startsWith('--testBool=')) {
      boolTest = parseNodeValue(args[argIndex]);

    // test a selection value by toggling that value
    // --testSelection=<nodeId>/<value-label>/<selection>
    } else if (args[argIndex].startsWith('--testSelection=')) {
      selectionTest = parseNodeValue(args[argIndex]);

    } else if (args[argIndex].startsWith('--timeout=')) {
      timeout = new Timeout(
          new Duration(minutes: int.parse(args[argIndex].substring(10))));
    } else if (args[argIndex] == '--waitForAllUpdated') {
      waitForAllUpdated = true;
    } else {
      print('unknown argument: ${args[argIndex]}');
    }
    ++argIndex;
  }

  ZWave zwave;
  test('bot', () async {
    print('initializing...');
    zwave = await ZWave.init(configPath, userPath: '/home/pi/dart/zdata');
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
    zwave.writeConfig(); // optional - see docs
    for (Device device in zwave.devices) {
      print('  $device - ${device.manufacturerName} ${device.productName}');
      for (Value value in (allValues ? device.values : device.userValues)) {
        var buf = new StringBuffer('      ${value.label} ($value)');
        if (value.readOnly) buf.write(' (readOnly)');
        if (value.writeOnly) buf.write(' (writeOnly)');
        while (buf.length < 65) buf.write(' ');
        buf.write(' = ${value.current}');
        if (value is ListSelectionValue) {
          buf.write(' - ${value.currentIndex}');
        }
        print(buf);

        if (value is IntValue) {
          print('        min ${value.min}, max ${value.max}');

        } else if (value is ListSelectionValue) {
          var buf = new StringBuffer('        ');
          for (String item in value.list) {
            buf.write('$item, ');
          }
          print(buf);
        }
      }
    }
    if (boolTest != null) {
      Device device = zwave.devices.firstWhere((d) => d.nodeId == boolTest[0]);
      BoolValue value = device.values.firstWhere((v) => v.label == boolTest[1]);
      print('bool test $device $value ...');

      bool original = value.current;
      value.current = !original;
      expect(await value.onChange.first, !original);
      expect(value.current, !original);

      await new Future.delayed(new Duration(seconds: 2));

      value.current = original;
      expect(await value.onChange.first, original);
      expect(value.current, original);

      await new Future.delayed(new Duration(milliseconds: 500));
    }
    if (selectionTest != null) {
      Device device = zwave.devices.firstWhere((d) => d.nodeId == selectionTest[0]);
      ListSelectionValue value = device.values.firstWhere((v) => v.label == selectionTest[1]);
      print('selection test $device $value ...');

      String original = value.current;
      value.current = selectionTest[2];
      expect(await value.onChange.first, selectionTest[2]);
      expect(value.current, selectionTest[2]);

      await new Future.delayed(new Duration(seconds: 2));

      value.current = original;
      expect(await value.onChange.first, original);
      expect(value.current, original);

      await new Future.delayed(new Duration(milliseconds: 500));
    }
    print('disposing...');
    await zwave.dispose();
    zwave = null;
  }, timeout: timeout);
  tearDown(() async {
    await zwave?.dispose();
  });
}

List<dynamic> parseNodeValue(String arg) {
  List<dynamic> nodeValue = arg.split('=')[1].split(',');
  nodeValue[0] = int.parse(nodeValue[0]);
  return nodeValue;
}
