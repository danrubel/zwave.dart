import 'package:test/test.dart';

import 'battery_test.dart' as battery_node;
import 'binary_switch_test.dart' as binary_switch;
import 'meter/electrical_test.dart' as electrical;
import 'network_management_proxy_test.dart' as net_management_proxy;
import 'node_naming_test.dart' as node_naming;
import 'notification_report_test.dart' as notification_report;
import 'security_test.dart' as security;
import 'sensor/binary_sensor_test.dart' as binary_sensor;
import 'sensor/sensor_multilevel_test.dart' as sensor_multilevel;
import 'thermostat_test.dart' as thermostat;

void main() {
  group('BatteryNode', battery_node.main);
  group('BinarySensor', binary_sensor.main);
  group('BinarySwitch', binary_switch.main);
  group('Electrical', electrical.main);
  group('NetworkManagementProxy', net_management_proxy.main);
  group('NodeNaming', node_naming.main);
  group('NotificationReport', notification_report.main);
  group('Security', security.main);
  group('SensorMultilevel', sensor_multilevel.main);
  group('Thermostat', thermostat.main);
}
