import 'package:zwave/capability/zw_node_mixin.dart';
import 'package:zwave/report/sensor_multilevel_report.dart';

abstract class Power implements ZwNodeMixin {
  num power;

  @override
  void handleSensorMultilevelPower(SensorMultilevelReport report) {
    power = report.value;
  }
}
