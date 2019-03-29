import 'package:test/test.dart';

import 'zw_command_test.dart' as zwCommandTest;
import 'zw_send_data_test.dart' as zwSendDataTest;

main() {
  group('ZwCommand', zwCommandTest.main);
  group('ZwSendDataTest', zwSendDataTest.main);
}
