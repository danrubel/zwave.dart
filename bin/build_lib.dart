import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

const zwavePkgName = 'zwave';
const buildScriptVersion = 1;

main(List<String> args) {
  // Locate the Dart SDK
  File dartVm = new File(Platform.executable);
  if (!dartVm.isAbsolute) {
    print('Dart VM... ${dartVm.path}');
    String path = Process.runSync('which', ['dart']).stdout;
    dartVm = new File(path.trim());
  }
  Directory dartSdk = dartVm.parent.parent;
  File headerFile = new File(join(dartSdk.path, 'include', 'dart_api.h'));
  if (!headerFile.existsSync()) {
    print('Dart VM... ${dartVm.path}');
    String path = Process.runSync('readlink', ['-f', dartVm.path]).stdout;
    dartVm = new File(path.trim());
    dartSdk = dartVm.parent.parent;
    headerFile = new File(join(dartSdk.path, 'include', 'dart_api.h'));
  }
  print('Dart VM... ${dartVm.path}');
  print('Dart SDK... ${dartSdk.path}');
  assertExists('include file', headerFile);

  // Run pub list to determine the location of the zwave package being used
  var pubResult = JSON.decode(Process
      .runSync(join(dartSdk.path, 'bin', 'pub'), ['list-package-dirs']).stdout);
  assertNoPubListError(pubResult);
  var zwaveDir = new Directory(pubResult['packages'][zwavePkgName]);
  print('Building library in ${zwaveDir.path}');

  // Display the version of the rpi_gpio being built
  var pubspecFile = new File(join(zwaveDir.path, '..', 'pubspec.yaml'));
  assertExists('pubspec', pubspecFile);
  var pubspec = pubspecFile.readAsStringSync();
  print('zwave version ${parseVersion(pubspec)}');

  // Build the native library
  var nativeDir = new Directory(join(zwaveDir.path, 'src', 'native'));
  var buildScriptFile = new File(join(nativeDir.path, 'build_lib'));
  // TODO remove this line and add build support for all platforms
  assertRunningOnRaspberryPi();
  var buildResult = Process.runSync(
      buildScriptFile.path, [buildScriptVersion.toString(), dartSdk.path]);
  print(buildResult.stdout);
  print(buildResult.stderr);
}

/// Parse the given content and return the version string
String parseVersion(String pubspec) {
  var key = 'version:';
  int start = pubspec.indexOf(key) + key.length;
  int end = pubspec.indexOf('\n', start);
  return pubspec.substring(start, end).trim();
}

/// Assert that the given file or directory exists.
assertExists(String name, FileSystemEntity entity) {
  if (entity.existsSync()) return;
  print('Failed to find $name: ${entity.path}');
  throw 'Aborting build';
}

/// Assert that the given pub list result does not indicate an error
void assertNoPubListError(Map<String, String> pubResult) {
  var error = pubResult['error'];
  if (error == null) {
    var packages = pubResult['packages'];
    if (packages != null) {
      var rpiGpio = packages[zwavePkgName];
      if (rpiGpio != null) {
        return;
      }
      print('Cannot find $zwavePkgName in pub list result');
      print('Must run this script on app referencing $zwavePkgName package');
      throw 'Aborting build';
    }
    print('Cannot find packages in pub list result');
    throw 'Aborting build';
  }
  print(error);
  print('Must run this script from directory containing pubspec.yaml file');
  throw 'Aborting build';
}

/// Assert that this script is executing on the Raspberry Pi.
assertRunningOnRaspberryPi() {
  if (!isRaspberryPi) {
    print('''
This has not been tested on any platforms other than Raspberry Pi.
To try it out on a different platform, modify this file to remove the call
to this method and send me the result along with any log files and error messages.
''');
    throw 'Aborting build';
  }
}

/// Return [true] if this is running on a Raspberry Pi.
bool get isRaspberryPi {
  if (!Platform.isLinux) return false;
  try {
    if (new File('/etc/os-release').readAsLinesSync().contains('ID=raspbian')) {
      return true;
    }
  } on FileSystemException catch (_) {
    // fall through
  }
  return false;
}
