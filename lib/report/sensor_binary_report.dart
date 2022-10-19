import 'package:zwave/report/zw_command_class_report.dart';

/// [SensorBinaryReport] decodes the
/// COMMAND_CLASS_SENSOR_BINARY, SENSOR_BINARY_REPORT message
class SensorBinaryReport extends ZwCommandClassReport {
  SensorBinaryReport(List<int> data) : super(data);

  /// 0x00 = idle
  /// 0xFF = sensor detected an event
  int get value => data[9];

  // optional
  int? get type => data.length > 11 ? data[10] : null;
}
