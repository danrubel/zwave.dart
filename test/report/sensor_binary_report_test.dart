import 'package:test/test.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/report/sensor_binary_report.dart';

main() {
  test('on', () {
    final report = new SensorBinaryReport(const <int>[
      0x01, // SOF
      0x09, // length excluding SOF and checksum
      0x00, // request
      FUNC_ID_APPLICATION_COMMAND_HANDLER,

      0x00, // rxStatus
      0x0F, // source node 15
      0x03, // command length

      COMMAND_CLASS_SENSOR_BINARY,
      0x03, // SENSOR_BINARY_REPORT
      0xFF, // state = on

      0x32, // Checksum
    ]);
    expect(report.commandClass, COMMAND_CLASS_SENSOR_BINARY);
    expect(report.command, 0x03 /* SENSOR_BINARY_REPORT */);
    expect(report.sourceNode, 0x0F);
    expect(report.value, 0xFF);
    expect(report.type, isNull);
  });

  test('off', () {
    final report = new SensorBinaryReport(const <int>[
      0x01, // SOF
      0x09, // length excluding SOF and checksum
      0x00, // request
      FUNC_ID_APPLICATION_COMMAND_HANDLER,

      0x00, // rxStatus
      0x0F, // source node 15
      0x03, // command length

      COMMAND_CLASS_SENSOR_BINARY,
      0x03, // SENSOR_BINARY_REPORT
      0x00, // state = off

      0xCD, // Checksum
    ]);
    expect(report.commandClass, COMMAND_CLASS_SENSOR_BINARY);
    expect(report.command, 0x03 /* SENSOR_BINARY_REPORT */);
    expect(report.sourceNode, 0x0F);
    expect(report.value, 0x00);
    expect(report.type, isNull);
  });
}
