import 'dart:async';
import 'dart:convert';

import 'package:zwave/capability/zw_node_mixin.dart';
import 'package:zwave/command/zw_request.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/report/zw_command_class_report.dart';

/// A node that has a name and location and supports
/// the [COMMAND_CLASS_NODE_NAMING] commands.
abstract class NodeNaming implements ZwNodeMixin {
  /// The node name or `null` if it has not been set or retrieved.
  /// Use [setNodeName] to set the name on the device itself
  /// or set this field directly to only set the name locally.
  String name;

  /// The node location or `null` if it has not been set or retrieved.
  /// Use [setNodeLocation] to set the location on the device itself
  /// or set this field directly to only set the location locally.
  String location;

  /// Request the name from the device.
  Future<String> requestNodeName() async {
    await commandHandler.request(
      ZwRequest(
        logger,
        id,
        buildSendDataRequest(id, [
          COMMAND_CLASS_NODE_NAMING,
          NODE_NAMING_NODE_NAME_GET,
        ]),
        resultKey: NodeNameReport,
      ),
    );
    return name;
  }

  /// Send the name to the device.
  Future<void> setNodeName(String name) {
    if (name == null || name.isEmpty || name.length > 16)
      throw 'invalid name: $name';
    this.name = name;
    final cmdData = [
      COMMAND_CLASS_NODE_NAMING,
      NODE_NAMING_NODE_NAME_SET,
      0x00, // ASCII characters 0 - 127
    ];
    cmdData.addAll(buildAsciiChars(name));
    return commandHandler.request(ZwRequest(
      logger,
      id,
      buildSendDataRequest(id, cmdData),
    ));
  }

  /// Request the location from the device.
  Future<String> requestNodeLocation() async {
    await commandHandler.request(
      ZwRequest(
        logger,
        id,
        buildSendDataRequest(id, [
          COMMAND_CLASS_NODE_NAMING,
          NODE_NAMING_NODE_LOCATION_GET,
        ]),
        resultKey: NodeLocationReport,
      ),
    );
    return location;
  }

  /// Send the location to the device.
  Future<void> setNodeLocation(String location) {
    if (location == null || location.isEmpty || location.length > 16)
      throw 'invalid name: $location';
    this.location = location;
    final cmdData = [
      COMMAND_CLASS_NODE_NAMING,
      NODE_NAMING_NODE_LOCATION_SET,
      0x00, // ASCII characters 0 - 127
    ];
    cmdData.addAll(buildAsciiChars(location));
    return commandHandler
        .request(ZwRequest(logger, id, buildSendDataRequest(id, cmdData)));
  }

  @override
  void handleCommandClassNodeNaming(List<int> data) {
    switch (data[8]) {
      case NODE_NAMING_NODE_NAME_REPORT:
        var nameReport = NodeNameReport(data);
        name = nameReport.name;
        processedResult<NodeNameReport>(nameReport);
        return;
      case NODE_NAMING_NODE_LOCATION_REPORT:
        var locationReport = NodeLocationReport(data);
        location = locationReport.location;
        processedResult<NodeLocationReport>(locationReport);
        return;
      default:
        return unhandledCommandClass(
            COMMAND_CLASS_NODE_NAMING, 'COMMAND_CLASS_NODE_NAMING', data);
    }
  }
}

class NodeNameReport extends ZwCommandClassReport {
  NodeNameReport(List<int> data) : super(data);

  /// The character encoding
  /// - 0x00 = ASCII
  /// - 0x01 = standard and OEM Extended ASCII codes
  /// - 0x02 = Unicode UTF-16
  int get encoding => data[9] & 0x03;

  String get name {
    final codeUnits = data.sublist(10, data.length - 1);
    switch (encoding) {
      case 0: // ASCII
        return utf8.decode(codeUnits);
      default:
        // TODO implement this
        return null;
    }
  }
}

class NodeLocationReport extends ZwCommandClassReport {
  NodeLocationReport(List<int> data) : super(data);

  /// The character encoding
  /// - 0x00 = ASCII
  /// - 0x01 = standard and OEM Extended ASCII codes
  /// - 0x02 = Unicode UTF-16
  int get encoding => data[9] & 0x03;

  String get location {
    final codeUnits = data.sublist(10, data.length - 1);
    switch (encoding) {
      case 0: // ASCII
        return utf8.decode(codeUnits);
      default:
        // TODO implement this
        return null;
    }
  }
}
