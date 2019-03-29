import 'package:test/test.dart';

import 'api_library_version_test.dart' as apiLibraryVersionTest;
import 'basic_report_test.dart' as basicReportTest;
import 'meter_report_test.dart' as meterReportTest;
import 'sensor_binary_report_test.dart' as sensorBinaryReportTest;
import 'sensor_multilevel_report_test.dart' as sensorMultilevelReportTest;

main() {
  group('ApiLibraryVersion', apiLibraryVersionTest.main);
  group('BasicReport', basicReportTest.main);
  group('MeterReport', meterReportTest.main);
  group('SensorBinaryReport', sensorBinaryReportTest.main);
  group('SensorMultilevelReport', sensorMultilevelReportTest.main);
}
