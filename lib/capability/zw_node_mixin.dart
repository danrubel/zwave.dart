import 'package:zwave/handler/application_command_handler.dart';
import 'package:zwave/handler/command_handler.dart';
import 'package:logging/logging.dart';

/// Mixins that can mixed in with [ZwNode] typically implement this.
abstract class ZwNodeMixin implements ApplicationCommandHandler<void> {
  /// Return the [CommandHandler] to which commands should be sent.
  CommandHandler? get commandHandler;

  /// The unique id associated with this device in this Z-Wave network.
  int get id;

  Logger get logger;

  /// Called when a node has processed an unsolicited request so that any
  /// outstanding request waiting for that information can be completed.
  /// Returns `true` if an outstanding request was satisified, else `false`.
  bool processedResult<T>(T result);
}
