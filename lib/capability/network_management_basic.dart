import 'dart:async';

import 'package:zwave/capability/zw_node_mixin.dart';
import 'package:zwave/command/zw_request.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/report/zw_command_class_report.dart';
//import 'package:zwave/zw_exception.dart';

/// A controller node that manages other nodes.
abstract class NetworkManagementBasic implements ZwNodeMixin {
  /// Return a [Future] that completes with information about a node.
  Future<NodeInformationFrame> requestNodeInformationFrame(int nodeId) async {
    int sequenceNumber = nextSequenceNumber;
    var report = await commandHandler.request(ZwRequest<NodeInformationFrame>(
        logger,
        id,
        buildSendDataRequest(id, [
          COMMAND_CLASS_NETWORK_MANAGEMENT_BASIC,
          COMMAND_NODE_INFORMATION_SEND,
          sequenceNumber,
          0, // reserved
          1, // destination node = controller?
        ]),
        processResponse: (data) => NodeInformationFrame(data),
        resultKey: NodeInformationFrame));

//    if (sequenceNumber != report.sequenceNumber)
//      throw ZwException('expected sequence number $sequenceNumber,'
//          ' but got ${report.sequenceNumber}');

    return report;
  }

  @override
  void handleCommandClassNetworkManagementProxy(List<int> data) {
    switch (data[8]) {
      default:
        return unhandledCommandClass(COMMAND_CLASS_NETWORK_MANAGEMENT_PROXY,
            'COMMAND_CLASS_NETWORK_MANAGEMENT_PROXY', data);
    }
  }
}

class NodeInformationFrame extends ZwCommandClassReport {
  NodeInformationFrame(List<int> data) : super(data);

//  int get sequenceNumber => data[];
}
