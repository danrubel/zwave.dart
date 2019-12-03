import 'dart:async';

import 'package:logging/logging.dart';
import 'package:zwave/capability/zw_node_mixin.dart';
import 'package:zwave/command/zw_request.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/zw_message.dart';

abstract class ApplicationUpdateHandler<T> implements ZwNodeMixin {
  /*
  application update message:
  data[0] - 0x01 SOF
  data[1] - message length excluding SOF and checksum
  data[2] - 0x00 request or 0x01 response
  data[3] - function id 0x49 application update
  data[4] - sub command (e.g. UPDATE_STATE_NODE_INFO_RECEIVED)
  data[5] - source node
  data[6] - command length
  data[*] - command data
  data[n] - checksum
  */

  Logger get logger;

  bool firstUpdateStateNodeInfoReceived = true;

  Future<UpdateStateNodeInfoReceived> requestNodeInfo() =>
      commandHandler.request(ZwRequest(
          logger, id, buildFunctRequest(FUNC_ID_ZW_REQUEST_NODE_INFO, [id]),
          resultKey: UpdateStateNodeInfoReceived));

  T dispatchApplicationUpdate(List<int> data) {
    switch (data[4]) {
      case UPDATE_STATE_NODE_INFO_RECEIVED:
        return handleUpdateStateNodeInfoReceived(data);
      default:
        return handleUnknownApplicationUpdate(data[4], data);
    }
  }

  void handleStateChange() {
    logger.warning('Unhandled state change');
  }

  T handleUpdateStateNodeInfoReceived(List<int> data) {
    final info = UpdateStateNodeInfoReceived(data);
    if (!processedResult<UpdateStateNodeInfoReceived>(info)) {
      if (firstUpdateStateNodeInfoReceived) {
        firstUpdateStateNodeInfoReceived = false;
        logger.info('Supported command classes: '
            '${info.sourceNode} ${info.commandClasses}');
      }
      // Assume that an unsolicited update indicates a state change
      handleStateChange();
    }
    return null;
  }

  T handleUnknownApplicationUpdate(int cmdId, List<int> data) {
    final nodeId = data[5];
    logger.warning('Unknown application update id: $nodeId $cmdId $data');
    return null;
  }
}

class UpdateStateNodeInfoReceived extends ZwMessage {
  /*
  application update message:
  data[0] - 0x01 SOF
  data[1] - message length excluding SOF and checksum
  data[2] - 0x00 request or 0x01 response
  data[3] - 0x49 FUNC_ID_ZW_APPLICATION_UPDATE
  data[4] - 0x84 UPDATE_STATE_NODE_INFO_RECEIVED
  data[5] - source node
  data[6] - command length

  data[10] - supported command class # 1
  data[11] - supported command class # 2
  ...
  --------- optional section
  data[k] - 0xEF mark
  data[k+1] - controlled command class #1
  data[k+2] - controlled command class #2
  ...
  --------- end optional section
  data[n] - checksum
  */

  final List<int> data;

  UpdateStateNodeInfoReceived(this.data);

  List<int> get commandClasses => data.sublist(10, data.length - 1);

  int get sourceNode => data[5];
}
