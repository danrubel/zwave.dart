import 'dart:async';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/src/zw_decoder.dart';
import 'package:zwave/zw_message.dart';

class ZwRequest<T> extends ZwMessage {
  final Logger? logger;
  final int? nodeId;
  final List<int?>? data;
  final T Function(List<int> data)? processResponse;
  final Duration responseTimeout;
  final Object? resultKey;
  final Duration resultTimeout;
  final completer = Completer<T>();

  /// Used by [ZwManager] to cache the time at which the manager
  /// should stop waiting for a result/response from the device.
  DateTime? resultEndTime;

  /// Construct a request to be sent to a device.
  ///
  /// If a result is expected as a response
  /// then provide [processResponse] to process that result
  /// and optionally specify [responseTimeout] if other than 5 seconds.
  ///
  /// If a result is expected as an unsolicited request from the device
  /// following this request, then specify a [resultKey]
  /// and optionally specify [resultTimeout] if other than 5 seconds.
  /// After the node receives and processes the unsolicited request
  /// associated with this request, it should call the [ZwManager]'s
  /// processedResult([resultKey]) to signal that this request is complete.
  ZwRequest(this.logger, this.nodeId, this.data,
      {this.processResponse,
      this.responseTimeout = const Duration(seconds: 5),
      this.resultKey,
      this.resultTimeout = const Duration(seconds: 5)}) {
    _validate(logger != null, 'missing logger');
    _validate(data != null, 'data must not be null');
    _validate(processResponse == null || responseTimeout != null,
        'must specify responseTimeout with processResponse');
    _validate(resultKey == null || resultTimeout != null,
        'must specify resultTimeout with resultKey');
  }

  int? get functId => data![3];

  _validate(bool condition, String message) {
    if (condition) return;
    logger!.warning(message);
    throw message;
  }
}

/// Calculate and append checksum
void appendCrc(List<int?> data) {
  int crc = 0xFF;
  for (int index = 1; index < data.length; ++index) crc ^= data[index]!;
  data.add(crc);
}

Iterable<int> buildAsciiChars(String text) {
  int length = text.length;
  final result = <int>[length];
  for (int index = 0; index < length; ++index) {
    int codeUnit = text.codeUnitAt(index);
    if (codeUnit > 0x7F) codeUnit = '_'.codeUnitAt(0);
    result[index] = codeUnit;
  }
  return result;
}

/// Return message data for a zwave function request
List<int?> buildFunctRequest(int functId, [List<int?>? functParam]) =>
    buildFunctMessage(REQ_TYPE, functId, functParam);

/// Return message data for a zwave function response
List<int?> buildFunctResponse(int functId, [List<int>? functParam]) =>
    buildFunctMessage(RES_TYPE, functId, functParam);

/// Return data for a zwave function message
List<int?> buildFunctMessage(
    int frameType, int functId, List<int?>? functParam) {
  var data = <int?>[
    SOF, // start of frame
    3, // length
    frameType, // request
    functId,
  ];

  // Add function parameters if there are any
  if (functParam != null) {
    data.addAll(functParam);
    data[1] = data.length - 1; // update length field
  }

  appendCrc(data);

  return data;
}

/// Return message data for a zwave send data command request
List<int?> buildSendDataRequest(int nodeId, List<int?> cmdData,
        {int? transmitOptions}) =>
    buildSendDataMessage(REQ_TYPE, nodeId, cmdData,
        transmitOptions: transmitOptions);

/// Return message data for a zwave send data command response
List<int?> buildSendDataResponse(int nodeId, List<int?> cmdData,
        {int? transmitOptions}) =>
    buildSendDataMessage(RES_TYPE, nodeId, cmdData,
        transmitOptions: transmitOptions);

/// Return data for a zwave send data command message
List<int?> buildSendDataMessage(int frameType, int nodeId, List<int?> cmdData,
    {int? transmitOptions}) {
  final functParam = <int?>[
    nodeId,
    cmdData.length,
  ];
  functParam.addAll(cmdData);

  // transmit options
  //  #define TRANSMIT_OPTION_ACK		 		 0x01
  //  #define TRANSMIT_OPTION_LOW_POWER	 0x02
  //  #define TRANSMIT_OPTION_AUTO_ROUTE 0x04
  //  #define TRANSMIT_OPTION_NO_ROUTE 	 0x10
  //  #define TRANSMIT_OPTION_EXPLORE		 0x20
  functParam.add(transmitOptions ?? 0x25);

  return buildFunctMessage(frameType, FUNC_ID_ZW_SEND_DATA, functParam);
}

int get nextSequenceNumber {
  int seqNum = _sequenceNumber;
  ++_sequenceNumber;
  if (_sequenceNumber > 0xFF) _sequenceNumber = 0;
  return seqNum;
}

int get nextTestSequenceNumber => _sequenceNumber;
int _sequenceNumber = Random().nextInt(0x100);
