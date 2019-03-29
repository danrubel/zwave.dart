import 'package:test/test.dart';
import 'package:zwave/capability/sensor/multilevel/humidity.dart';
import 'package:zwave/node/zw_node.dart';
import 'package:zwave/report/sensor_multilevel_report.dart';

import '../../../report/sensor_multilevel_report_test.dart';

main() {
  test('report', () {
    final node = new TestHumidity(16);
    expect(node.humidity, isNull);
    node.handleSensorMultilevelHumidity(
        new SensorMultilevelReport(humidityReportData));
    expect(node.humidity, 31);
  });
}

class TestHumidity extends ZwNode with Humidity {
  TestHumidity(int id) : super(id);
}
