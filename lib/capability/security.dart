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
      var nonce = Nonce.generate();
      var key = nonce.key;
      // Newly generated nonce must have a unique key
      if (_nonces.any((n) => n.key == key)) continue;
      if (_nonces.length >= 8) _nonces.removeLast();
      _nonces.add(nonce);
      return nonce;
    }
  }

  @override
  void handleSecurityNonceGet(ZwCommandClassReport report) {
    logger.fine('nonce get');
    sendNonceReport(report.sourceNode);
    // TODO add timeout for device sending message with this nonce
  }

  @override
  void handleSecurityNonceReport(SecurityNonceReport report) {
    logger.fine('nonce received: ${report.nonce.values}');
    // TODO cache nonce for sending queued request
  }

  @override
  void handleSecurityMessageEncapsulation(
      SecurityMessageEncapsulation message) {
    _logSecurityMessageEncapsulation('security msg', message);
    // TODO decrypt message
  }

  @override
  void handleSecurityMessageEncapsulationNonceGet(
      SecurityMessageEncapsulation message) {
    _logSecurityMessageEncapsulation('security msg nonce get', message);
    // TODO decrypt message
    sendNonceReport(message.sourceNode);
  }

  void _logSecurityMessageEncapsulation(
      String msgType, SecurityMessageEncapsulation message) {
    logger.fine('$msgType, init vector : ${message.initVector}');
    logger.fine('$msgType, encrypted   : ${message.encryptedData}');
    logger.fine('$msgType, nonce key   : ${message.nonceKey}');
    logger.fine('$msgType, auth code   : ${message.authCode}');
  }

  void sendNonceReport(int destinationNodeId) {
    var nonce = generateNonce();
    var data = buildSendDataResponse(destinationNodeId, <int>[
      COMMAND_CLASS_SECURITY,
      SECURITY_NONCE_REPORT,
      ...nonce.values,
    ]);
    commandHandler!.request(ZwRequest<void>(logger, destinationNodeId, data));
    logger.fine('nonce sent: ${nonce.values}');
  }
}

/// A number used once (nonce).
class Nonce {
  final List<int> values;

  int get key => values[0];

  Nonce(this.values) : assert(values.length == 8);

  factory Nonce.generate() {
    final values = [0, 0, 0, 0, 0, 0, 0, 0];
    // First byte must be non-zero
    values[0] = _random.nextInt(0xFF) + 1;
    for (var index = 1; index < 8; ++index) {
      values[index] = _random.nextInt(0x100);
    }
    return Nonce(values);
  }
}

Random? _r;
Random get _random {
  try {
    return _r ??= Random.secure();
  } on UnsupportedError catch (e) {
    Logger('Security').warning('secure random not supported', e);
    return _r ??= Random();
  }
}
