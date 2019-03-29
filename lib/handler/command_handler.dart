import 'dart:async';

import 'package:zwave/command/zw_command.dart';
import 'package:zwave/command/zw_request.dart';

abstract class CommandHandler {
  /// Send the specified request to the device and return a future
  /// that completes when the operation is complete.
  Future<T> request<T>(ZwRequest<T> request);

  /// Send the specified request message
  /// and return a [Future] that completes when the message is acknowledged.
  Future<void> send(ZwCommand command);
}
