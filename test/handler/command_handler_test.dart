import 'dart:async';

import 'package:zwave/command/zw_command.dart';
import 'package:zwave/command/zw_request.dart';
import 'package:zwave/handler/command_handler.dart';
import 'package:zwave/zw_manager.dart';
import 'package:test/test.dart';

class TestCommandHandler implements CommandHandler {
  final expected = <List<int>>[];
  final responses = <List<int>>[];

  @override
  Future<T> request<T>(ZwRequest<T> request) {
    throw 'not implemented';
  }

  @override
  Future<void> send(ZwCommand command) async {
    final data = command.data;
    if (expected.isEmpty) fail('unexpected send: $data');
    final expectedData = expected.removeAt(0);
    expect(data, equals(expectedData), reason: 'request');

    command.responseCompleter!.complete(responses.removeAt(0));
  }
}

class TestManager extends TestCommandHandler implements ZwManager {
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const delayedResponse = <int>[1, 4, 1, 19, 1, 232];
