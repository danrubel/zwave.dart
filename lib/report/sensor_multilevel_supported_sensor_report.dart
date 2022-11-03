import 'package:zwave/message_consts.dart';
import 'package:zwave/report/zw_command_class_report.dart';

/// [SensorMultilevelReport] decodes the
/// COMMAND_CLASS_SENSOR_MULTILEVEL, SENSOR_MULTILEVEL_SUPPORTED_SENSOR_REPORT message
class SensorMultilevelSupportedSensorReport extends ZwCommandClassReport {
  SensorMultilevelSupportedSensorReport(List<int> data) : super(data);
  /*
    0x01, // SOF
    0x0A, // length 10 excluding SOF and checksum
    0x00, // request
    0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
    0x00, // rxStatus
    0x14, // source node 20
    0x04, // command length 4
    0x31, // COMMAND_CLASS_SENSOR_MULTILEVEL
    0x02, // SENSOR_MULTILEVEL_SUPPORTED_SENSOR_REPORT
    // raw command class data
    0x11,
    0x04,
    0xC7, // checksum
  */

  List<SensorMultilevelType> get sensorTypes {
    var types = <SensorMultilevelType>[];
    var sensorTypeIndex = 1;
    outerLoop:
    for (var dataIndex = 9; dataIndex < data.length - 1; dataIndex++) {
      var byte = data[dataIndex];
      var bitMask = 0x01;
      for (var bitNum = 0; bitNum < 8; bitNum++) {
        var sensorType = sensorMultilevelTypes[sensorTypeIndex]!;
        if (byte & bitMask != 0) types.add(sensorType);
        bitMask = bitMask << 1;
        ++sensorTypeIndex;
        if (sensorTypeIndex == sensorMultilevelTypes.length) break outerLoop;
      }
    }
    return types;
  }
}
