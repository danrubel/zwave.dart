import 'package:test/test.dart';

import 'api_library_version_test.dart' as api_library_version;
import 'basic_report_test.dart' as basic_report;
import 'meter_report_test.dart' as meter_report;
import 'security_nonce_report_test.dart' as security_nonce_report;
import 'security_message_encapsulation_test.dart' as security_message_encapsulation;
import 'sensor_binary_report_test.dart' as sensor_binary_report;
import 'sensor_multilevel_report_test.dart' as sensor_multilevel_report;

main() {
  group('ApiLibraryVersion', api_library_version.main);
  group('BasicReport', basic_report.main);
  group('MeterReport', meter_report.main);
  group('SecurityNonceReport', security_nonce_report.main);
  group('SecurityMessageEncapsulation', security_message_encapsulation.main);
  group('SensorBinaryReport', sensor_binary_report.main);
  group('SensorMultilevelReport', sensor_multilevel_report.main);
}
