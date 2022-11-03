import 'dart:async';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/src/zw_decoder.dart';
import 'package:zwave/zw_message.dart';

class ZwRequest<T> extends ZwMessage {
  final Logger logger;
  final int nodeId;
  final List<int> data;
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

  int get functId => data[3];

  _validate(bool condition, String message) {
    if (condition) return;
    logger.warning(message);
    throw message;
  }
}

/// Calculate and append checksum
void appendCrc(List<int> data) {
  int crc = 0xFF;
  for (int index = 1; index < data.length; ++index) crc ^= data[index];
  data.add(crc);
}

Iterable<int> buildAsciiChars(String text) =>
    List.generate(text.length, (index) {
      var codeUnit = text.codeUnitAt(index);
      return codeUnit > 0x7F ? '_'.codeUnitAt(0) : codeUnit;
    });

/// Return message data for a zwave function request
List<int> buildFunctRequest(int functId, [List<int>? functParam]) =>
    buildFunctMessage(REQ_TYPE, functId, functParam);

/// Return message data for a zwave function response
List<int> buildFunctResponse(int functId, [List<int>? functParam]) =>
    buildFunctMessage(RES_TYPE, functId, functParam);

/// Return data for a zwave function message
List<int> buildFunctMessage(int frameType, int functId, List<int>? functParam) {
  var data = <int>[
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

/// Return message data for a zwave send data command request where
/// [nodeID] the destination node or 0xFF for broadcast.
List<int> buildSendDataRequest(int nodeId, List<int> cmdData,
        {TransmitOptions transmitOptions = TransmitOptions.normal}) =>
    buildSendDataMessage(REQ_TYPE, nodeId, cmdData,
        transmitOptions: transmitOptions);

/// Return message data for a zwave send data command response where
/// [nodeID] the destination node or 0xFF for broadcast.
List<int> buildSendDataResponse(int nodeId, List<int> cmdData,
        {TransmitOptions transmitOptions = TransmitOptions.normal}) =>
    buildSendDataMessage(RES_TYPE, nodeId, cmdData,
        transmitOptions: transmitOptions);

/// Return message data for a zwave send data command message where
/// [nodeID] the destination node or 0xFF for broadcast.
List<int> buildSendDataMessage(int frameType, int nodeId, List<int> cmdData,
    {TransmitOptions transmitOptions = TransmitOptions.normal}) {
  final functParam = <int>[
    nodeId,
    cmdData.length,
  ];
  functParam.addAll(cmdData);
  functParam.add((transmitOptions).flags);

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

class TransmitOptions {
  final int flags;

  /// Z-Wave packet transmission options:
  /// [ack] - Request acknowledgment from destination node. Allow routing.
  /// [noRoute] - Send only in direct range. Explicitly disallow all routing.
  /// [lowPower] - Transmit at low output power level (1/3 of normal RF range)
  /// [autoRoute] - If last working route fails or does not exist, then routes from the routing table will be used.
  /// [explore] - If existing routes fail, then resolve new routes via explorer discovery.
  const TransmitOptions({
    bool ack: false,
    bool lowPower: false,
    bool autoRoute: false,
    bool noRoute: false,
    bool explore: false,
  }) : this.raw((ack ? 0x01 : 0x00) |
            (lowPower ? 0x02 : 0x00) |
            (autoRoute ? 0x04 : 0x00) |
            (noRoute ? 0x10 : 0x00) |
            (explore ? 0x20 : 0x00));

  const TransmitOptions.raw(this.flags);

  /// Default/normal transmission options. Should not be set to `null`.
  static const normal =
      // TODO consider TransmitOptions ack: true only
      TransmitOptions(ack: true, autoRoute: true, explore: true);
}
