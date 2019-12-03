import 'package:zwave/report/zw_command_class_report.dart';

class SecurityMessageEncapsulation extends ZwCommandClassReport {
  SecurityMessageEncapsulation(List<int> data) : super(data);
  /*
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
   */

  List<int> get initVector => data.sublist(9, 17);
  List<int> get encryptedData => data.sublist(17, data.length - 10);
  int get nonceKey => data[data.length - 10];
  List<int> get authCode => data.sublist(data.length - 9, data.length - 1);
}
