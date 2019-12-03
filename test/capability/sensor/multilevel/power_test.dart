import 'package:test/test.dart';
import 'package:zwave/capability/sensor/multilevel/power.dart';
import 'package:zwave/node/zw_node.dart';
import 'package:zwave/report/sensor_multilevel_report.dart';

import '../../../report/sensor_multilevel_report_test.dart';

main() {
  test('report', () {
    final node = TestPower(11);
    expect(node.power, isNull);
    node.handleSensorMultilevelPower(SensorMultilevelReport(powerReportData));
    expect(node.power, 0.387);
  });
}

class TestPower extends ZwNode with Power {
  TestPower(int id) : super(id);
}
