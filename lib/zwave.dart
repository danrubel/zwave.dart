library zwave;

import 'dart:async';

import 'package:logging/logging.dart';

import 'src/ozw.dart' deferred as ozw;

part 'zwave_g.dart';

/// The [ZWave] class interactes with the Z-Wave controller
/// and provids access to any paired Z-Wave devices.
abstract class ZWave {
  /// Return the Z-Wave manager singleton.
  /// This should be called exactly once.
  ///
  /// [configPath] is the path to the configuration directory
  /// containing the manufacturer_specific.xml file.
  /// On Raspberry Pi this is "/usr/local/etc/openzwave/"
  static Future<ZWave> init(String configPath, {Level logLevel}) async {
    await ozw.loadLibrary();
    return new ozw.OZW()..initialize(configPath, logLevel);
  }

  /// Return a list of the known devices at this point in time.
  List<Device> get devices;

  /// Return the version of the Open Z-Wave library
  String get version;

  /// Connect to a Z-Wave controller.
  /// Return a [Future] that completes when the connection is established.
  ///
  /// [port] is the port used by the Open Z-Wave library to communicate with
  /// the Z-Wave Controller. For example...
  /// * Windows: "\\\\.\\COM6".
  /// * Mac OSX: "/dev/cu.usbserial"
  /// * Linux:   "/dev/ttyUSB0" or "/dev/ttyACM0"
  Future connect(String port);

  /// Update (or finish updating) the list of known devices.
  /// Returns a future when the update is complete.
  Future update();

  /// Disconnect from the Z-Wave controller and cleanup any resources.
  /// Returns a [Future] that completes when the process is complete.
  Future dispose();
}

class Device {
  final int networkId;
  final int nodeId;

  /// The last time a message was received from this device.
  DateTime lastMsgTime;

  Device(this.networkId, this.nodeId);

  String toString() => 'Device($networkId, $nodeId)';
}
