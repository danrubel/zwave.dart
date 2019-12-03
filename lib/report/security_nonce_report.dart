import 'package:zwave/capability/security.dart' show Nonce;
import 'package:zwave/report/zw_command_class_report.dart';

class SecurityNonceReport extends ZwCommandClassReport {
  SecurityNonceReport(List<int> data) : super(data);
  /*
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
   */

  Nonce get nonce => Nonce(data.sublist(9, 17));
}
