import 'dart:math';

import 'package:logging/logging.dart';
import 'package:zwave/capability/zw_node_mixin.dart';
import 'package:zwave/command/zw_request.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/report/security_message_encapsulation.dart';
import 'package:zwave/report/security_nonce_report.dart';
import 'package:zwave/report/zw_command_class_report.dart';

/// A node that supports the encrypted communication.
mixin Security implements ZwNodeMixin {
  final _nonces = <Nonce>[];

  Nonce generateNonce() {
    while (true) {
      Nonce nonce = Nonce.generate();
      int key = nonce.key;
      // Newly generated nonce must have a unique key
      if (_nonces.firstWhere((n) => n.key == key, orElse: () => null) != null) {
        continue;
      }
      if (_nonces.length >= 8) _nonces.removeLast();
      _nonces.add(nonce);
      return nonce;
    }
  }

  void handleSecurityNonceGet(ZwCommandClassReport report) {
    sendNonceReport(report.sourceNode);
    // TODO add timeout for device sending message with this nonce
  }

  void handleSecurityNonceReport(SecurityNonceReport report) {
    // TODO cache nonce for sending queued request
  }

  void handleSecurityMessageEncapsulation(
      SecurityMessageEncapsulation message) {
    // TODO decrypt message
    logger.warning('encrypted ${message.encryptedData}');
  }

  void handleSecurityMessageEncapsulationNonceGet(
      SecurityMessageEncapsulation message) {
    sendNonceReport(message.sourceNode);
    // TODO decrypt message
    logger.warning('encrypted ${message.encryptedData}');
  }

  void sendNonceReport(int desinationNodeId) {
    var data = buildSendDataResponse(desinationNodeId, <int>[
      COMMAND_CLASS_SECURITY,
      SECURITY_NONCE_REPORT,
      ...generateNonce().values,
    ]);
    commandHandler.request(ZwRequest<void>(logger, desinationNodeId, data));
  }
}

/// A number used once (nonce).
class Nonce {
  final List<int> values;

  int get key => values[0];

  Nonce(this.values) : assert(values.length == 8);

  factory Nonce.generate() {
    final values = List<int>(8);
    // First byte must be non-zero
    values[0] = _random.nextInt(0xFF) + 1;
    for (int index = 1; index < 8; ++index) {
      values[index] = _random.nextInt(0x100);
    }
    return Nonce(values);
  }
}

Random _r;
Random get _random {
  try {
    return _r ??= Random.secure();
  } on UnsupportedError catch (e) {
    Logger('Security').warning('secure random not supported', e);
    return _r ??= Random();
  }
}
