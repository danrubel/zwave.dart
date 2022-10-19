import 'package:zwave/report/zw_command_class_report.dart';

import '../message_consts.dart';

/// [SensorMultilevelReport] decodes the
/// COMMAND_CLASS_SENSOR_MULTILEVEL, SENSOR_MULTILEVEL_REPORT message
class SensorMultilevelReport extends ZwCommandClassReport {
  SensorMultilevelReport(List<int> data) : super(data);

  int get type => data[9];

  int get scale => (data[10] >> 3) & 0x03;

  /// [precision] is the # of decimal places in the value
  int get precision => (data[10] >> 5) & 0x03;

  /// # of bytes in the value = 1, 2, 4
  int get valueSize => data[10] & 0x07;

  num get value => bytesToNum(data.sublist(11, 11 + valueSize), precision);

  /// Return a human readable value with units
  String get valueWithUnits {
    String? text = units;
    return text != null ? '$value $text' : '$value';
  }

  /// Return human readable units or `null` if unknown
  String? get units {
    switch (type) {
      case SENSOR_MULTILEVEL_AIR_TEMPERATURE:
        switch (scale) {
          case 0:
            return 'Celcius';
          case 1:
            return 'Fahrenheit';
        }
        break;
      case SENSOR_MULTILEVEL_POWER:
        switch (scale) {
          case 0:
            return 'Watt';
          case 1:
            return 'Btu/hour';
        }
        break;
      case SENSOR_MULTILEVEL_HUMIDITY:
        switch (scale) {
          case 0:
            return 'Relative Humidity';
        }
        break;
    }
    return null;
  }
}
