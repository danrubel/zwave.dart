import 'package:zwave/capability/zw_node_mixin.dart';
import 'package:zwave/report/sensor_multilevel_report.dart';

abstract class Humidity implements ZwNodeMixin {
  num? humidity;

  @override
  void handleSensorMultilevelHumidity(SensorMultilevelReport report) {
    humidity = report.value;
  }
}
