import 'package:logging/logging.dart';
import 'package:zwave/message_consts.dart';

abstract class SendDataDispatcher<T> {
  /*
  send data message:
  data[0] - 0x01 SOF
  data[1] - message length excluding SOF and checksum
  data[2] - 0x00 request or 0x01 response
  data[3] - function id 0x13 FUNC_ID_ZW_SEND_DATA
  data[4] - source node
  data[5] - command length
  data[6] - command class (e.g. COMMAND_CLASS_NO_OPERATION)
  data[*] - command data
  data[n-1] - transmit options (0x02 low power)
  data[n] - checksum
  */

  Logger get logger;

  T dispatchSendData(List<int> data) {
    switch (data[6]) {
      case COMMAND_CLASS_NO_OPERATION:
        return handleNoOp(data);
      default:
        return handleUnknownSendDataId(data[6], data);
    }
  }

  T handleNoOp(List<int> data) {
    logger.finer('ping controller');
    return null;
  }

  T handleUnknownSendDataId(int cmdId, List<int> data) {
    final nodeId = data[4];
    logger.warning('Unhandled send data id: $nodeId $cmdId $data');
    return null;
  }
}
