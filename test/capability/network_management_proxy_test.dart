import 'package:test/test.dart';
import 'package:zwave/capability/network_management_proxy.dart';

import '../zw_request_test.dart';

main() {
  NetworkManagementProxyTest().init();
}

class NetworkManagementProxyTest extends ZwRequestTest {
  NetworkManagementProxy controller;

  @override
  void defineTests() {
    setUp(() {
      startLogger();
      controller = manager.controller;
    });

    test('request', () async {
//      var nodeListRequest =
      injectTestSeqNum(nodeListRequestRaw, 8);

      // TODO fails because source node is zero... is that correct or not?
      print('   >>> test commented out - work in progress');
//      expectingRequestResult(nodeListRequest, nodeListReportRaw);
//
//      final result = await controller.requestNodeList();
//
//      expect(result, isNotNull);
    });
  }
}

const nodeListRequestRaw = [
  0x01, // SOF
  0x09, // length excluding SOF and checksum
  0x00, // request
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x00, // source node 0
  0x03, // command length
  0x52, // COMMAND_CLASS_NETWORK_MANAGEMENT_PROXY
  0x01, // COMMAND_NODE_LIST_GET
  0x93, // sequence number
  0x25, // transmit options
  0x03, // checksum
];

const nodeListReportRaw = [
  0x01, // SOF
  0x0E, // length excluding SOF and checksum
  0x00, // request
  0x04,
  0x00,
  0x04,
  0x08,
  0x31,
  0x05,
  0x04,
  0x64,
  0x00,
  0x00,
  0x67,
  0x6D,
  0xA7,
];
