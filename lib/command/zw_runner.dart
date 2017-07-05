import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:zwave/command/add_device.dart';
import 'package:zwave/command/battery.dart';
import 'package:zwave/command/device.dart';
import 'package:zwave/command/groups.dart';
import 'package:zwave/command/heal.dart';
import 'package:zwave/command/list.dart';
import 'package:zwave/command/neighbors.dart';
import 'package:zwave/command/polling.dart';
import 'package:zwave/command/remove_device.dart';
import 'package:zwave/command/rename_device.dart';
import 'package:zwave/command/set_group.dart';
import 'package:zwave/command/set_value.dart';
import 'package:zwave/command/util.dart';
import 'package:zwave/zwave.dart';

/// Command line handler
class ZWRunner {
  final ZWave zwave;
  final CommandRunner runner;
  bool running = true;

  ZWRunner(
    this.zwave, {
    bool canQuit: true,
    String executableName: '',
    ProgressHandler progressHandler,
  })
      : runner = new CommandRunner<String>(
            executableName, 'Z-Wave command line utility') {
    runner
      ..addCommand(new AddDeviceCommand(zwave, progressHandler))
      ..addCommand(new BatteryCommand(zwave))
      ..addCommand(new DeviceCommand(zwave))
      ..addCommand(new GroupsCommand(zwave))
      ..addCommand(new HealCommand(zwave))
      ..addCommand(new ListCommand(zwave))
      ..addCommand(new NeighborsCommand(zwave))
      ..addCommand(new PollingCommand(zwave))
      ..addCommand(new RemoveDeviceCommand(zwave, progressHandler))
      ..addCommand(new RenameDeviceCommand(zwave))
      ..addCommand(new SetGroupCommand(zwave))
      ..addCommand(new SetValueCommand(zwave));
    if (canQuit) runner.addCommand(new QuitCommand(this));
  }

  /// Process stdin and print results to stdout.
  Future<Null> processStdin() {
    void prompt() {
      stdout.write('ZW> ');
    }

    var finished = new Completer();
    StreamSubscription subscription;
    prompt();
    subscription = stdin.transform(UTF8.decoder).listen((String line) {
      process(line.trim()).then((String result) {
        stdout.writeln(result);
        if (running) {
          prompt();
        } else {
          subscription.cancel();
          finished.complete();
        }
      });
    });
    return finished.future;
  }

  /// Process the given user input and return the text to be displayed.
  /// If [handler] is not specified, then progress info will be sent to stdout.
  Future<String> process(String line) async {
    if (['', 'h', 'help'].contains(line.trim())) return runner.usage;
    try {
      return await runner.run(line.split(' '));
    } on UsageException catch (e) {
      return '${e.message}\n\n${e.usage}';
    }
  }
}

class QuitCommand extends Command<String> {
  final ZWRunner zw;

  QuitCommand(this.zw);

  @override
  List<String> get aliases => const ['q', 'exit'];

  @override
  String get description => 'Exit the ZW utility.';

  @override
  String get name => 'quit';

  @override
  String run() {
    zw.running = false;
    return 'Exiting...';
  }
}
