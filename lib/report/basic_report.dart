import 'package:zwave/report/zw_command_class_report.dart';

class BasicReport extends ZwCommandClassReport {
  BasicReport(List<int> data) : super(data);
  /*
    0x01, // SOF
    0x09, // length excluding SOF and checksum
    0x00, // request
    0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
    0x00, // rxStatus
    0x0F, // source node 15
    0x03, // command length
    0x20, // COMMAND_CLASS_BASIC
    0x01, // BASIC_SET (or BASIC_REPORT)
    0xFF, // value = on
    0x20, // checksum
   */

  /// The current value:
  /// 0x00 = off
  /// 0x01 = 1% on
  /// ...  = x% on
  /// 0x63 = 99% on
  /// ... reserved ...
  /// 0xFE = unknown
  /// 0xFF = on
  int get value => data[9];
}
