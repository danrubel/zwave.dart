import 'package:zwave/capability/zw_node_mixin.dart';
import 'package:zwave/report/meter_report.dart';

abstract class Electrical implements ZwNodeMixin {
  num energy;

  @override
  void handleElectricalMeterReport(MeterReport report) {
    energy = report.value;
  }
}
