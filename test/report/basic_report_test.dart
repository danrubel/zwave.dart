import 'package:test/test.dart';
import 'package:zwave/report/basic_report.dart';

main() {
  test('55 %', () {
    final report = BasicReport(const <int>[
      0x01, // SOF
      0x09, // length excluding SOF and checksum
      0x00, // request
      0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
      0x00, // rxStatus
      0x0F, // source node 15
      0x03, // command length
      0x20, // COMMAND_CLASS_BASIC
      0x81, // ?????????????
      0x37, // value = on
      0xA0, // checksum
    ]);
    expect(report.sourceNode, 15);
    expect(report.value, 55);
  });
}
