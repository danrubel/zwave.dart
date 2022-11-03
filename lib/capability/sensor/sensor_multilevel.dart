import 'package:zwave/capability/zw_node_mixin.dart';
import 'package:zwave/command/zw_request.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/report/sensor_multilevel_report.dart';
import 'package:zwave/report/sensor_multilevel_supported_sensor_report.dart';

abstract class SensorMultilevel implements ZwNodeMixin {
  /// The supported sensor report or `null` if none
  SensorMultilevelSupportedSensorReport? supportedSensorReport;

  /// Request, cache, and return a supported sensor report
  Future<SensorMultilevelSupportedSensorReport>
      requestSupportedSensorReport() async =>
          supportedSensorReport = await commandHandler!
              .request<SensorMultilevelSupportedSensorReport>(ZwRequest(
                  logger,
                  id,
                  buildSendDataRequest(id, [
                    COMMAND_CLASS_SENSOR_MULTILEVEL,
                    SENSOR_MULTILEVEL_SUPPORTED_GET_SENSOR,
                  ]),
                  processResponse: (data) =>
                      SensorMultilevelSupportedSensorReport(data),
                  resultKey: SensorMultilevelSupportedSensorReport));

  /// Request, if not already cached, and return the supported sensor types
  Future<List<SensorMultilevelType>> get sensorTypes async =>
      (supportedSensorReport ?? await requestSupportedSensorReport())
          .sensorTypes;

  /// A map of sensor type to cached sensor value reports
  final sensorReports = <SensorMultilevelType, SensorMultilevelReport>{};

  /// Request, cache, and return a sensor value report for the specified sensor type and scale
  Future<SensorMultilevelReport> requestSensorReport(
          SensorMultilevelType sensorType,
          {int? scaleType}) async =>
      sensorReports[sensorType] =
          await commandHandler!.request<SensorMultilevelReport>(ZwRequest(
              logger,
              id,
              buildSendDataRequest(id, [
                COMMAND_CLASS_SENSOR_MULTILEVEL,
                SENSOR_MULTILEVEL_GET,
                sensorType.sensorTypeNum,
                ((scaleType ?? 0) & 0x03) << 3,
              ]),
              processResponse: (data) => SensorMultilevelReport(data),
              resultKey: sensorType));

  /// Request, if not already cached, and return the supported sensor types
  Future<SensorMultilevelReport> sensorReport(SensorMultilevelType sensorType,
          {int? scaleType}) async =>
      sensorReports[sensorType] ??
      await requestSensorReport(sensorType, scaleType: scaleType);

  @override
  void handleSensorMultilevelSupportedSensorReport(
      SensorMultilevelSupportedSensorReport report) {
    supportedSensorReport = report;
  }

  @override
  void handleSensorMultilevelReport(SensorMultilevelReport report) {
    sensorReports[report.sensorType] = report;
  }
}
