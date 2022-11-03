import 'package:test/test.dart';
import 'package:zwave/capability/security.dart';
import 'package:zwave/node/zw_node.dart';

import '../zw_request_test.dart';

main() {
  SecurityTest().init();
}

class SecurityTest extends ZwRequestTest {
  TestSecurityNode? node;

  @override
  void defineTests() {
    setUp(() {
      node = TestSecurityNode(7);
      manager.add(node!);
    });

    test('init', () {
      expect(node, isNotNull);
    });

    group('nonce', () {
      test('generate', () {
        var keys = <int>[0, 0, 0, 0, 0, 0, 0, 0];
        for (var index = 0; index < 1000; ++index) {
          var nonce = node!.generateNonce();
          expect(nonce, isNotNull);
          expect(nonce.values, hasLength(8));
          expect(nonce.values[0], nonce.key);
          expect(nonce.values[0], isNot(0));
          for (var index2 = 0; index2 < 8; ++index2) {
            var value = nonce.values[index2];
            expect(value, greaterThanOrEqualTo(0x00));
            expect(value, lessThanOrEqualTo(0xFF));
          }
          expect(keys, isNot(contains(nonce.key)));
          keys.removeLast();
          keys.add(nonce.key);
        }
      });

//      test('report', () async {
//        var expectedMessage = <int>[
//          ...nonceReportResponseHeader,
//          ...node.nextTestNonce.values,
//          0x25 // transmit options
//        ];
//        appendCrc(expectedMessage);
//        port.expectedMessages.add(expectedMessage);
//        manager.dispatch(nonceGetRequestFromNode);
//        expectComplete();
//      });
    });
  }
}

class TestSecurityNode extends ZwNode with Security {
  TestSecurityNode(int id) : super(id);

  get commandHander => super.commandHandler;

  Nonce? _nextTestNonce;
  Nonce get nextTestNonce => _nextTestNonce ??= super.generateNonce();

  Nonce generateNonce() {
    if (_nextTestNonce != null) {
      var nonce = _nextTestNonce!;
      _nextTestNonce = null;
      return nonce;
    }
    return super.generateNonce();
  }
}

const nonceGetRequestFromNode = [
  0x01, // SOF
  0x08, // length 8 excluding SOF and checksum
  0x00, // request
  0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
  0x00, // rxStatus
  0x07, // source node 7
  0x02, // command length 2
  0x98, // COMMAND_CLASS_SECURITY
  0x40, // SECURITY_NONCE_GET
  0x2E, // checksum
];

const nonceReportResponseHeader = [
  0x01, // SOF
  0x10, // length 16 excluding SOF and checksum
  0x01, // response
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x07, // source node 7
  0x0A, // command length 10
  0x98, // COMMAND_CLASS_SECURITY
  0x80, // SECURITY_NONCE_REPORT
  // nonce and transmit options and checksum excluded
];
