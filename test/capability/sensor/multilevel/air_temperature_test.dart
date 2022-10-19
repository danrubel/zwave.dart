import 'package:test/test.dart';
import 'package:zwave/capability/sensor/multilevel/air_temperature.dart';
import 'package:zwave/node/zw_node.dart';
import 'package:zwave/report/sensor_multilevel_report.dart';

import '../../../report/sensor_multilevel_report_test.dart';

main() {
  test('report', () {
    final node = TestAirTemperature(16);
    expect(node.temperature, isNull);
    node.handleSensorMultilevelAirTemperature(
        SensorMultilevelReport(airTempReportData));
    expect((node.temperature! * 10).round() / 10, 16.9);
  });
}

class TestAirTemperature extends ZwNode with AirTemperature {
  TestAirTemperature(int id) : super(id);
}
