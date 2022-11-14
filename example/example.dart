import 'dart:async';

import 'package:logging/logging.dart';
import 'package:zwave/port/rpi_zw_port.dart';
import 'package:zwave/zw_manager.dart';
import 'package:zwave/port/zw_port.dart';

import 'wall_switch.dart';

Future<void> main() async {
  print('starting example');
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
    if (rec.error != null) print(rec.error);
    if (rec.stackTrace != null) print(rec.stackTrace);
  });

  final example = Example(RpiZwPort());
  await example.start();
  await example.turnLampOn();
  await Future.delayed(const Duration(seconds: 2));
  await example.turnLampOff();
  await example.stop();
}

class Example {
  final ZwPort port;
  final ZwManager manager;

  // Change `9` to the node id of your wall switch or switched outlet
  final lamp = WallSwitch(9, 'living room', 'lamp');

  Example(this.port) : manager = ZwManager(port.driver) {
    manager.add(lamp);
  }

  Future<void> start() async {
    // Update this line with the path to your Z-Wave controller
    await port.open('/dev/ttyACM0');

    final version = await manager.apiLibraryVersion();
    logger.info(version.toString());
  }

  Future<void> turnLampOn() => lamp.setState(true);
  Future<void> turnLampOff() => lamp.setState(false);

  Future<void> stop() async {
    await port.close();
  }
}

Logger logger = Logger('Example');
