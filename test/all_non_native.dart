import 'package:test/test.dart';

import 'capability/all.dart' as capability;
import 'command/all.dart' as command;
import 'handler/application_update_handler_test.dart' as handler;
import 'node/all.dart' as node;
import 'report/all.dart' as report;
import 'src/zw_decoder_test.dart' as zw_decoder;
import 'zw_driver_test.dart' as zw_driver;
import 'zw_manager_test.dart' as zw_manager;

/// All the tests that can be run without building the native code
main() {
  group('capability', capability.main);
  group('command', command.main);
  group('handler', handler.main);
  group('node', node.main);
  group('report', report.main);

  group('ZwDecoder', zw_decoder.main);
  group('ZwDriver', zw_driver.main);
  group('ZwManager', zw_manager.main);
}
