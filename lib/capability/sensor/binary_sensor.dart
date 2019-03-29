import 'package:zwave/capability/zw_node_mixin.dart';
import 'package:zwave/report/basic_report.dart';
import 'package:zwave/report/sensor_binary_report.dart';

abstract class BinarySensor implements ZwNodeMixin {
  bool state;

  // TODO add BinarySensor tests

  @override
  void handleSensorBinaryReport(SensorBinaryReport report) {
    updateState(report.value > 0);
  }

  @override
  void handleBasicSet(BasicReport report) {
    updateState(report.value > 0);
  }

  void updateState(bool newState) {
    if (state != newState) stateChanged(newState);
  }

  void stateChanged(bool newState) {
    state = newState;
  }
}
