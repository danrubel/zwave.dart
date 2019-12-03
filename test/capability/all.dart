import 'package:test/test.dart';

import 'battery_test.dart' as battery_node;
import 'binary_switch_test.dart' as binary_switch;
import 'meter/electrical_test.dart' as electrical;
import 'network_management_proxy_test.dart' as net_management_proxy;
import 'node_naming_test.dart' as node_naming;
import 'security_test.dart' as security;
import 'sensor/binary_sensor_test.dart' as binary_sensor;
import 'sensor/multilevel/air_temperature_test.dart' as air_temperature;
import 'sensor/multilevel/humidity_test.dart' as humidity;
import 'sensor/multilevel/power_test.dart' as power;
import 'thermostat_test.dart' as thermostat;

main() {
  group('AirTemperature', air_temperature.main);
  group('BatteryNode', battery_node.main);
  group('BinarySensor', binary_sensor.main);
  group('BinarySwitch', binary_switch.main);
  group('Electrical', electrical.main);
  group('Humidity', humidity.main);
  group('NetworkManagementProxy', net_management_proxy.main);
  group('NodeNaming', node_naming.main);
  group('Power', power.main);
  group('Security', security.main);
  group('Thermostat', thermostat.main);
}
