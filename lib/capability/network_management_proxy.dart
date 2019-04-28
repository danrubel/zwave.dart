import 'dart:async';

import 'package:zwave/capability/zw_node_mixin.dart';
import 'package:zwave/command/zw_request.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/report/zw_command_class_report.dart';
//import 'package:zwave/zw_exception.dart';

/// A controller node that manages other nodes.
abstract class NetworkManagementProxy implements ZwNodeMixin {
  /// Return a [Future] that completes with a current node list.
  Future<NodeListReport> requestNodeList() async {
    int sequenceNumber = nextSequenceNumber;
    var report = await commandHandler.request(new ZwRequest<NodeListReport>(
        logger,
        id,
        buildSendDataRequest(id, [
          COMMAND_CLASS_NETWORK_MANAGEMENT_PROXY,
          COMMAND_NODE_LIST_GET,
          sequenceNumber,
        ]),
        processResponse: (data) => new NodeListReport(data),
        resultKey: NodeListReport));

//    if (sequenceNumber != report.sequenceNumber)
//      throw ZwException('expected sequence number $sequenceNumber,'
//          ' but got ${report.sequenceNumber}');

    return report;
  }
}

class NodeListReport extends ZwCommandClassReport {
  NodeListReport(List<int> data) : super(data);

//  int get sequenceNumber => data[];
}
