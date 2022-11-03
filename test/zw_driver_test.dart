import 'dart:async';

import 'package:zwave/message_consts.dart';
import 'package:zwave/src/zw_decoder.dart';
import 'package:zwave/zw_driver.dart';
import 'package:zwave/zw_exception.dart';
import 'package:test/test.dart';

main() {
  late ZwDriver driver;
  late TestHandler requestHandler;
  late TestHandler defaultResponseHandler;
  late TestPort port;

  void expectComplete() {
    expect(requestHandler.expectedData, isNull);
    expect(defaultResponseHandler.expectedData, isNull);
    expect(port.expectedMessages, isEmpty);
    expect(port.responses, isEmpty);
  }

  setUp(() {
    port = TestPort();
    driver = ZwDriver(port.sendData, sendTimeoutMsForTesting: 25);
    requestHandler = TestHandler();
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
      port.expectedMessages.add(ackMsg);
      requestHandler.expectedData = request;
      driver.handleDataFrame(request);
      expectComplete();
    });

    test('invalid', () {
      port.expectedMessages.add(nakMsg);
      driver.handleInvalidDataFrame();
      expectComplete();
    });
  });

  group('client', () {
    testValidMessageAndResponse() async {
      port.expectedMessages.add(versionRequest);
      port.responses.add(() {
        Future(driver.handleAck);
        Future(() {
          driver.handleDataFrame(versionResponse);
        });
      });
      port.expectedMessages.add(ackMsg);

      final completer = Completer<List<int>>();
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
      port.expectedMessages.add(versionRequest);

      final completer = Completer<List<int>>();
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
      port.expectedMessages.add(versionRequest);
      port.responses.add(() {
        Future(driver.handleNak);
      });

      final completer = Completer<List<int>>();
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
      port.expectedMessages.add(versionRequest);
      port.responses.add(() {
        Future(driver.handleCan);
      });

      final completer = Completer<List<int>>();
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
      port.expectedMessages.add(versionRequest);
      port.responses.add(() {
        Future(driver.handleAck);
      });

      final completer = Completer<List<int>>();
      await driver.send(versionRequest,
          responseCompleter: completer,
          responseTimeout: const Duration(milliseconds: 20));
      expect(port.expectedMessages, isEmpty);
      expect(port.responses, isEmpty);
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

const ackMsg = <int>[ACK];
const nakMsg = <int>[NAK];

const versionResponse = <int>[
  1, // SOF
  16, // length excluding SOF and checksum
  1, // response
  FUNC_ID_ZW_GET_VERSION,
  // version string 'Z-Wave 3.95'
  90, 45, 87, 97, 118, 101, 32, 51, 46, 57, 53, 0,
  1, // library type
  153 // checksum
];
const versionRequest = <int>[
  1, // SOF
  3, // length excluding SOF and checksum
  0, // request
  FUNC_ID_ZW_GET_VERSION,
  233 // checksum
];

class TestPort {
  final expectedMessages = <List<int>>[];
  final responses = <void Function()>[];

  void sendData(List<int> data) {
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
  }
}

class TestHandler {
  List<int>? expectedData;

  void process(List<int> data) {
    if (expectedData == null) fail('unexpected data: $data');
    expect(data, equals(expectedData));
    expectedData = null;
  }
}
