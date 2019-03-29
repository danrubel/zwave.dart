import 'package:test/test.dart';
import 'package:zwave/capability/switch_binary.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/node/zw_node.dart';

import '../zw_request_test.dart';

void main() {
  new BinarySwitchTest().init();
}

class BinarySwitchTest extends ZwRequestTest {
  TestBinarySwitchNode node;

  @override
  void defineTests() {
    setUp(() {
      node = new TestBinarySwitchNode(9);
      manager.add(node);
    });

    test('init', () {
      expect(node.state, isNull);
    });

    test('get', () async {
      expectingRequestResponse(binarySwitchGetRequest, response);
      await node.requestState();
      expect(node.state, true);
      expect(node.stateValue, 0x3A);
      expectComplete();
    });

    test('on', () async {
      expectingRequestSimpleResponse(binarySwitchSetTrueRequest);
      await node.setState(true);
      expect(node.state, true);
      expect(node.stateValue, 0xFF);
      expectComplete();
    });

    test('percent', () async {
      expectingRequestSimpleResponse(binarySwitchSet47PercentRequest);
      await node.setStateValue(47);
      expect(node.state, true);
      expect(node.stateValue, 47);
      expectComplete();
    });

    test('off', () async {
      expectingRequestSimpleResponse(binarySwitchSetFalseRequest);
      await node.setState(false);
      expect(node.state, false);
      expect(node.stateValue, 0);
      expectComplete();
    });

    test('state change', () async {
      node.dispatchApplicationCommand(response);
      expect(node.state, true);
      expect(node.stateValue, 0x3A);
    });
  }
}

class TestBinarySwitchNode extends ZwNode with SwitchBinary {
  TestBinarySwitchNode(int id) : super(id);
}

const binarySwitchGetRequest = [
  0x01, // SOF
  0x08, // length excluding SOF and checksum
  0x00, // request
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x09, // source node 9
  0x02, // command length
  COMMAND_CLASS_SWITCH_BINARY,
  SWITCH_BINARY_GET,
  0x25, // transmit options
  0xED, // checksum
];
const binarySwitchSetTrueRequest = [
  0x01, // SOF
  0x09, // length excluding SOF and checksum
  0x00, // request
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x09, // source node 9
  0x03, // command length
  COMMAND_CLASS_SWITCH_BINARY,
  SWITCH_BINARY_SET,
  0xFF, // on
  0x25, // transmit options
  0x11, // checksum
];
const binarySwitchSet47PercentRequest = [
  0x01, // SOF
  0x09, // length excluding SOF and checksum
  0x00, // request
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x09, // source node 9
  0x03, // command length
  COMMAND_CLASS_SWITCH_BINARY,
  SWITCH_BINARY_SET,
  47, // 47 %
  0x25, // transmit options
  193, // checksum
];
const binarySwitchSetFalseRequest = [
  0x01, // SOF
  0x09, // length excluding SOF and checksum
  0x00, // request
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x09, // source node 9
  0x03, // command length
  COMMAND_CLASS_SWITCH_BINARY,
  SWITCH_BINARY_SET,
  0x00, // off
  0x25, // transmit options
  238, // checksum
];
const response = const <int>[
  0x01, // SOF
  0x09, // length excluding SOF and checksum
  0x01, // response
  0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
  0x00, // rxStatus
  0x09, // source node 9
  0x03, // command length
  COMMAND_CLASS_SWITCH_BINARY,
  SWITCH_BINARY_REPORT,
  0x3A, // 58 %
  0x7C, // checksum
];
