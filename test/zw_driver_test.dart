import 'dart:async';

import 'package:zwave/message_consts.dart';
import 'package:zwave/src/zw_decoder.dart';
import 'package:zwave/zw_driver.dart';
import 'package:zwave/zw_exception.dart';
import 'package:test/test.dart';

main() {
  ZwDriver driver;
  TestHandler requestHandler;
  TestHandler defaultResponseHandler;
  TestController controller;

  void expectComplete() {
    expect(requestHandler.expectedData, isNull);
    expect(defaultResponseHandler.expectedData, isNull);
    expect(controller.expectedMessages, isEmpty);
    expect(controller.responses, isEmpty);
  }

  setUp(() {
    controller = TestController();
    driver = new ZwDriver(controller.sendData, sendTimeoutMsForTesting: 25);
    requestHandler = new TestHandler();
    driver.requestHandler = requestHandler.process;
    defaultResponseHandler = TestHandler();
    driver.defaultResponseHandler = defaultResponseHandler.process;
  });

  group('controller', () {
    test('valid', () {
      var request = const <int>[
        // application command handler request
        1, 20, 0, 4, 0, 11,
        14, 50, 2, 33, 100, 0, 49, 128, 100, 0, 120, 0, 49, 128, 100, 231
      ];
      controller.expectedMessages.add(ackMsg);
      requestHandler.expectedData = request;
      driver.handleDataFrame(request);
      expectComplete();
    });

    test('invalid', () {
      controller.expectedMessages.add(nakMsg);
      driver.handleInvalidDataFrame();
      expectComplete();
    });
  });

  group('client', () {
    testValidMessageAndResponse() async {
      controller.expectedMessages.add(versionRequest);
      controller.responses.add(() {
        new Future(driver.handleAck);
        new Future(() {
          driver.handleDataFrame(versionResponse);
        });
      });
      controller.expectedMessages.add(ackMsg);

      final completer = new Completer<List<int>>();
      await driver.send(versionRequest,
          responseCompleter: completer,
          responseTimeout: const Duration(milliseconds: 20));
      List<int> response = await completer.future;
      expect(response, equals(versionResponse));
      expectComplete();
    }

    test('valid', () async {
      await testValidMessageAndResponse();
      await testValidMessageAndResponse();
    });

    test('send timeout', () async {
      controller.expectedMessages.add(versionRequest);

      final completer = new Completer<List<int>>();
      try {
        await driver.send(versionRequest,
            responseCompleter: completer,
            responseTimeout: const Duration(milliseconds: 20));
        fail('expected exception');
      } on ZwException {
        // expected
      }
      expectComplete();
      await testValidMessageAndResponse();
    });

    test('send corrupted', () async {
      controller.expectedMessages.add(versionRequest);
      controller.responses.add(() {
        new Future(driver.handleNak);
      });

      final completer = new Completer<List<int>>();
      try {
        await driver.send(versionRequest,
            responseCompleter: completer,
            responseTimeout: const Duration(milliseconds: 20));
        fail('expected exception');
      } on ZwException {
        // expected
      }
      expectComplete();
      await testValidMessageAndResponse();
    });

    test('send canceled', () async {
      controller.expectedMessages.add(versionRequest);
      controller.responses.add(() {
        new Future(driver.handleCan);
      });

      final completer = new Completer<List<int>>();
      try {
        await driver.send(versionRequest,
            responseCompleter: completer,
            responseTimeout: const Duration(milliseconds: 20));
        fail('expected exception');
      } on ZwException {
        // expected
      }
      expectComplete();
      await testValidMessageAndResponse();
    });

    test('response timeout', () async {
      controller.expectedMessages.add(versionRequest);
      controller.responses.add(() {
        new Future(driver.handleAck);
      });

      final completer = new Completer<List<int>>();
      await driver.send(versionRequest,
          responseCompleter: completer,
          responseTimeout: const Duration(milliseconds: 20));
      expect(controller.expectedMessages, isEmpty);
      expect(controller.responses, isEmpty);
      try {
        await completer.future;
        fail('expected exception');
      } on ZwException {
        // expected
      }
      expectComplete();
      await testValidMessageAndResponse();
    });
  });
}

const ackMsg = const <int>[ACK];
const nakMsg = const <int>[NAK];

const versionResponse = const <int>[
  1, // SOF
  16, // length excluding SOF and checksum
  1, // response
  FUNC_ID_ZW_GET_VERSION,
  // version string 'Z-Wave 3.95'
  90, 45, 87, 97, 118, 101, 32, 51, 46, 57, 53, 0,
  1, // library type
  153 // checksum
];
const versionRequest = const <int>[
  1, // SOF
  3, // length excluding SOF and checksum
  0, // request
  FUNC_ID_ZW_GET_VERSION,
  233 // checksum
];

class TestController {
  final expectedMessages = <List<int>>[];
  final responses = <void Function()>[];

  bool sendData(List<int> data, String name) {
    if (expectedMessages.isEmpty) fail('unexpected send: $data');
    final expectedMsg = expectedMessages.removeAt(0);
    expect(data, equals(expectedMsg));
    if (responses.isNotEmpty) {
      // No return message for ACK from manager/driver
      // unless next expected message is also an ACK
      if (data != ackMsg ||
          (expectedMsg.isNotEmpty && expectedMessages[0] == ackMsg))
        responses.removeAt(0)();
    }
    return true;
  }
}

class TestHandler {
  List<int> expectedData;

  void process(List<int> data) {
    if (expectedData == null) fail('unexpected data: $data');
    expect(data, equals(expectedData));
    expectedData = null;
  }
}
