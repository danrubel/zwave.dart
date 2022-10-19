import 'dart:async';

import 'package:zwave/command/zw_command.dart';
import 'package:zwave/command/zw_request.dart';
import 'package:zwave/handler/command_handler.dart';

class QueuedCommandHandler implements CommandHandler {
  final _queue = <ZwCommand>[];
  final _queuedRequests = <ZwRequest>[];

  /// Queue the command and return immediately
  @override
  Future<void> send(ZwCommand command) async {
    _queue.add(command);
  }

  @override
  Future<T> request<T>(ZwRequest<T> request) async {
    _queuedRequests.add(request);
    return request.completer.future;
  }

  Future<void> sendQueuedCommands(CommandHandler? commandHandler) async {
    while (_queue.isNotEmpty) {
      await commandHandler!.send(_queue.removeAt(0));
    }
    while (_queuedRequests.isNotEmpty) {
      await commandHandler!.request(_queuedRequests.removeAt(0));
    }
  }
}
