import 'dart:async';

import 'package:logging/logging.dart';

// Z-Wave frame buffer protocol from
// https://www.silabs.com/documents/login/user-guides/INS12350-Serial-API-Host-Appl.-Prg.-Guide.pdf

const SOF = 0x01; // start of data frame
const ACK = 0x06; // acknowledgement
const NAK = 0x15; // request had errors
const CAN = 0x18; // request canceled / discarded

// message types
const REQ_TYPE = 0x00; // request
const RES_TYPE = 0x01; // response

/// [ZwDecoder] translates the byte stream from a a Z-Wave controller
/// into ACK, NAK, CAN, and data frames.
class ZwDecoder {
  final ZwDecodeListener? listener;
  final Duration messageTimeout;

  final _messageBuffer = <int>[];
  Timer? _messageTimer;

  ZwDecoder(this.listener, {int? messageTimeoutMsForTesting})
      : messageTimeout =
            Duration(milliseconds: messageTimeoutMsForTesting ?? 1500);

  void clear() {
    _messageBuffer.clear();
  }

  /// Process a native notification or response
  /// where [data] is an `int` or  `List<int>`
  void process(dynamic data) {
    if (_messageTimer != null) {
      _messageTimer!.cancel();
      _messageTimer = null;
    }

    if (data is int) {
      if (data < 0) {
        _logger.warning('<== $data process error');
        return;
      }
      if (_messageBuffer.isEmpty) {
        switch (data) {
          case ACK:
            _logFinest('<==', data, 'ACK');
            listener!.handleAck();
            return;
          case NAK:
            _logFinest('<==', data, 'NAK');
            listener!.handleNak();
            return;
          case CAN:
            _logFinest('<==', data, 'CAN');
            listener!.handleCan();
            return;
        }
      }
      _messageBuffer.add(data);
    } else {
      _messageBuffer.addAll(data as List<int>);
    }

    int index = 0;
    while (index < _messageBuffer.length) {
      // Handle all the 1 byte messages
      switch (_messageBuffer[index]) {
        case SOF:
          // Fall through to handle data frame
          break;
        case ACK:
          _logFinest('<==', ACK, 'ACK');
          listener!.handleAck();
          ++index;
          continue;
        case NAK:
          _logFinest('<==', NAK, 'ACK');
          listener!.handleNak();
          ++index;
          continue;
        case CAN:
          _logFinest('<==', CAN, 'ACK');
          listener!.handleCan();
          ++index;
          continue;
        default:
          _logger.warning('<== ${_messageBuffer[index]} unknown start');
          listener!.handleInvalidDataFrame();
          // The decoding is misaligned or message is corrupted.
          // Discard the rest of the message.
          _messageBuffer.clear();
          ++index;
          continue;
      }

      // Handle a data frame
      int frameStart = index;
      ++index;
      if (index < _messageBuffer.length) {
        final len = _messageBuffer[index];
        if (len < 3) {
          _logger.warning('<== $len invalid length');
          listener!.handleInvalidDataFrame();
          // The decoding is misaligned or message is corrupted.
          // Discard the rest of the message.
          _messageBuffer.clear();
          ++index;
          continue;
        }
        int crc = 0xFF ^ len;
        final crcIndex = index + len;
        if (crcIndex < _messageBuffer.length) {
          ++index;
          while (index < crcIndex) {
            crc ^= _messageBuffer[index];
            ++index;
          }
          final frame = _messageBuffer.sublist(frameStart, crcIndex + 1);
          if (crc == _messageBuffer[index]) {
            _logFiner('<==', frame, 'frame');
            listener!.handleDataFrame(frame);
          } else {
            _logger.warning('<== $frame invalid checksum');
            listener!.handleInvalidDataFrame();
          }
          ++index;
          continue;
        }
      }

      // Remove the processed bytes and wait for more
      _messageBuffer.removeRange(0, index - 1);
      _logFinest('<==', _messageBuffer, 'partial');

      // From section 6.2.2 of the Serial API Host Appl. Prg. Guide
      // Data frame receiver timeout is 1500 ms
      _messageTimer = Timer(messageTimeout, () {
        _logger.warning('<== $_messageBuffer partial timeout');
        listener!.handleInvalidDataFrame();
        _messageBuffer.clear();
        _messageTimer = null;
      });

      return;
    }
    _messageBuffer.clear();
  }
}

/// A [ZwDecodeListener] receives the decoded output from [ZwDecoder]
abstract class ZwDecodeListener {
  /// Process an ACK (acknowledgement) from the Z-Wave controller
  /// indicating that the message was received
  void handleAck();

  /// Process an CAN (cancel) from the Z-Wave controller
  /// indicating that the message was received but declined
  void handleCan();

  /// Process an NAK (negative acknowledgement) from the Z-Wave controller
  /// indicating that the message was corrupted
  void handleNak();

  /// Process a data frame from the Z-Wave controller
  void handleDataFrame(List<int> frame);

  /// Process an invalid or corrupt data frame from the Z-Wave controller
  void handleInvalidDataFrame();
}

final Logger _logger = Logger('ZwDecoder');

void _logFiner(String label, data, String tag) {
  if (_logger.level <= Level.FINER) _logger.finer('$label $data $tag');
}

void _logFinest(String label, data, String tag) {
  if (_logger.level <= Level.FINEST) _logger.finest('$label $data $tag');
}
