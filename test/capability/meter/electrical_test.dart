import 'package:test/test.dart';
import 'package:zwave/capability/meter/electrical.dart';
import 'package:zwave/node/zw_node.dart';
import 'package:zwave/report/meter_report.dart';

import '../../report/meter_report_test.dart';

main() {
  test('report', () {
    final node = TestElectrical(11);
    expect(node.energy, isNull);
    node.handleElectricalMeterReport(MeterReport(electricalReportData));
    expect(node.energy, 3244.132);
  });
}

class TestElectrical extends ZwNode with Electrical {
  TestElectrical(int id) : super(id);
}
