import 'package:test/test.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/report/sensor_multilevel_report.dart';

main() {
  test('air temp F', () {
    final report = new SensorMultilevelReport(airTempReportData);
    expect(report.commandClass, COMMAND_CLASS_SENSOR_MULTILEVEL);
    expect(report.command, SENSOR_MULTILEVEL_REPORT);
    expect(report.sourceNode, 0x10);
    expect(report.type, SENSOR_MULTILEVEL_AIR_TEMPERATURE);
    expect(report.scale, 1);
    expect(report.precision, 1);
    expect(report.valueSize, 2);
    expect(report.value, 62.4);
  });

  test('humidity', () {
    final report = new SensorMultilevelReport(humidityReportData);
    expect(report.commandClass, COMMAND_CLASS_SENSOR_MULTILEVEL);
    expect(report.command, SENSOR_MULTILEVEL_REPORT);
    expect(report.sourceNode, 0x10);
    expect(report.type, SENSOR_MULTILEVEL_HUMIDITY);
    expect(report.scale, 0);
    expect(report.precision, 0);
    expect(report.valueSize, 1);
    expect(report.value, 31);
  });

  test('humidity', () {
    final report = new SensorMultilevelReport(powerReportData);
    expect(report.commandClass, COMMAND_CLASS_SENSOR_MULTILEVEL);
    expect(report.command, SENSOR_MULTILEVEL_REPORT);
    expect(report.sourceNode, 11);
    expect(report.type, SENSOR_MULTILEVEL_POWER);
    expect(report.scale, 0);
    expect(report.precision, 3);
    expect(report.valueSize, 4);
    expect(report.value, 0.387);
  });
}

const airTempReportData = const <int>[
  0x01, // SOF
  0x0C, // length excluding SOF and checksum
  0x00, // request
  FUNC_ID_APPLICATION_COMMAND_HANDLER,

  0x00, // rxStatus
  0x10, // source node 16
  0x06, // command length

  COMMAND_CLASS_SENSOR_MULTILEVEL,
  SENSOR_MULTILEVEL_REPORT,
  SENSOR_MULTILEVEL_AIR_TEMPERATURE,
  0x2A, // precision, scale, size - Fahrenheit, 2 bytes, 1 decimal place

  0x02, 0x70, // (2 * 256 + 112) / 10 = 62.4 F = 16.8889 C

  0x8C // checksum
];

const humidityReportData = const <int>[
  0x01, // SOF
  0x0B, // length excluding SOF and checksum
  0x00, // request
  FUNC_ID_APPLICATION_COMMAND_HANDLER,

  0x00, // rxStatus
  0x10, // source node 16
  0x05, // command length

  COMMAND_CLASS_SENSOR_MULTILEVEL,
  SENSOR_MULTILEVEL_REPORT,
  SENSOR_MULTILEVEL_HUMIDITY,
  0x01, // precision, scale, size - % humidity, 1 byte, 0 decimal places

  0x1F, // 31% humidity

  0xCA, // checksum
];

const powerReportData = const <int>[
  0x01, // SOF
  0x0E, // length excluding SOF and checksum
  0x00, // request
  FUNC_ID_APPLICATION_COMMAND_HANDLER,

  0x00, // rxStatus
  0x0B, // source node 11
  0x08, // command length

  COMMAND_CLASS_SENSOR_MULTILEVEL,
  SENSOR_MULTILEVEL_REPORT,
  SENSOR_MULTILEVEL_POWER,
  0x64, // precision, scale, size - Watts, 4 bytes, 3 decimal places

  0x00, 0x00, 0x01, 0x83, // (1 * 256 + 131) / 3 = 0.387 watts

  0x20, // checksum
];
