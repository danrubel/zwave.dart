import 'package:test/test.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/report/security_nonce_report.dart';

main() {
  test('nonce report', () {
    final report = SecurityNonceReport(nonceReportData);
    expect(report.commandClass, COMMAND_CLASS_SECURITY);
    expect(report.command, SECURITY_NONCE_REPORT);
    expect(report.sourceNode, 4);
    var nonce = report.nonce;
    expect(nonce.values, [1, 2, 3, 4, 5, 6, 7, 8]);
  });
}

const nonceReportData = <int>[
  0x01, // SOF
  0x10, // length 16 excluding SOF and checksum
  0x00, // request
  0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
  0x00, // rxStatus
  0x04, // source node 4
  0x0A, // command length 10
  0x98, // COMMAND_CLASS_SECURITY
  0x80, // SECURITY_NONCE_REPORT
  0x01,
  0x02,
  0x03,
  0x04,
  0x05,
  0x06,
  0x07,
  0x08,
  0xFF, // checksum
];
