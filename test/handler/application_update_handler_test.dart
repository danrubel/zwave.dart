import 'package:test/test.dart';
import 'package:zwave/handler/application_update_handler.dart';
import 'package:zwave/node/zw_node.dart';

import '../zw_request_test.dart';

main() {
  ApplicationUpdateHandlerTest().init();
}

class ApplicationUpdateHandlerTest extends ZwRequestTest {
  ZwNode node;

  @override
  void defineTests() {
    setUp(() {
      node = ZwNode(13);
      manager.add(node);
    });

    group('node info', () {
      test('request', () async {
        expectingRequestResult(nodeInfoRequest, nodeInfoResult);
        UpdateStateNodeInfoReceived info = await node.requestNodeInfo();
        expect(info.sourceNode, 13);
        expect(info.commandClasses, [
          32, 129, 135, 114, 49, 64, 66, 68, //
          69, 67, 134, 112, 128, 133, 96
        ]);
        expectComplete();
      });
    });
  }
}

const nodeInfoRequest = [
  0x01, // SOF
  0x04, // length excluding SOF and checksum
  0x00, // request
  0x60, // FUNC_ID_ZW_REQUEST_NODE_INFO
  0x0D, // target node 13
  0x96, // checksum
];
const nodeInfoResult = [
  0x01, // SOF
  0x18, // length excluding SOF and checksum
  0x00, // request
  0x49, // FUNC_ID_ZW_APPLICATION_UPDATE
  0x84, // UPDATE_STATE_NODE_INFO_RECEIVED
  0x0D, // source node 13
  0x12, // command length
  0x04, // supported command #1 ...
  0x08, //
  0x06, //
  0x20, //
  0x81, //
  0x87, //
  0x72, //
  0x31, //
  0x40, //
  0x42, //
  0x44, //
  0x45, //
  0x43, //
  0x86, //
  0x70, //
  0x80, //
  0x85, //
  0x60, // ... last supported command
  0x89, // checksum
];
