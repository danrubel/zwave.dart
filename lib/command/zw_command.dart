import 'dart:async';

import 'package:logging/logging.dart';
import 'package:zwave/handler/command_handler.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/src/zw_decoder.dart';
import 'package:zwave/zw_message.dart';

abstract class ZwCommand<T> extends ZwMessage {
  Logger? logger;

  Completer<List<int>>? _responseCompleter;

  ZwCommand() {
    logger = Logger('$runtimeType');
  }

  /// Return the complete message to be sent out on the Z-Wave network
  List<int>? get data {
    final data = <int>[
      SOF, // start of frame
      3, // length
      REQ_TYPE, // request
      functId,
    ];

    // Add function parameters if there are any
    List<int>? param = functParam;
    if (param != null) {
      data.addAll(param);
      data[1] = data.length - 1; // update length field
    }

    // Calculate and append checksum
    int crc = 0xFF;
    for (int index = 1; index < data.length; ++index) crc ^= data[index];
    data.add(crc);

    return data;
  }

  int get functId;

  List<int>? get functParam;

  Completer<List<int>>? get responseCompleter => _responseCompleter;

  Duration get responseTimeout => const Duration(seconds: 5);

  T processResponse(List<int> response);

  /// Send the command and return a future that completes with the result
  Future<T> send(CommandHandler handler) async {
    if (_responseCompleter != null) throw 'already called send';
    _responseCompleter = Completer<List<int>>();
    Future<T> result = _responseCompleter!.future.then(processResponse);
    await handler.send(this);
    return result;
  }

  /// Return `true` if the given response indicates that the device will send
  /// the requested information in a separate unsolicited request/notification.
  bool willCallback(List<int> data) {
    /*
    Check for a response such as

     0x01, // SOF
     0x04, // length excluding SOF and checksum
     0x01, // response
     0x13, // FUNC_ID_ZW_SEND_DATA

     0x00 or 0x01 // source node ???

     0xE8, // checksum

    indicating that the device will be sent an unsolicited request/notification
    with additional information for the command just processed.
   */
    return data.length == 6 &&
        data[3] == FUNC_ID_ZW_SEND_DATA &&
        (data[4] == 0x00 || data[4] == 0x01);
  }
}
