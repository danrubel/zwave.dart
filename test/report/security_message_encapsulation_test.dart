import 'package:test/test.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/report/security_message_encapsulation.dart';

main() {
  test('nonce report', () {
    final report = SecurityMessageEncapsulation(securityMessageEncapsulation);
    expect(report.commandClass, COMMAND_CLASS_SECURITY);
    expect(report.command, SECURITY_MESSAGE_ENCAPSULATION);
    expect(report.sourceNode, 5);
    expect(report.initVector, [1, 2, 3, 4, 5, 6, 7, 8]);
    expect(report.encryptedData, [0x2C, 0x8B, 0xD2, 0xAB]);
    expect(report.nonceKey, 22);
    expect(report.authCode, [9, 10, 11, 12, 13, 14, 15, 16]);
  });
}

const securityMessageEncapsulation = <int>[
  0x01, // SOF
  0x1D, // length 29 excluding SOF and checksum
  0x00, // request
  0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
  0x00, // rxStatus
  0x05, // source node 5
  0x17, // command length 23
  0x98, // COMMAND_CLASS_SECURITY
  0x81, // SECURITY_MESSAGE_ENCAPSULATION
  0x01, // init vector byte #1
  0x02, // init vector byte #2
  0x03, // init vector byte #3
  0x04, // init vector byte #4
  0x05, // init vector byte #5
  0x06, // init vector byte #6
  0x07, // init vector byte #7
  0x08, // init vector byte #8
  // begin encrypted payload
  0x2C, // bit fields
  0x8B,
  0xD2,
  0xAB,
  // end payload
  0x16, // receiver nonce key
  0x09, // auth code byte #1
  0x0A, // auth code byte #2
  0x0B, // auth code byte #3
  0x0C, // auth code byte #4
  0x0D, // auth code byte #5
  0x0E, // auth code byte #6
  0x0F, // auth code byte #7
  0x10, // auth code byte #8
  0x35, // checksum
];
