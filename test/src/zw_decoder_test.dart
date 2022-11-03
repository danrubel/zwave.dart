import 'dart:async';

import 'package:zwave/src/zw_decoder.dart';
import 'package:test/test.dart';

main() {
  const validFrame = <int>[
    // get version response
    1, 16, 1, 21, 90, 45, 87, 97, 118, 101, 32, 51, 46, 57, 53, 0, 1, 153
  ];

  late ZwDecoder decoder;
  late TestListener listener;

  setUp(() {
    listener = TestListener();
    decoder = ZwDecoder(listener, messageTimeoutMsForTesting: 10);
  });

  group('one byte message', () {
    test('ACK', () {
      decoder.process(ACK);
      listener.expectReceived(['ACK']);
    });

    test('ACK2', () {
      decoder.process(<int>[ACK]);
      listener.expectReceived(['ACK']);
    });

    test('NAK', () {
      decoder.process(NAK);
      listener.expectReceived(['NAK']);
    });

    test('NAK2', () {
      decoder.process(<int>[NAK]);
      listener.expectReceived(['NAK']);
    });

    test('CAN', () {
      decoder.process(CAN);
      listener.expectReceived(['CAN']);
    });

    test('CAN2', () {
      decoder.process(<int>[CAN]);
      listener.expectReceived(['CAN']);
    });
  });

  group('data frame', () {
    test('1', () {
      decoder.process(validFrame);
      listener.expectReceived([validFrame]);
    });
    test('1 ACK', () {
      decoder.process(<int>[]
        ..addAll(validFrame)
        ..add(ACK));
      listener.expectReceived([validFrame, 'ACK']);
    });
    test('ACK 1', () {
      decoder.process(<int>[]
        ..add(ACK)
        ..addAll(validFrame));
      listener.expectReceived(['ACK', validFrame]);
    });
    test('ACK 1 CAN', () {
      decoder.process(<int>[]
        ..add(ACK)
        ..addAll(validFrame)
        ..add(CAN));
      listener.expectReceived(['ACK', validFrame, 'CAN']);
    });
    test('ACK 2', () {
      decoder.process(<int>[]
        ..add(ACK)
        ..addAll(validFrame)
        ..addAll(validFrame));
      listener.expectReceived(['ACK', validFrame, validFrame]);
    });
  });

  group('invalid', () {
    test('start', () {
      decoder.process(<int>[7]);
      listener.expectReceived(['invalid']);
    });

    test('length', () {
      decoder.process(<int>[1, 2]);
      listener.expectReceived(['invalid']);
    });

    test('checksum', () {
      final invalidChecksum = List<int>.from(validFrame);
      ++invalidChecksum[validFrame.length - 1];
      decoder.process(invalidChecksum);
      listener.expectReceived(['invalid']);
    });

    test('timeout', () async {
      final partialFrame = validFrame.sublist(0, validFrame.length - 1);
      decoder.process(partialFrame);
      listener.expectReceived([]);
      await listener.hasReceived();
      listener.expectReceived(['invalid']);
    });
  });
}

class TestListener implements ZwDecodeListener {
  final List received = [];
  Completer? _completer;

  void append(dynamic data) {
    received.add(data);
    _completer?.complete();
    _completer = null;
  }

  void expectReceived(List expected) {
    expect(received, equals(expected));
  }

  @override
  void handleAck() {
    append('ACK');
  }

  @override
  void handleCan() {
    append('CAN');
  }

  @override
  void handleDataFrame(List<int> frame) {
    append(frame);
  }

  @override
  void handleInvalidDataFrame() {
    append('invalid');
  }

  @override
  void handleNak() {
    append('NAK');
  }

  Future hasReceived() {
    if (_completer != null) fail('already waiting');
    _completer = Completer();
    return _completer!.future;
  }
}
