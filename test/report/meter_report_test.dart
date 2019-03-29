import 'package:test/test.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/report/meter_report.dart';

main() {
  test('report 1', () {
    final report = new MeterReport(electricalReportData);
    expect(report.commandClass, COMMAND_CLASS_METER);
    expect(report.command, 0x02 /* METER_REPORT */);
    expect(report.sourceNode, 0x0B);
    expect(report.type, 1);
    expect(report.scale, 0);
    expect(report.rateType, 1);
    expect(report.precision, 3);
    expect(report.valueSize, 4);
    expect(report.value, 0x318064 / 1000);
    expect(report.deltaTime, 0x78);
    expect(report.previousValue, 0x318064 / 1000);
  });

  test('report 2', () {
    final report = new MeterReport(const <int>[
      0x01, // SOF
      0x14, // length excluding SOF and checksum
      0x00, // request
      0x04, // Application command
      0x00,
      0x0B, // Source node
      0x0E,
      COMMAND_CLASS_METER,
      0x02, // METER_REPORT
      0x21, 0x64,
      0x01, 0x31, 0x80, 0x64,
      0x02, 0x78,
      0x03, 0x31, 0x80, 0x64,
      0xE7, // Checksum
    ]);
    expect(report.commandClass, COMMAND_CLASS_METER);
    expect(report.command, 0x02 /* METER_REPORT */);
    expect(report.type, 1);
    expect(report.scale, 0);
    expect(report.rateType, 1);
    expect(report.precision, 3);
    expect(report.valueSize, 4);
    expect(report.value, 0x1318064 / 1000);
    expect(report.deltaTime, 0x278);
    expect((report.previousValue * 1000).round() / 1000, 0x3318064 / 1000);
  });
}

const electricalReportData = const <int>[
  0x01, // SOF
  0x14, // length excluding SOF and checksum
  0x00, // request
  0x04, // Application command
  0x00,
  0x0B, // Source node
  0x0E,
  COMMAND_CLASS_METER,
  0x02, // METER_REPORT
  0x21, 0x64, // type, scale, precision, value size
  0x00, 0x31, 0x80, 0x64,
  0x00, 0x78,
  0x00, 0x31, 0x80, 0x64,
  0xE7, // Checksum
];

const electricalNextReportData = const <int>[
  0x01, // SOF
  0x14, // length excluding SOF and checksum
  0x00, // request
  0x04, // Application command
  0x00,
  0x0B, // Source node
  0x0E,
  COMMAND_CLASS_METER,
  0x02, // METER_REPORT
  0x21, 0x64, // type, scale, precision, value size
  0x00, 0x32, 0x80, 0x64,
  0x00, 0x78,
  0x00, 0x31, 0x80, 0x64,
  0xE7, // Checksum
];
