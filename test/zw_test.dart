import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:zwave/command/zw_runner.dart';
import 'package:zwave/zwave.dart';

main() async {
  MockDevice controller1 = newDevice('Controller 1', 0x10, 1, [2]);
  MockDevice switch1 = newDevice('A Switch', 0x10, 2, [1]);
  MockDevice controller2 = newDevice('Controller 2', 0x11, 1, [2]);
  MockDevice switch2 = newDevice('B Switch', 0x11, 2, [1]);

  var someGroup = newGroup(switch1, 'Some Group', 1, <int>[1]);

  var battValue = newIntValue(switch1, 'Battery', 47563424, 94, readOnly: true);
  var battCheckEnabled = newIntValue(
      switch1,
      'If battery power is below the warning value, low battery checking'
      ' function will be triggered and Low Battery Warning Report will be sent.',
      72553654988523122456,
      1,
      index: 101,
      helpText: '0, Disable, 1, Enable; Default setting: 0',
      pollIntensity: 7);
  var battCheckInterval = newIntValue(
      switch1,
      'The low battery check Interval time,0-4294967295 seconds.',
      459823654,
      604800,
      index: 111,
      helpText: 'This parameter is available when the low battery checking '
          'function is activated or the device was waked up by other actions '
          '(i.e. the z-wave button trigger, magnet switch trigger '
          'and the Wake Up Interval Set timeout trigger). '
          'The Recessed Door Sensor will check the battery power '
          'when it was wake up as other ways. For example: '
          'the z-wave button trigger, magnet switch trigger and the Wake Up '
          'Interval Set timeout trigger. Default setting: 86640');
  var boolValue = newBoolValue(switch1, 'Some bool', 3467567, true);
  var doubleValue = newDoubleValue(switch1, 'Some double', 3476998, 1.3);
  when(switch1.values).thenReturn(
      [battValue, battCheckEnabled, battCheckInterval, boolValue, doubleValue]);

  ZWave zwave = new MockZWave();
  when(zwave.devices).thenReturn([switch1, controller2, controller1, switch2]);
  when(zwave.device(1, networkId: 0x10)).thenReturn(controller1);
  when(zwave.device(2, networkId: 0x10)).thenReturn(switch1);
  when(zwave.pollInterval).thenReturn(30);

  var messages = <String>[];
  ZWRunner zw = new ZWRunner(zwave, progressHandler: (String message) {
    messages.add(message);
  });

  expectMessage(String expected) {
    if (messages.isEmpty) fail('Expected message: "$expected"');
    expect(messages[0], expected);
    messages.removeAt(0);
  }

  expectNoMessage() {
    if (messages.isNotEmpty) fail('Unexpected message(s): $messages');
  }

  test('addDevice', () async {
    var thing1 = newDevice('Thing1', 0x10, 3, [1, 2]);
    when(zwave.addDevice(networkId: 0x10)).thenReturn(
        new Future.delayed(new Duration(milliseconds: 1), () => thing1));
    var thing1Events = new StreamController<Notification>();
    thing1Events.add(new Notification(
        thing1, NotificationType.NodeQueriesComplete, [1, 2, 3]));
    when(thing1.onNotification).thenReturn(thing1Events.stream);
    String result = await zw.process('addDevice 0x10');
    expect(result, contains('Added device: 3 Thing1'));
    expect(result, contains('Device configured'));
    expectMessage('Waiting for device to be added...');
    expectMessage('Waiting for device configuration...');
    expectNoMessage();
  });

  test('addDevice missing network id', () async {
    String result = await zw.process('addDevice');
    expect(result, contains('Please specify <network id>'));
    expect(result, contains('Usage:'));
    expect(result, contains('Aliases: add, a'));
  });

  test('battery', () async {
    String result = await zw.process('battery');
    expect(result, contains('Devices in network 0x10'));
    expect(result, contains('Devices in network 0x11'));
    expect(result, contains('A Switch'));
    expect(result, contains('Battery'));
  });

  test('device', () async {
    String result = await zw.process('device 0x10 2');
    int lastIndex = 0;

    void expectNext(String expected) {
      int index = result.indexOf(expected, lastIndex);
      expect(index, greaterThanOrEqualTo(lastIndex), reason: result);
      lastIndex = index + 1;
    }

    expectNext(switch1.name);
    expectNext('Some Company');
    expectNext('A Product');
    expectNext('Basic');
    expectNext('1 Battery 47563424 0');
    expectNext(
        '2 If battery power is below the wa 72553654988523122456 101 .. 1');
    expectNext('function will be triggered');
    expectNext('Groups');
    expectNext('Group 1');
    expectNext('Neighbors');
    expectNext(controller1.name);
    expect(result, isNot(contains(controller2.name)));
  });

  test('device alt', () async {
    String expected = await zw.process('device 0x11 1');
    String actual = await zw.process('device 17 0x1');
    expect(actual, expected);
  });

  test('device invalid args', () async {
    String result = await zw.process('device 2 3 4 5');
    expect(result, contains('Unknown arguments: 4 5'));
    expect(result, contains('Usage:'));
  });

  test('device invalid network id', () async {
    String result = await zw.process('device seven 2');
    expect(result, contains('Invalid <network id>: seven'));
    expect(result, contains('Usage:'));
  });

  test('device invalid node id', () async {
    String result = await zw.process('device 1 seven');
    expect(result, contains('Invalid <node id>: seven'));
    expect(result, contains('Usage:'));
  });

  test('device missing network id', () async {
    String result = await zw.process('device 2');
    expect(result, contains('Please specify <network id>'));
    expect(result, contains('Usage:'));
  });

  test('device missing node id', () async {
    String result = await zw.process('device');
    expect(result, contains('Please specify <node id>'));
    expect(result, contains('Usage:'));
  });

  test('device not found', () async {
    String result = await zw.process('device 1 8');
    expect(result, contains('Device 8 in network 0x1 not found'));
    expect(result, contains('Usage:'));
  });

  test('groups', () async {
    String result = await zw.process('groups');
    expect(result, contains('Devices in network 0x10'));
    expect(result, contains('Devices in network 0x11'));
    expect(result, contains('Group 1'));
  });

  test('heal', () async {
    String result = await zw.process('heal');
    expect(result, contains('Healing network 0x'));
  });

  test('list', () async {
    String result = await zw.process('list');
    // Assert correct content
    expect(result, contains('Devices in network 0x10'));
    expect(result, contains('Devices in network 0x11'));
    expect(result, contains(controller1.name));
    expect(result, contains(switch1.name));
    // Assert result is sorted by nodeId
    expect(result.indexOf(' 1 '), lessThan(result.indexOf(' 2 ')),
        reason: result);
  });

  test('list invalid args', () async {
    String result = await zw.process('list 2');
    expect(result, contains('Unknown argument: 2'));
    expect(result, contains('Usage:'));
  });

  test('neighbors', () async {
    String result = await zw.process('neighbors');
    expect(result, contains('Devices in network 0x10'));
    expect(result, contains('Devices in network 0x11'));
    expect(result, contains('A Switch'));
    expect(result, contains('Controller 1('));
  });

  test('polling', () async {
    String result = await zw.process('polling');
    expect(result, contains('pollInterval: 30 seconds'));
    expect(result, contains('Devices in network 0x10'));
    expect(result, contains('Devices in network 0x11'));
    expect(result, contains('A Switch'));
    expect(result, contains('pollIntensity: 7'));
  });

  test('removeDevice', () async {
    when(zwave.removeDevice(networkId: 0x10))
        .thenReturn(new Future.delayed(new Duration(milliseconds: 1), () => 3));
    String result = await zw.process('removeDevice 0x10');
    expect(result, contains('Removed device 3'));
    expectMessage('Waiting for device to be removed...');
    expectNoMessage();
  });

  test('removeDevice missing network id', () async {
    String result = await zw.process('removeDevice');
    expect(result, contains('Please specify <network id>'));
  });

  test('renameDevice', () async {
    expect(switch1.name, 'A Switch');
    String result = await zw.process('renameDevice 0x10 2 My Switch');
    expect(result, contains('Renamed device 2 to "My Switch"'));
    expect(switch1.name, 'My Switch');
  });

  test('setGroup', () async {
    expect(someGroup.associations, [1]);
    String result = await zw.process('setGroup 0x10 2 1');
    expect(result, contains('Group 1 set to []'));
    expect(someGroup.associations, []);
    result = await zw.process('setGroup 0x10 2 1 1 3');
    expect(result, contains('Group 1 set to [1, 3]'));
    expect(someGroup.associations, [1, 3]);
    result = await zw.process('setGroup 0x10 2 1 1 3 4');
    expect(result, contains('Group 1 set to [1, 3, 4]'));
    expect(someGroup.associations, [1, 3, 4]);
  });

  test('setValue bool', () async {
    expect(boolValue.current, true);
    String result = await zw.process('setValue 0x10 2 4 off');
    expect(result, contains('Value 4 set to false'));
    expect(boolValue.current, false);
  });

  test('setValue double', () async {
    expect(doubleValue.current, 1.3);
    String result = await zw.process('setValue 0x10 2 5 1.7');
    expect(result, contains('Value 5 set to 1.7'));
    expect(doubleValue.current, 1.7);
  });

  test('setValue int', () async {
    expect(battCheckInterval.current, 604800);
    String result = await zw.process('setValue 0x10 2 3 86400');
    expect(result, contains('Value 3 set to 86400'));
    expect(battCheckInterval.current, 86400);
  });

  test('setValue invalid value', () async {
    String result = await zw.process('setValue 0x10 2 3 foobar');
    expect(result, contains('Invalid value "foobar"'));
  });

  test('setValue not found', () async {
    String result = await zw.process('setValue 0x10 2 12487 86400');
    expect(result, contains('Value 12487 not found'));
  });

  test('setValue read only', () async {
    String result = await zw.process('setValue 0x10 2 1 foobar');
    expect(result, contains('Value 1 is read only'));
  });
}

MockDevice newDevice(
    String name, int networkId, int nodeId, List<int> neighborIds) {
  MockDevice device = new MockDevice();
  device.name = name;
  when(device.networkId).thenReturn(networkId);
  when(device.nodeId).thenReturn(nodeId);
  when(device.manufacturerName).thenReturn('Some Company');
  when(device.productName).thenReturn('A Product');
  when(device.neighborIds).thenReturn(neighborIds);
  named(device, name: '$name(0x${networkId.toRadixString(16)}, $nodeId)');
  return device;
}

MockGroup newGroup(
    MockDevice device, String label, int index, List<int> nodeIds) {
  MockGroup group = new MockGroup(nodeIds);
  when(device.groups).thenReturn([group]);
  when(group.device).thenReturn(device);
  when(group.label).thenReturn(label);
  when(group.groupIndex).thenReturn(index);
  when(group.maxAssociations).thenReturn(7);
  return group;
}

MockBoolValue newBoolValue(
    MockDevice device, String label, int id, bool current,
    {String helpText,
    int index: 0,
    int pollIntensity: 0,
    bool readOnly: false,
    bool writeOnly: false}) {
  MockBoolValue value = new MockBoolValue();
  value.current = current;
  when(value.device).thenReturn(device);
  when(value.label).thenReturn(label);
  when(value.id).thenReturn(id);
  when(value.genre).thenReturn(ValueGenre.Basic);
  when(value.help).thenReturn(helpText);
  when(value.index).thenReturn(index);
  when(value.pollIntensity).thenReturn(pollIntensity);
  when(value.readOnly).thenReturn(readOnly);
  when(value.writeOnly).thenReturn(writeOnly);
  named(value, name: '$label($id, $index)');
  return value;
}

MockDoubleValue newDoubleValue(
    MockDevice device, String label, int id, double current,
    {String helpText,
    int index: 0,
    int pollIntensity: 0,
    bool readOnly: false,
    bool writeOnly: false}) {
  MockDoubleValue value = new MockDoubleValue();
  value.current = current;
  when(value.device).thenReturn(device);
  when(value.label).thenReturn(label);
  when(value.id).thenReturn(id);
  when(value.genre).thenReturn(ValueGenre.Basic);
  when(value.help).thenReturn(helpText);
  when(value.index).thenReturn(index);
  when(value.pollIntensity).thenReturn(pollIntensity);
  when(value.readOnly).thenReturn(readOnly);
  when(value.writeOnly).thenReturn(writeOnly);
  named(value, name: '$label($id, $index)');
  return value;
}

MockIntValue newIntValue(MockDevice device, String label, int id, int current,
    {String helpText,
    int index: 0,
    int pollIntensity: 0,
    bool readOnly: false,
    bool writeOnly: false}) {
  MockIntValue value = new MockIntValue();
  value.current = current;
  when(value.device).thenReturn(device);
  when(value.label).thenReturn(label);
  when(value.id).thenReturn(id);
  when(value.genre).thenReturn(ValueGenre.Basic);
  when(value.help).thenReturn(helpText);
  when(value.index).thenReturn(index);
  when(value.pollIntensity).thenReturn(pollIntensity);
  when(value.readOnly).thenReturn(readOnly);
  when(value.writeOnly).thenReturn(writeOnly);
  named(value, name: '$label($id, $index)');
  return value;
}

class MockBoolValue extends Mock implements BoolValue {
  bool current;
}

class MockDevice extends Mock implements Device {
  String name;
}

class MockDoubleValue extends Mock implements DoubleValue {
  double current;
}

class MockGroup extends Mock implements Group {
  List<int> _associations;

  MockGroup(this._associations);

  List<int> get associations => _associations;

  void addAssociation(int nodeId) {
    associations.add(nodeId);
  }

  void removeAssociation(int nodeId) {
    _associations.remove(nodeId);
  }
}

class MockIntValue extends Mock implements IntValue {
  int current;
}

class MockZWave extends Mock implements ZWave {}
