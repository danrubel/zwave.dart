import 'package:logging/logging.dart';
import 'package:zwave/command/zw_request.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/report/sensor_multilevel_supported_sensor_report.dart';
import 'package:zwave/util/packet_to_source.dart';

void main([List<String>? args]) {
  var request = ZwRequest(
      Logger('test'),
      20,
      buildSendDataRequest(20, [
        COMMAND_CLASS_SENSOR_MULTILEVEL,
        SENSOR_MULTILEVEL_SUPPORTED_GET_SENSOR,
      ]),
      processResponse: (data) => SensorMultilevelSupportedSensorReport(data),
      resultKey: SensorMultilevelSupportedSensorReport);
  print('Request: ${request.data}');

  var responseData = [1, 10, 0, 4, 0, 20, 4, 49, 2, 17, 4, 199];
  print('Supported sensor types response: $responseData');
  print(SensorMultilevelSupportedSensorReport(responseData).sensorTypes.map((t) => '${t.sensorTypeNum} - ${t.description}').join('\n'));
  print(packetToSource(responseData));

  responseData = [1, 14, 0, 4, 0, 4, 8, 49, 5, 4, 100, 0, 0, 0, 0, 173];
  print('');
  print('Response: $responseData');
  print(packetToSource(responseData));
}
