import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:zwave/command/zw_runner.dart';
import 'package:zwave/zwave.dart';

/// Main entry point for command line exploration of a zwave network.
main(List<String> args) async {
  const configPathKey = 'configPath';
  const userPathKey = 'userPath';
  const logLevelKey = 'logLevel';
  const portKey = 'port';

  const logLevels = const <Level>[
    Level.OFF,
    Level.SEVERE,
    Level.WARNING,
    Level.INFO,
    Level.CONFIG,
    Level.FINE,
    Level.FINER,
    Level.FINEST
  ];
  const defaultRPiConfigPath = '/usr/local/etc/openzwave';
  const defaultLinuxPort1 = '/dev/ttyACM0';
  const defaultLinuxPort2 = '/dev/ttyUSB0';

  var examplePort = '"$defaultLinuxPort1" or "$defaultLinuxPort2"';
  if (Platform.isMacOS) examplePort = '"/dev/cu.usbserial"';
  if (Platform.isWindows) examplePort = '"\\\\.\\COM6"';

  var parser = new ArgParser()
    ..addOption(configPathKey,
        abbr: 'c',
        help: 'The path to the directory containing '
            'the `manufacturer_specific.xml` file.\n'
            'On Raspberry Pi this defaults to `$defaultRPiConfigPath`')
    ..addOption(userPathKey,
        abbr: 'u',
        help: 'The directory in which the Z-Wave network configuration file\n'
            'is written along with other local configuration information')
    ..addOption(logLevelKey,
        abbr: 'l',
        help: 'Determines the amount of information about the Z-Wave process\n'
            'that is displayed in the console.\n'
            'Valid values: '
            '${logLevels.map((l) => l.name.toLowerCase()).join(' ')}')
    ..addOption(portKey,
        abbr: 'p',
        help: 'The port used by the Open Z-Wave library to communicate with'
            ' the Z-Wave Controller. \n'
            'For example: $examplePort');

  int usage([String errorMessage]) {
    if (errorMessage != null) {
      print('');
      print(errorMessage);
    }
    print('');
    print('This utility is used to explore and update Z-Wave networks.');
    print('');
    print(parser.usage);
    return 1;
  }

  ArgResults results;
  try {
    results = parser.parse(args);
  } catch (e) {
    return usage('$e');
  }

  const configFileName = 'manufacturer_specific.xml';
  String configPath = results[configPathKey];
  if (configPath == null) {
    if (Platform.isLinux) {
      if (new File(join(defaultRPiConfigPath, configFileName)).existsSync())
        configPath = defaultRPiConfigPath;
    }
  }
  if (configPath == null) {
    return usage('Please specify $configPathKey');
  }
  var configDir = new Directory(configPath);
  if (!await configDir.exists()) {
    return usage('The $configPathKey directory does not exist\n  $configPath');
  }
  var configFile = new File(join(configPath, configFileName));
  if (!await configFile.exists()) {
    return usage('Could not find $configFileName in configPath\n  $configPath');
  }

  String userPath = results[userPathKey];
  if (userPath == null) {
    return usage('Please specify $userPathKey');
  }
  var userDir = new Directory(userPath);
  if (!await userDir.exists()) {
    return usage('The $userPathKey directory does not exist\n   $userPath');
  }
  const userFilePrefix = 'zwcfg_';
  var userFileFound = false;
  await for (var entity in userDir.list()) {
    var name = basename(entity.path);
    if (name.startsWith(userFilePrefix) && name.endsWith('.xml')) {
      userFileFound = true;
      break;
    }
  }
  if (!userFileFound) {
    print('No $userFilePrefix*.xml file found in\n  $userPath');
    print('Continue (y/N)?');
    var line = stdin.readLineSync().toLowerCase();
    if (line != 'y' && line != 'yes') return 1;
  }

  Level logLevel;
  var logLevelName = results[logLevelKey];
  if (logLevelName != null) {
    for (Level level in logLevels) {
      if (level.name.toLowerCase() == logLevelName) {
        logLevel = level;
        break;
      }
    }
    if (logLevel == null) {
      return usage('Unknown log level: $logLevelName');
    }
  }

  String port = results[portKey];
  if (port == null) {
    if (Platform.isLinux) {
      // TODO: determine if port file exists
      if (new File(defaultLinuxPort1).existsSync()) {
        port = defaultLinuxPort1;
      } else if (new File(defaultLinuxPort2).existsSync()) {
        port = defaultLinuxPort2;
      }
    }
  }
  if (port == null) {
    return usage('Please specify a $portKey');
  }
  if (!new File(port).existsSync()) {
    // TODO: determine if port file exists
    //return usage('The specified $portKey does not exist:\n  $port');
  }

  var zwave = await ZWave.init(configPath,
      userPath: userPath, logLevel: logLevel, logToConsole: logLevel != null);
  print('Open Z-Wave Library ${zwave.version}');
  print('Connecting to $port');
  await zwave.connect(port);
  print('Querying network...');
  await zwave.update();

  await new ZWRunner(zwave).processStdin();
  await zwave.dispose();
  return 0;
}
