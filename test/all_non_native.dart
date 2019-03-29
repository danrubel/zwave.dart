import 'package:test/test.dart';

import 'capability/all.dart' as capabilityTests;
import 'command/all.dart' as commandTests;
import 'handler/application_update_handler_test.dart' as handlerTests;
import 'node/all.dart' as nodeTests;
import 'report/all.dart' as reportTests;
import 'src/zw_decoder_test.dart' as zwDecoderTest;
import 'zw_driver_test.dart' as zwDriverTest;
import 'zw_manager_test.dart' as zwManagerTest;

/// All the tests that can be run without building the native code
main() {
  group('capability', capabilityTests.main);
  group('command', commandTests.main);
  group('handler', handlerTests.main);
  group('node', nodeTests.main);
  group('report', reportTests.main);

  group('ZwDecoder', zwDecoderTest.main);
  group('ZwDriver', zwDriverTest.main);
  group('ZwManager', zwManagerTest.main);
}
