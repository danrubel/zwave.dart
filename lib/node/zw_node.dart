import 'package:logging/logging.dart';
import 'package:zwave/capability/node_naming.dart';
import 'package:zwave/handler/application_command_handler.dart';
import 'package:zwave/handler/application_update_handler.dart';
import 'package:zwave/handler/command_handler.dart';
import 'package:zwave/handler/send_data_dispatcher.dart';
import 'package:zwave/zw_manager.dart';

/// [ZwNode] represents a node in the Z-Wave network.
/// Applications should subclass this and override the necessary
/// handle<CommandClass> methods to process events forwarded
/// from the physical devices.
class ZwNode extends ApplicationCommandHandler<void>
    with ApplicationUpdateHandler<void>, SendDataDispatcher<void> {
  /// The unique id associated with this device in this Z-Wave network.
  final int id;

  late Logger logger;

  /// The [ZwManager] that manages this node.
  /// When sending commands, use [commandHandler] rather than this field.
  /// This field is set by the [ZwManager] add method.
  ZwManager? zwManager;

  /// Return the [CommandHandler] to which commands should be sent.
  CommandHandler? get commandHandler => zwManager;

  ZwNode(this.id) {
    logger = Logger('$runtimeType $id');
  }

  String get description {
    Object node = this;
    if (node is NodeNaming) {
      final name = node.name;
      final location = node.location;
      if (location != null && location.isNotEmpty) {
        if (name != null && name.isNotEmpty) return '${location} ${name}';
        return location;
      } else {
        if (name != null && name.isNotEmpty) return name;
      }
    }
    return '$runtimeType $id';
  }

  @override
  bool processedResult<T>(T result) =>
      zwManager!.processedResult<T>(id, result);
}
