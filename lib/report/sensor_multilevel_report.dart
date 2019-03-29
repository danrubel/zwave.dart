import 'package:zwave/report/zw_command_class_report.dart';

/// [SensorMultilevelReport] decodes the
/// COMMAND_CLASS_SENSOR_MULTILEVEL, SENSOR_MULTILEVEL_REPORT message
class SensorMultilevelReport extends ZwCommandClassReport {
  SensorMultilevelReport(List<int> data) : super(data);

  /// Known types:
  /// - SENSOR_MULTILEVEL_AIR_TEMPERATURE
  /// - SENSOR_MULTILEVEL_POWER
  /// - SENSOR_MULTILEVEL_HUMIDITY
  int get type => data[9];

  /// Scales:
  /// - SENSOR_MULTILEVEL_AIR_TEMPERATURE:
  ///    0 = Celcius
  ///    1 = Fahrenheit
  /// - SENSOR_MULTILEVEL_POWER:
  ///    0 = Watt
  ///    1 = Btu/h
  /// - SENSOR_MULTILEVEL_HUMIDITY:
  ///    0 = relative humidity
  int get scale => (data[10] >> 3) & 0x03;

  /// [precision] is the # of decimal places in the value
  int get precision => (data[10] >> 5) & 0x03;

  /// # of bytes in the value = 1, 2, 4
  int get valueSize => data[10] & 0x07;

  num get value => bytesToNum(data.sublist(11, 11 + valueSize), precision);
}
