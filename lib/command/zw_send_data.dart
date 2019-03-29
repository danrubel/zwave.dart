import 'package:zwave/command/zw_command.dart';
import 'package:zwave/message_consts.dart';

abstract class ZwSendData<T> extends ZwCommand<T> {
  final int nodeId;

  ZwSendData(this.nodeId);

  List<int> get cmdData;

  @override
  int get functId => FUNC_ID_ZW_SEND_DATA;

  @override
  List<int> get functParam {
    final cmdData2 = cmdData;
    final functParam = <int>[
      nodeId,
      cmdData2.length,
    ];
    functParam.addAll(cmdData2);

    // transmit options
    //  #define TRANSMIT_OPTION_ACK		 		 0x01
    //  #define TRANSMIT_OPTION_LOW_POWER	 0x02
    //  #define TRANSMIT_OPTION_AUTO_ROUTE 0x04
    //  #define TRANSMIT_OPTION_NO_ROUTE 	 0x10
    //  #define TRANSMIT_OPTION_EXPLORE		 0x20
    functParam.add(0x25);

    return functParam;
  }
}
