/// This Dart library uses the
/// [Open Z-Wave library](https://github.com/OpenZWave/open-zwave/)
/// to communicate with a compatible Z-Wave Controller
/// and interact with Z-Wave devices.
///
/// # Using
/// Start by initializing the Z-Wave manager singleton:
///
///     ZWave zwave = await ZWave.init(configPath);
///
/// When you first initialize the Z-Wave manager, it probes the Z-Wave network
/// to discover all connected devices. On shutdown (when [dispose] is called),
/// this information is written to the Z-Wave network configuration to a file.
/// On subsequent starts, the network configuration is loaded from this file
/// rather than probing the network.
library zwave;

import 'dart:async';
import 'dart:core';
import 'dart:core' as core;

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
  /// Returns a future when all nodes (or all awake nodes) have been updated
  /// and the zwave manager is ready for commands.
  /// Before this future completes, messages to the zwave manager
  /// can cause a segfault.
  Future update();

  /// Return a future that completes when information for all devices,
  /// including sleeping devices, has been updated.
  Future allUpdated();

  /// Disconnect from the Z-Wave controller, cleanup any resources, and write
  /// the Z-Wave network configuration to a file in the current directory.
  /// The filename consists of the 8 digit hexadecimal version of the
  /// controller's Home ID, prefixed with the string 'zwcfg_'.
  /// Returns a [Future] that completes when the process is complete.
  Future dispose();
}

abstract class Device {
  final int networkId;
  final int nodeId;

  /// Get the basic type of a node.
  int get nodeBasic;

  /// Get the generic type of a node.
  int get nodeGeneric;

  /// Get the specific type of a node.
  int get nodeSpecific;

  /// Return a human-readable label describing the node.
  String get nodeType;

  /// Return the manufacturer's Z-Wave identifier, a four digit hex code.
  String get manufacturerId;

  /// Return the manufacturer's name.
  String get manufacturerName;

  /// Return the manufacturer's product ID, a four digit hex code.
  String get productId;

  /// Return the manufacturer's product name.
  String get productName;

  /// Return the manufacturer's product type, a four digit hex code.
  String get productType;

  /// The last time a message was received from this device.
  DateTime lastMsgTime;

  Device(this.networkId, this.nodeId);

  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Device &&
          networkId == other.networkId &&
          nodeId == other.nodeId);

  int get hashCode => networkId * 256 + nodeId;

  /// Return a list of all values associated with the device.
  List<Value> get values;

  /// Return a list of values an ordinary user would be interested in.
  List<Value> get userValues => values.where((v) => v.genre == ValueGenre.User);

  String toString() => 'Device($networkId, $nodeId)';
}

/// Abstract representation of a specific value.
abstract class Value {
  Device get device;
  int get id;
  String get label;
  dynamic get current;

  get genre => null;
}

/// Abstract representation of a specific [bool] value.
/// See [ValueType.BoolType]
abstract class BoolValue extends Value {
  bool get current;
}

/// Abstract representation of a specific [int] value.
/// See [ValueType.ByteType], [ValueType.ShortType], and [ValueType.IntType].
abstract class IntValue extends Value {
  int get current;
  int get min;
  int get max;
}

/// Abstract representation of a specific [double] value.
/// See [ValueType.DecimalType].
abstract class DoubleValue extends Value {
  double get current;
}

/// Abstract representation of a specific [String] value.
/// See [ValueType.StringType].
abstract class StringValue extends Value {
  String get current;
}

/// Abstract representation of a specific list selection value.
/// See [ValueType.ListType].
abstract class ListSelectionValue extends Value {
  /// Return the currently selected list element.
  String get current;

  /// Return the index associated with the currently selected list element.
  /// `v.currentIndex != v.list.indexOf(v.current)`
  int get currentIndex => null;

  /// Return a list of possible selections.
  List<String> get list;
}

/// Abstract representation of a specific schedule value.
/// See [ValueType.ScheduleType].
abstract class ScheduleValue extends Value {}

/// Abstract representation of a specific button value.
/// See [ValueType.ButtonType].
abstract class ButtonValue extends Value {
  /// Alwyas return `null` because a ButtonValue can only be set.
  dynamic get current => null;
}

/// Abstract representation of a specific raw value.
/// See [ValueType.RawType].
abstract class RawValue extends Value {}
