import 'package:test/test.dart';
import 'package:zwave/capability/sensor/binary_sensor.dart';
import 'package:zwave/node/zw_node.dart';

main() {
  group('handleBasicSet', () {
    test('open', () {
      final sensor = TestBinarySensor(18);
      expect(sensor.state, isNull);
      sensor.dispatchApplicationCommand(
          const [1, 9, 0, 4, 0, 18, 3, 32, 1, 255, 61]);
      expect(sensor.state, isTrue);
    });
    test('closed', () {
      final sensor = TestBinarySensor(18);
      expect(sensor.state, isNull);
      sensor.dispatchApplicationCommand(
          const [1, 9, 0, 4, 0, 18, 3, 32, 1, 0, 194]);
      expect(sensor.state, isFalse);
    });
  });
  group('handleSensorBinaryReport', () {
    test('open', () {
      final sensor = TestBinarySensor(18);
      expect(sensor.state, isNull);
      sensor.dispatchApplicationCommand(
          const [1, 9, 0, 4, 0, 14, 3, 48, 3, 255, 51]);
      expect(sensor.state, isTrue);
    });
    test('closed', () {
      final sensor = TestBinarySensor(18);
      expect(sensor.state, isNull);
      sensor.dispatchApplicationCommand(
          const [1, 9, 0, 4, 0, 14, 3, 48, 3, 0, 204]);
      expect(sensor.state, isFalse);
    });
  });
}

class TestBinarySensor extends ZwNode with BinarySensor {
  TestBinarySensor(int id) : super(id);
}
