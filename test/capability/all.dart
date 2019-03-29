import 'package:test/test.dart';

import 'battery_test.dart' as batteryNodeTest;
import 'binary_switch_test.dart' as binarySwitchTest;
import 'meter/electrical_test.dart' as electricalTest;
import 'node_naming_test.dart' as nodeNamingTest;
import 'sensor/binary_sensor_test.dart' as binarySensorTest;
import 'sensor/multilevel/air_temperature_test.dart' as airTempTest;
import 'sensor/multilevel/humidity_test.dart' as humidityTest;
import 'sensor/multilevel/power_test.dart' as powerTest;
import 'thermostat_test.dart' as thermostatTest;

main() {
  group('AirTemperature', airTempTest.main);
  group('BatteryNode', batteryNodeTest.main);
  group('BinarySensor', binarySensorTest.main);
  group('BinarySwitch', binarySwitchTest.main);
  group('Electrical', electricalTest.main);
  group('Humidity', humidityTest.main);
  group('NodeNaming', nodeNamingTest.main);
  group('Power', powerTest.main);
  group('Thermostat', thermostatTest.main);
}
