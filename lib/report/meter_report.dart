import 'package:zwave/report/zw_command_class_report.dart';

/// [MeterReport] decodes the
/// COMMAND_CLASS_METER, METER_REPORT message
class MeterReport extends ZwCommandClassReport {
  MeterReport(List<int> data) : super(data);

  int get rateType => (data[9] >> 5) & 0x03;

  /// Known types:
  /// - METER_ELECTRICAL
  int get type => data[9] & 0x07;

  /// Scales:
  /// - METER_ELECTRICAL:
  ///     0 = kWh
  int get scale => ((data[9] >> 5) & 0x04) + ((data[10] >> 3) & 0x03);

  /// [precision] is the # of decimal places in the value
  int get precision => (data[10] >> 5) & 0x07;

  /// # of bytes in the value = 1, 2, 4
  int get valueSize => data[10] & 0x07;

  num get value => bytesToNum(data.sublist(11, 11 + valueSize), precision);

  // optional
  int get deltaTime {
    int index = 11 + valueSize;
    if (data.length < index + 2) return null;
    return bytesToInt(data.sublist(index, index + 2));
  }

  // optional
  num get previousValue {
    int index = 13 + valueSize;
    if (data.length < index + valueSize) return null;
    return bytesToNum(data.sublist(index, index + valueSize), precision);
  }
}
