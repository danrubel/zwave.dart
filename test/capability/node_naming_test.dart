import 'package:test/test.dart';
import 'package:zwave/capability/node_naming.dart';
import 'package:zwave/node/zw_node.dart';

import '../zw_request_test.dart';

void main() {
  NodeNamingTest().init();
}

class NodeNamingTest extends ZwRequestTest {
  late TestNodeNamingNode node;

  @override
  void defineTests() {
    setUp(() {
      node = TestNodeNamingNode(5);
      manager.add(node);
    });

    group('name', () {
      test('report', () {
        final report = NodeNameReport(nodeNameReportData);
        expect(report.sourceNode, 6);
        expect(report.name, 'Porch Light');
      });
      test('get', () async {
        expect(node.name, isNull);
        expect(node.location, isNull);
        expectingRequestResult(getNameRequest, getNameResult);
        String? result;
        result = await node.requestNodeName();
        expect(result, 'lamp');
        expect(node.name, 'lamp');
        expect(node.location, isNull);
        expectComplete();
      });
      test('set', () async {
        expect(node.name, isNull);
        expect(node.location, isNull);
        expectingRequestSimpleResponse(setNameRequest);
        await node.setNodeName('lamp');
        expect(node.name, 'lamp');
        expect(node.location, isNull);
        expectComplete();
      });
    });

    group('location', () {
      test('report', () {
        final report = NodeLocationReport(nodeLocationReportData);
        expect(report.sourceNode, 6);
        expect(report.location, '');
      });
      test('get', () async {
        expect(node.name, isNull);
        expect(node.location, isNull);
        expectingRequestResult(getLocationRequest, getLocationResult);
        String? result = await node.requestNodeLocation();
        expect(result, 'living room');
        expect(node.name, isNull);
        expect(node.location, 'living room');
        expectComplete();
      });
      test('set', () async {
        expect(node.name, isNull);
        expect(node.location, isNull);
        expectingRequestSimpleResponse(setLocationRequest);
        await node.setNodeLocation('living room');
        expect(node.name, isNull);
        expect(node.location, 'living room');
        expectComplete();
      });
    });
  }
}

class TestNodeNamingNode extends ZwNode with NodeNaming {
  TestNodeNamingNode(int id) : super(id);
}

const setNameRequest = [
  0x01, // SOF
  0x0D, // length excluding SOF and checksum
  0x00, // request
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x05, // source node 5
  0x07, // command length
  0x77, // COMMAND_CLASS_NODE_NAMING
  0x01, // NODE_NAMING_NODE_NAME_SET
  0x00, // ascii text follows
  0x6C, //
  0x61, //
  0x6D, //
  0x70, //
  0x25, // transmit options
  0xA0, // checksum
];
const getNameRequest = [
  0x01, // SOF
  0x08, // length excluding SOF and checksum
  0x00, // request
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x05, // source node 5
  0x02, // command length
  0x77, // COMMAND_CLASS_NODE_NAMING
  0x02, // NODE_NAMING_NODE_NAME_GET
  0x25, // transmit options
  0xB3, // checksum
];
const getNameResult = [
  0x01, // SOF
  0x0D, // length excluding SOF and checksum
  0x00, // request
  0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
  0x00, // rxStatus
  0x05, // source node 5
  0x07, // command length
  0x77, // COMMAND_CLASS_NODE_NAMING
  0x03, // NODE_NAMING_NODE_NAME_REPORT
  0x00, // ascii text follows
  0x6C, //
  0x61, //
  0x6D, //
  0x70, //
  0x90, // checksum
];
const nodeNameReportData = <int>[
  0x01, // SOF
  0x14, // length excluding SOF and checksum
  0x00, // request
  0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
  0x00, // rxStatus
  0x06, // source node 6
  0x0E, // command length
  0x77, // COMMAND_CLASS_NODE_NAMING
  0x03, // NODE_NAMING_NODE_NAME_REPORT
  0x00, // type - ASCII
  0x50, // first character in name ...
  0x6F,
  0x72,
  0x63,
  0x68,
  0x20,
  0x4C,
  0x69,
  0x67,
  0x68,
  0x74, // ... last character
  0xAB, // checksum
];

const setLocationRequest = [
  0x01, // SOF
  0x14, // length excluding SOF and checksum
  0x00, // request
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x05, // source node 5
  0x0E, // command length
  0x77, // COMMAND_CLASS_NODE_NAMING
  0x04, // NODE_NAMING_NODE_LOCATION_SET
  0x00, // ascii text follows
  0x6C, //
  0x69, //
  0x76, //
  0x69, //
  0x6E, //
  0x67, //
  0x20, //
  0x72, //
  0x6F, //
  0x6F, //
  0x6D, //
  0x25, // transmit options
  0x89, // checksum
];
const getLocationRequest = [
  0x01, // SOF
  0x08, // length excluding SOF and checksum
  0x00, // request
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x05, // source node 5
  0x02, // command length
  0x77, // COMMAND_CLASS_NODE_NAMING
  0x05, // NODE_NAMING_NODE_LOCATION_GET
  0x25, // transmit options
  0xB4, // checksum
];
const getLocationResult = [
  0x01, // SOF
  0x14, // length excluding SOF and checksum
  0x00, // request
  0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
  0x00, // rxStatus
  0x05, // source node 5
  0x0E, // command length
  0x77, // COMMAND_CLASS_NODE_NAMING
  0x06, // NODE_NAMING_NODE_LOCATION_REPORT
  0x00, // ascii text follows
  0x6C, //
  0x69, //
  0x76, //
  0x69, //
  0x6E, //
  0x67, //
  0x20, //
  0x72, //
  0x6F, //
  0x6F, //
  0x6D, //
  0xB9, // checksum
];
const nodeLocationReportData = <int>[
  0x01, // SOF
  0x09, // length excluding SOF and checksum
  0x00, // request
  0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
  0x00, // rxStatus
  0x06, // source node 6
  0x03, // command length
  0x77, // COMMAND_CLASS_NODE_NAMING
  0x06, // NODE_NAMING_NODE_LOCATION_REPORT
  0x00, // type - ASCII
  /// no characters ... zero length string
  0x86, // Checksum
];
