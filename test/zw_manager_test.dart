import 'dart:async';

import 'package:test/test.dart';
import 'package:zwave/command/zw_request.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/zw_exception.dart';

import 'command/zw_command_test.dart' show TestCommand;
import 'zw_driver_test.dart';
import 'zw_request_test.dart';

void main() {
  ZwManagerTest().init();
}

class ZwManagerTest extends ZwRequestTest {
  void defineTests() {
    group('version', () {
      test('valid', () async {
        expectingRequestResponse(versionRequest, versionResponse);

        final version = await manager.apiLibraryVersion();
        expect(version.version, 'Z-Wave 3.95');
        expect(version.libraryType, 1);
        expectComplete();
      });

      test('canceled', () async {
        // Send plus 3 retries
        port.expectedMessages
          ..add(versionRequest)
          ..add(versionRequest)
          ..add(versionRequest)
          ..add(versionRequest);
        port.responses
          ..add(sendCancel)
          ..add(sendCancel)
          ..add(sendCancel)
          ..add(sendCancel);

        try {
          await manager.apiLibraryVersion();
          fail('expected exception');
        } on ZwException catch (_) {
          // exception expected
        }
        expectComplete();
      });

      test('corrupted', () async {
        // Send plus 3 retries
        port.expectedMessages
          ..add(versionRequest)
          ..add(versionRequest)
          ..add(versionRequest)
          ..add(versionRequest);
        port.responses..add(sendNak)..add(sendNak)..add(sendNak)..add(sendNak);

        try {
          await manager.apiLibraryVersion();
          fail('expected exception');
        } on ZwException catch (_) {
          // exception expected
        }
        expectComplete();
      });

      test('send timeout', () async {
        // Send plus 3 retries
        port.expectedMessages
          ..add(versionRequest)
          ..add(versionRequest)
          ..add(versionRequest)
          ..add(versionRequest);

        try {
          await TestCommand(FUNC_ID_ZW_GET_VERSION, null).send(manager);
          fail('expected exception');
        } on ZwException {
          // expected
        }
        expectComplete();
      });

      test('response timeout', () async {
        expectingRequestNoResponse(versionRequest);

        try {
          await TestCommand(FUNC_ID_ZW_GET_VERSION, null).send(manager);
          fail('expected exception');
        } on ZwException catch (error) {
          expect(error, ZwException.responseTimeout);
        }
        expectComplete();
      });
    });

    group('send', () {
      test('without ZwCommand.send', () async {
        ZwException? exception;
        try {
          await manager.send(TestCommand(1, null));
        } on ZwException catch (e) {
          exception = e;
        }
        expect(exception, isNotNull);
      });

      test('null data', () async {
        ZwException? exception;
        try {
          await TestBadDataCommand(1, null).send(manager);
        } on ZwException catch (e) {
          exception = e;
        }
        expect(exception, isNotNull);
      });

      test('process response exception', () async {
        port.expectedMessages.add(request1);
        port.responses.add(() {
          sendAck();
          sendData(response1Simple);
        });
        port.expectedMessages.add(ackMsg);
        String? exception;
        try {
          await TestProcessResponseFailCommand(1, null).send(manager);
        } catch (e) {
          exception = e as String;
        }
        expect(exception, TestProcessResponseFailCommand.exception);
      });

      test('sequential', () async {
//        startLogger();

        // 3 sends plus 1 retry
        port.expectedMessages
          ..add(request1)
          ..add(request1) // retry
          ..add(ackMsg)
          ..add(request2)
          ..add(ackMsg)
          ..add(request3)
          ..add(ackMsg);

        // 3 responses plus 1 NAK
        port.responses
          ..add(sendNak)
          ..add(() {
            sendAck();
            sendData(response1Simple);
          })
          ..add(() {
            sendAck();
            sendData(response2Simple);
          })
          ..add(() {
            sendAck();
            sendData(response3Simple);
          });

        final command1 =
            TestCommand(1, null, expectedResponse: response1Simple);
        final command2 =
            TestCommand(2, null, expectedResponse: response2Simple);
        final command3 =
            TestCommand(3, null, expectedResponse: response3Simple);

        await command1.send(manager);
        await command2.send(manager);
        await command3.send(manager);
        expectComplete();
      });

      test('simultaneous', () async {
        // 3 sends plus 1 retry
        port.expectedMessages
          ..add(request1)
          ..add(request1) // retry
          ..add(ackMsg)
          ..add(request2)
          ..add(ackMsg)
          ..add(request3)
          ..add(ackMsg);

        // 3 responses plus 1 NAK
        port.responses
          ..add(sendNak)
          ..add(() {
            sendAck();
            sendData(response1Simple);
          })
          ..add(() {
            sendAck();
            sendData(response2Simple);
          })
          ..add(() {
            sendAck();
            sendData(response3Simple);
          });

        final command1 =
            TestCommand(1, null, expectedResponse: response1Simple);
        final command2 =
            TestCommand(2, null, expectedResponse: response2Simple);
        final command3 =
            TestCommand(3, null, expectedResponse: response3Simple);

        Future<void> result1 = command1.send(manager);
        Future<void> result2 = command2.send(manager);
        Future<void> result3 = command3.send(manager);

        await result3;
        expectComplete();
        await result2;
        await result1;
      });
    });

    group('request', () {
      test('null data', () async {
        dynamic exception;
        try {
          await manager.request(TestRequest(manager, null, null));
        } catch (e) {
          exception = e;
        }
        expect(exception, isNotNull);
      });

      test('null in data', () async {
        dynamic exception;
        try {
          await manager.request(
              ZwRequest(manager.logger, null, buildFunctRequest(7, [null])));
        } catch (e) {
          exception = e;
        }
        expect(exception, isNotNull);
      });

      test('process simple response', () async {
        port.expectedMessages.add(request1);
        port.responses.add(() {
          sendAck();
          sendData(response1Simple);
        });
        port.expectedMessages.add(ackMsg);
        bool processResponseCalled = false;
        await manager
            .request(TestRequest(manager, 8, request1, processResponse: (data) {
          processResponseCalled = true;
          return null;
        }));
        expect(processResponseCalled, isFalse);
        expectComplete();
      });

      test('process complex response', () async {
        port.expectedMessages.add(request1);
        port.responses.add(() {
          sendAck();
          sendData(response1Complex);
        });
        port.expectedMessages.add(ackMsg);
        const expectedResult = 'expected result';
        bool processResponseCalled = false;
        final request =
            TestRequest(manager, 8, request1, processResponse: (data) {
          expect(processResponseCalled, isFalse);
          processResponseCalled = true;
          expect(data, response1Complex);
          return expectedResult;
        });
        String? result = await manager.request(request);
        expect(result, expectedResult);
        expect(processResponseCalled, isTrue);
        expectComplete();
      });

      test('process response exception', () async {
        port.expectedMessages.add(request1);
        port.responses.add(() {
          sendAck();
          sendData(response1Complex);
        });
        port.expectedMessages.add(ackMsg);
        const expectedException = 'some random exception';
        String? exception;
        try {
          await manager.request(ZwRequest(
              manager.logger, 1, buildFunctRequest(1),
              processResponse: (data) => throw expectedException));
        } on String catch (e) {
          exception = e;
        }
        expect(exception, expectedException);
      });

      test('process delayed response timeout', () async {
        port.expectedMessages.add(request1);
        port.responses.add(() {
          sendAck();
          sendData(response1Simple);
        });
        port.expectedMessages.add(ackMsg);

        const resultKey = 'some key';
        bool processResponseCalled = false;
        final request =
            TestRequest(manager, 8, request1, processResponse: (data) {
          expect(processResponseCalled, isFalse);
          processResponseCalled = true;
          return null;
        }, resultKey: resultKey);

        /// Expect a timeout waiting for the result
        try {
          await manager.request(request);
          fail('expected ZwException.resultTimeout exception');
        } on ZwException catch (e) {
          expect(e, ZwException.resultTimeout);
        }
        expect(processResponseCalled, isFalse);
        expectComplete();
      });

      test('process delayed response', () async {
//        startLogger();

        port.expectedMessages.add(request1);
        port.responses.add(() {
          sendAck();
          sendData(response1Simple);
        });
        port.expectedMessages.add(ackMsg);

        bool processResponseCalled = false;
        final request =
            TestRequest(manager, 8, request1, processResponse: (data) {
          expect(processResponseCalled, isFalse);
          processResponseCalled = true;
          return null;
        }, resultKey: String);

        /// Assert result is not available yet
        var future = manager.request(request);
        try {
          await future.timeout(const Duration(milliseconds: 2));
          fail('expected TimeoutException');
        } on TimeoutException catch (_) {
          // expected
        }
        expect(processResponseCalled, isFalse);
        expectComplete();

        // Send the delayed response
        const expectedResult = 'some random result';
        manager.processedResult<String>(8, expectedResult);
        String? result;
        try {
          result = await future;
        } on ZwException catch (ex, trace) {
          fail('$ex\n$trace');
        }
        expect(result, expectedResult);
        expect(processResponseCalled, isFalse);
        expectComplete();
      });

      test('sequential', () async {
        // 3 sends plus 1 retry
        port.expectedMessages
          ..add(request1)
          ..add(request1) // retry
          ..add(ackMsg)
          ..add(request2)
          ..add(ackMsg)
          ..add(request3)
          ..add(ackMsg);

        // 3 responses plus 1 NAK
        port.responses
          ..add(sendNak)
          ..add(() {
            sendAck();
            sendData(response1Complex);
          })
          ..add(() {
            sendAck();
            sendData(response2Complex);
          })
          ..add(() {
            sendAck();
            sendData(response3Complex);
          });

        const expectedResult1 = 'result from request 1';
        bool called1 = false;
        final req1 = TestRequest(manager, 1, request1, processResponse: (data) {
          expect(data, response1Complex);
          expect(called1, isFalse);
          called1 = true;
          return expectedResult1;
        });

        const expectedResult2 = 'result from request 2';
        bool called2 = false;
        final req2 = TestRequest(manager, 1, request2, processResponse: (data) {
          expect(data, response2Complex);
          expect(called2, isFalse);
          called2 = true;
          return expectedResult2;
        });

        const expectedResult3 = 'result from request 3';
        bool called3 = false;
        final req3 = TestRequest(manager, 1, request3, processResponse: (data) {
          expect(data, response3Complex);
          expect(called3, isFalse);
          called3 = true;
          return expectedResult3;
        });

        String? result1 = await manager.request(req1);
        String? result2 = await manager.request(req2);
        String? result3 = await manager.request(req3);

        expect(called1, isTrue);
        expect(result1, expectedResult1);
        expect(called2, isTrue);
        expect(result2, expectedResult2);
        expect(called3, isTrue);
        expect(result3, expectedResult3);
        expectComplete();
      });

      test('simultaneous', () async {
        // 3 sends plus 1 retry
        port.expectedMessages
          ..add(request1)
          ..add(request1) // retry
          ..add(ackMsg)
          ..add(request2)
          ..add(ackMsg)
          ..add(request3)
          ..add(ackMsg);

        // 3 responses plus 1 NAK
        port.responses
          ..add(sendNak)
          ..add(() {
            sendAck();
            sendData(response1Complex);
          })
          ..add(() {
            sendAck();
            sendData(response2Complex);
          })
          ..add(() {
            sendAck();
            sendData(response3Complex);
          });

        const expectedResult1 = 'result from request 1';
        bool called1 = false;
        final req1 = TestRequest(manager, 1, request1, processResponse: (data) {
          expect(data, response1Complex);
          expect(called1, isFalse);
          called1 = true;
          return expectedResult1;
        });

        const expectedResult2 = 'result from request 2';
        bool called2 = false;
        final req2 = TestRequest(manager, 1, request2, processResponse: (data) {
          expect(data, response2Complex);
          expect(called2, isFalse);
          called2 = true;
          return expectedResult2;
        });

        const expectedResult3 = 'result from request 3';
        bool called3 = false;
        final req3 = TestRequest(manager, 1, request3, processResponse: (data) {
          expect(data, response3Complex);
          expect(called3, isFalse);
          called3 = true;
          return expectedResult3;
        });

        Future<String?> future1 = manager.request(req1);
        Future<String?> future2 = manager.request(req2);
        Future<String?> future3 = manager.request(req3);

        String? result3 = await future3;
        expectComplete();
        String? result2 = await future2;
        String? result1 = await future1;

        expect(called1, isTrue);
        expect(result1, expectedResult1);
        expect(called2, isTrue);
        expect(result2, expectedResult2);
        expect(called3, isTrue);
        expect(result3, expectedResult3);
      });
    });
  }
}

class TestBadDataCommand extends TestCommand {
  TestBadDataCommand(int functId, List<int>? functParam)
      : super(functId, functParam);

  @override
  List<int>? get data => null;
}

class TestProcessResponseFailCommand extends TestCommand {
  static const exception = 'some random exception during processResponse';

  TestProcessResponseFailCommand(int functId, List<int>? functParam)
      : super(functId, functParam);

  @override
  List<int> processResponse(List<int> response) {
    throw exception;
  }
}

const request1 = <int>[
  1, // SOF
  3, // length excluding SOF and checksum
  0, // request
  1,
  253 // checksum
];
const request2 = <int>[
  1, // SOF
  3, // length excluding SOF and checksum
  0, // request
  2,
  254 // checksum
];
const request3 = <int>[
  1, // SOF
  3, // length excluding SOF and checksum
  0, // request
  3,
  255 // checksum
];

const response1Simple = <int>[
  1, // SOF
  4, // length excluding SOF and checksum
  1, // response
  1, // function id of requestion 1
  1,
  253 // checksum
];
const response2Simple = <int>[
  1, // SOF
  4, // length excluding SOF and checksum
  1, // response
  2, // function id of requestion 2
  0,
  253 // checksum
];
const response3Simple = <int>[
  1, // SOF
  4, // length excluding SOF and checksum
  1, // response
  3, // function id of requestion 3
  1,
  253 // checksum
];

const response1Complex = <int>[
  1, // SOF
  7, // length excluding SOF and checksum
  1, // response
  7,
  8,
  9,
  10,
  11,
  253 // checksum
];
const response2Complex = <int>[
  1, // SOF
  7, // length excluding SOF and checksum
  1, // response
  21,
  8,
  9,
  77,
  253 // checksum
];
const response3Complex = <int>[
  1, // SOF
  7, // length excluding SOF and checksum
  1, // response
  21,
  19,
  77,
  253 // checksum
];

const unsolicitedRequest = <int>[
  1, // SOF
  7, // length excluding SOF and checksum
  0, // request
  7,
  8,
  9,
  10,
  11,
  253 // checksum
];
