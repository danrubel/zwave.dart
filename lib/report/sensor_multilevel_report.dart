import 'package:zwave/message_consts.dart';
import 'package:zwave/report/zw_command_class_report.dart';

/// [SensorMultilevelReport] decodes the
/// COMMAND_CLASS_SENSOR_MULTILEVEL, SENSOR_MULTILEVEL_REPORT message
class SensorMultilevelReport extends ZwCommandClassReport {
  SensorMultilevelReport(List<int> data) : super(data);

  /// An identifier indicating the type of sensor whose value is being reported
  int get type => data[9];

  /// The type of sensor whose value is being reported
  SensorMultilevelType get sensorType => SensorMultilevelType.forTypeNum(type);

  /// An identifier indicating the scale associated with the value being reported
  int get scale => (data[10] >> 3) & 0x03;

  /// The # of decimal places in the value
  int get precision => (data[10] >> 5) & 0x03;

  /// The # of bytes comprising the value = 1, 2, 4
  int get valueSize => data[10] & 0x07;

  /// The value being reported
  num get value => bytesToNum(data.sublist(11, 11 + valueSize), precision);

  /// The value followed by the units or scale associated with the value
  String get valueWithUnits => '$value $units';

  /// A description of the scale associated with the value being reported
  String get units => sensorType.scaleTypeDescriptionFor(scale);
}
