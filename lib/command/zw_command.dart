import 'dart:async';

import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:zwave/command/util.dart';
import 'package:zwave/zwave.dart';

/// `ZWCommand` provides common behavior for all of the ZW commands.
abstract class ZWCommand extends Command<String> {
  final ZWave zwave;
  final String name;
  final String description;
  final String argumentDescription;
  final List<String> aliases;
  final bool takesArguments;
  final ProgressHandler progressHandler;

  ZWCommand(
    this.zwave,
    this.name, {
    this.description,
    this.argumentDescription = '',
    this.aliases: const [],
    this.takesArguments: true,
    this.progressHandler,
  });

  @override
  String get invocation =>
      super.invocation.replaceAll('[arguments]', argumentDescription);

  List<Device> get devicesSortedById {
    var sorted = zwave.devices
      ..sort((d1, d2) {
        return d1.networkId != d2.networkId
            ? d1.networkId - d2.networkId
            : d1.nodeId - d2.nodeId;
      });
    return sorted;
  }

  bool get hasMultipleNetworks {
    var devices = zwave.devices;
    if (devices.isEmpty) return false;
    var networkId = devices[0].networkId;
    for (Device d in devices) {
      if (networkId != d.networkId) return true;
    }
    return false;
  }

  @override
  String get usage {
    String text = super.usage;
    if (aliases.isEmpty) return text;
    int index = text.indexOf('Usage: ');
    while (text[index] != '\r' && text[index] != '\n') ++index;
    var buf = new StringBuffer(text.substring(0, index));
    buf.writeln();
    if (aliases.length == 1) {
      buf.write('Alias: ');
    } else {
      buf.write('Aliases: ');
    }
    buf.write(aliases.join(', '));
    buf.write(text.substring(index));
    return buf.toString();
  }

  /// Search for and return a matching device.
  /// If one cannot be found, then append error information to `buf`
  /// and return `null`.
  Device findDevice(StringBuffer buf, String networkArg, String nodeArg) {
    int networkId = parseInt(networkArg);
    int nodeId = parseInt(nodeArg);
    if (networkId == -1) {
      invalidArgument(buf, 'network id', networkArg);
      return null;
    }
    if (nodeId == -1) {
      invalidArgument(buf, 'node id', nodeArg);
      return null;
    }

    Device device = zwave.devices.firstWhere((device) {
      return device.nodeId == nodeId &&
          (networkId == null || device.networkId == networkId);
    }, orElse: () => null);
    if (device == null) {
      buf.write('Device $nodeId');
      if (networkId != null)
        buf.write(' in network 0x${networkId.toRadixString(16)}');
      buf.writeln(' not found');
      buf.writeln();
      buf.writeln(usage);
    }
    return device;
  }

  /// Display progress information to the user.
  void progress(String message) {
    if (progressHandler != null) {
      progressHandler(message);
    } else {
      stdout
        ..writeln(message)
        ..flush();
    }
  }

  @override
  Future<String> run() async {
    var buf = new StringBuffer();
    await runWith(buf);
    return buf.toString();
  }

  /// Subclasses override this method to perform the operation.
  runWith(StringBuffer buf);

  bool checkNoMoreArgs(StringBuffer buf) {
    if (argResults.rest.isEmpty) return true;
    unknownArguments(buf);
    return false;
  }

  void invalidArgument(StringBuffer buf, String argName, String arg) {
    buf.writeln('Invalid <$argName>: $arg');
    buf.writeln();
    buf.writeln(usage);
  }

  void missingArgument(StringBuffer buf, String argName) {
    buf.writeln('Please specify <$argName>');
    buf.writeln();
    buf.writeln(usage);
  }

  void unknownArguments(StringBuffer buf, [List<String> args]) {
    args ??= argResults.rest;
    buf.write('Unknown argument');
    if (args.length > 1) buf.write('s');
    buf.write(': ');
    buf.writeln(args.join(' '));
    buf.writeln();
    buf.writeln(usage);
  }
}
