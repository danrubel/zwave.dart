import 'dart:async';

import 'package:test/test.dart';
import 'package:zwave/node/sleepy_node.dart';
import 'package:zwave/zw_exception.dart';

import '../command/zw_command_test.dart';
import '../handler/command_handler_test.dart';
import '../zw_request_test.dart';

main() {
  new SleepyNodeTest().init();

  SleepyNode node;
  TestManager manager;
  TestCommand command;
  Future<List<int>> futureResult;

  setUpAll(() {
    manager = new TestManager();
    node = new SleepyNode(7);
    node.zwManager = manager;
  });

  test('queued send', () async {
    command = new TestCommand(31, [], expectedResponse: response1);

    futureResult = command.send(node.commandHandler);
    TimeoutException exception;
    try {
      await futureResult.timeout(const Duration(milliseconds: 1));
    } on TimeoutException catch (e) {
      exception = e;
    }

    // Expect command is queued and not sent
    expect(exception, isNotNull);
    expect(node.lastWakeupTime, isNull);
  });
}

class SleepyNodeTest extends ZwRequestTest {
  SleepyNode node;

  @override
  void defineTests() {
    setUp(() {
      node = new SleepyNode(7);
      manager.add(node);
    });

    test('init', () {
      expect(node.lastWakeupTime, isNull);
    });

    test('queued request', () async {
//      startLogger();

      const expectedResult = 'a response';
      Future<String> future = node.commandHandler.request(new TestRequest(
        manager,
        node.id,
        someRequest,
        processResponse: (data) {
          expect(data, someResponse);
          return expectedResult;
        },
      ));

      // Assert message has not been sent
      try {
        await future.timeout(const Duration(milliseconds: 2));
        fail('expected TimeoutException');
      } on TimeoutException catch (_) {
        // expected
      }
      expectComplete();
      expect(node.lastWakeupTime, isNull);

      expectingRequestResponse(someRequest, someResponse);
      expectingRequestSimpleResponse(wakeUpNoMoreRequest);

      // Simulate wakeup
      await node.handleWakeUpNotification(null);
      String result;
      try {
        result = await future;
      } on ZwException catch (ex, trace) {
        fail('$ex\n$trace');
      }

      // Assert message has been sent
      expectComplete();
      expect(result, expectedResult);
    });
  }
}

const someRequest = [
  0x01, // SOF
  0x08, // length excluding SOF and checksum
  0x00, // request
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x07, // source node 7
  0x02, // command length
  0x80,
  0x02,
  0x25, // transmit options
  0x48, // checksum
];
const someResponse = [
  0x01, // SOF
  0x08, // length excluding SOF and checksum
  0x01, // response
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x07, // source node 7
  0x02, // command length
  0x12,
  0x09,
  0x25, // transmit options
  0x48, // checksum
];
const wakeUpNoMoreRequest = [
  0x01, // SOF
  0x08, // length excluding SOF and checksum
  0x00, // request
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x07, // source node 7
  0x02, // command length
  0x84, // COMMAND_CLASS_WAKE_UP,
  0x08, // WAKE_UP_NO_MORE_INFORMATION
  0x25, // transmit options
  0x48, // checksum
];
const response1 = const <int>[1, 2, 3, 4, 5];
