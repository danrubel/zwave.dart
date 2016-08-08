/// This Dart library uses the
/// [Open Z-Wave library](https://github.com/OpenZWave/open-zwave/)
/// to communicate with a compatible Z-Wave Controller
/// and interact with Z-Wave devices (also known as Z-Wave nodes).
///
/// # Usage
/// * initialize the [ZWave] manager singleton
/// * access the connected [Device]s via the Z-Wave manager
library zwave;

import 'dart:async';
import 'dart:core';
import 'dart:core' as core;

import 'package:logging/logging.dart';

import 'src/ozw.dart' deferred as ozw;

part 'src/zwave_g.dart';

/// The [ZWave] class interactes with the Z-Wave controller
/// and provids access to any associated Z-Wave [Device]s.
///
/// # Startup
/// Start by initializing the Z-Wave manager singleton via [init].
///
///     ZWave zwave = await ZWave.init(configPath);
///
/// Next, associate one or more controllers and wait for the Z-Wave manager
/// to complete the [Device] discovery process.
///
///     await zwave.connect('/dev/ttyACM0');
///     await zwave.update();
///     zwave.writeConfig(); // optional
///
/// When you first associate a controller, it probes the Z-Wave network
/// to discover all connected [Device]s. On shutdown (when [dispose] is called),
/// this information is written to the Z-Wave network configuration to a file.
/// You can also explicitly trigger this information to be written
/// by calling the [writeConfig] method.
/// On subsequent starts, the network configuration is loaded from this file
/// rather than probing the network.
///
/// # Device access
/// Once startup is complete, use [devices] to obtain a list of connected
/// [Device]s.
abstract class ZWave {
  /// Return the Z-Wave manager singleton.
  /// This should be called exactly once.
  ///
  /// [configPath] is the path to the configuration directory
  /// containing the `manufacturer_specific.xml` file.
  /// On Raspberry Pi this is `/usr/local/etc/openzwave/`
  ///
  /// The [userPath] specifies the directory in which the Z-Wave network
  /// configuration file is written (see [writeConfig]) and other local
  /// configuration information.
  ///
  /// By default, the Open Z-Wave library prints logging information to the
  /// console. To suppress this, set [logToConsole] to false.
  static Future<ZWave> init(String configPath,
      {String userPath, Level logLevel, bool logToConsole}) async {
    await ozw.loadLibrary();
    return new ozw.OZW()
      ..initialize(configPath, userPath, logLevel, logToConsole);
  }

  /// Return the specified device.
  /// If there is only one Z-Wave controller
  /// then only the [nodeId] of the device needs to be specified.
  /// If there are two or more Z-Wave controllers
  /// then both the [nodeId] and the [networkId] must be specified.
  ///
  /// If [name] is not `null`, then the device name will be set to that value.
  /// You may optionally specify a [configuration] map for setting the device's
  /// configuration [Value]s. The [configuration] map keys are either the
  /// [Value] name or the [Value] index, while the [Value] current value is
  /// set to the corresponding map value. An exception is thrown if the [Value]
  /// cannot be found of the [Value] current value cannot be set.
  Device device(int nodeId, {int networkId, String name, Map configuration});

  /// Return a list of the known [Device]s
  /// including the associated Z-Wave controller(s).
  ///
  /// If you only have one associated Z-Wave controller,
  /// then you can obtain the desired [Device] via
  ///
  ///     Device device = zwave.devices.firstWhere((d) => d.nodeId == someId);
  ///
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

  /// Return number of seconds between polls of a node's state.
  int get pollInterval;

  /// Disconnect from the Z-Wave controller, cleanup any resources, and write
  /// the Z-Wave network configuration to a file in the user data directory
  /// (see [writeConfig]).
  /// Returns a [Future] that completes when the process is complete.
  Future dispose();

  /// Write the Z-Wave network configuration to a file in the user data directory.
  /// Normally this is not needed as this file is automatically written
  /// as part of the [dispose] process, but it is useful to call this method
  /// after a new device has been added.
  ///
  /// The Z-Wave network configuration filename consists of the 8 digit
  /// hexadecimal version of the controller's Home ID,
  /// prefixed with the string 'zwcfg_'.
  /// The directory into which this file is written can be specified
  /// via `userPath:` when calling [init].
  void writeConfig();

  /// Return a human readable summary of known devices and their values.
  String summary({bool allValues: false}) {
    var summary = new StringBuffer();
    summary.writeln('poll interval: $pollInterval seconds');
    for (Device device in devices) {
      summary.write(device.summary(allValues: allValues));
    }
    return summary.toString();
  }
}

/// Each Z-Wave node or device has a [networkId] and a [nodeId].
/// If you only have one associated Z-Wave controller (see [ZWave] startup)
/// then you can ignore the [networkId] and just use the [nodeId] to uniquely
/// identify each device.
///
/// Once the [ZWave] manager has been [started](zwave/ZWave-class.html),
/// you can list connected devices
/// via [zwave.devices](zwave/ZWave/devices.html).
///
/// Each device has one or more [Value]s associated with it representing the
/// state of the device and ranging from higher level user values
/// to lower level system values. The [values] method returns all [Value]s
/// associated with the device whereas the [userValues] only returns the
/// higher level values deemed more interesting to the user.
abstract class Device {
  /// The id of the network or Z-Wave controller managing this device.
  /// Each Z-Wave controller has a unique network id.
  final int networkId;

  /// The id of the device on it's network.
  /// This is only unique with respect to other devices on the same network
  /// or associated with the same Z-Wave controllers.
  ///
  /// Typically (always?) the controller has node id 1 and the controller
  /// assigns a node id to each device as it is paired with that controller.
  /// The device keeps that same node id through shutdown and startup
  /// until it is removed or unpaired from that controller.
  final int nodeId;

  /// Return the user editable name of the device.
  String get name;

  /// Set the name of the device.
  void set name(String newName);

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

  /// Return `true` if the device's manufacturer and product information
  /// has not been received by the system, indicating that an [update] may
  /// needed to obtain the device's configuration.
  bool get isNotConfigured =>
      manufacturerId == '0x0000' && productId == '0x0000';

  /// The last time a message was received from this device.
  DateTime lastMsgTime;

  Device(this.networkId, this.nodeId);

  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Device &&
          networkId == other.networkId &&
          nodeId == other.nodeId);

  int get hashCode => networkId * 256 + nodeId;

  /// A stream of [Notification]s related to this device
  /// including [NodeEvents] and [SceneEvents].
  Stream<Notification> get onNotification;

  /// Request all the device's data to be obtained from the Z-Wave network
  /// in the same way as if it had just been added.
  /// Return a future indicating whether or not the request was successful.
  /// This can be combined with [isNotConfigured] to configured new devices
  /// on startup.
  ///
  ///     for (Device device in zwave.devices) {
  ///       if (device.isNotConfigured) device.update();
  ///     }
  ///
  Future<bool> update();

  /// Return the [Value] with the specified [label]. If the device has
  /// more than one value with the same label, then you can supply an [index]
  /// to specify which value is desired. The [index] is *not* the same as the
  /// value's position in the list of [values] or [userValues].
  ///
  /// If no value is found, the result of invoking the [orElse]
  /// function is returned. If [orElse] is omitted or `null`, it defaults to
  /// throwing an exception indicating no matching [Value] was found.
  /// For example:
  ///
  ///     Value myValue = device.value('myNiceLabel', orElse: () {
  ///       return device.value('defaultLabel')..label = 'myNiceLabel';
  ///     });
  ///
  Value value(String label, {int index, Value orElse()}) {
    orElse ??= () {
      var labels = values.map((v) => v.label).toList()..sort();
      throw 'Expected label to be one of $labels';
    };
    // Search userValues first, then all values.
    return userValues.firstWhere((v) {
      return v.label == label && (index == null || v.index == index);
    }, orElse: () {
      return values.firstWhere((v) {
        return v.label == label && (index == null || v.index == index);
      }, orElse: orElse);
    });
  }

  /// Return the [Value] with the specified [index].
  /// Throw an exception if no [Value] is found.
  Value valueByIndex(int index) => values.firstWhere((v) => v.index == index);

  /// Return a list of all values associated with the device.
  List<Value> get values;

  /// Return a list of values an ordinary user would be interested in.
  List<Value> get userValues => values.where((v) => v.genre == ValueGenre.User);

  /// Return a human readable summary of the device and its values.
  String summary({bool allValues: false}) {
    var summary = new StringBuffer();
    summary.write('${toString()} - ');
    if (manufacturerName.isEmpty) {
      summary.write(manufacturerId);
    } else {
      summary.write(manufacturerName);
    }
    if (productName.isEmpty) {
      summary.writeln(', ${productId}');
    } else {
      summary.writeln(', ${productName}');
    }
    for (Value value in (allValues ? values : userValues)) {
      int lineStart = summary.length;
      summary.write('  $value');
      if (value.readOnly) summary.write(', readOnly');
      if (value.writeOnly) summary.write(', writeOnly');
      while (summary.length < lineStart + 65) summary.write(' ');
      summary.write(' = ${value.current}');
      if (value is ListSelectionValue) {
        summary.write(' - ${value.currentIndex}');
      }
      summary.writeln();

      if (value.pollIntensity > 0) {
        summary.write('    pollIntensity = ${value.pollIntensity}');
      }

      if (value is IntValue) {
        summary.writeln('    min ${value.min}, max ${value.max}');
      } else if (value is ListSelectionValue) {
        summary.write('    ');
        for (String item in value.list) {
          summary.write('$item, ');
        }
        summary.writeln();
      }
      String help = value.help;
      if (help?.isNotEmpty == true) summary.writeln('    help: $help');
    }
    return summary.toString();
  }

  String toString() {
    String name;
    try {
      name = this.name;
    } catch (_) {}
    if (name == null || name.isEmpty) name = 'Device';
    return '$name(0x${networkId.toRadixString(16)}, $nodeId)';
  }
}

/// A notification received from the [ZWave] manager.
class Notification {
  final Device device;
  final int notificationIndex;
  final List rawMessage;

  Notification(this.device, this.notificationIndex, this.rawMessage);

  String toString() =>
      '$device ${NotificationType.name(notificationIndex)} $rawMessage)';
}

/// A device notification received from the [ZWave] manager.
class NodeEvent extends Notification {
  final int event;

  NodeEvent(Device device, int notificationIndex, List rawMessage, this.event)
      : super(device, notificationIndex, rawMessage);

  String toString() =>
      '$device ${NotificationType.name(notificationIndex)} event:$event $rawMessage)';
}

/// A device scene event received from the [ZWave] manager.
class SceneEvent extends Notification {
  final int sceneId;

  SceneEvent(
      Device device, int notificationIndex, List rawMessage, this.sceneId)
      : super(device, notificationIndex, rawMessage);

  String toString() =>
      '$device ${NotificationType.name(notificationIndex)} scene:$sceneId $rawMessage)';
}

/// Abstract representation of a specific value.
abstract class Value<T> {
  /// The device containing this value.
  Device get device;

  /// The unique identifier of this value during this session.
  /// This may not be unique after a restart.
  int get id;

  /// The [ValueGenre] of this value.
  int get genre;

  bool get readOnly;
  bool get writeOnly;

  /// Return the index of the value. You can differentiate different values
  /// with the same [label] by the value's [index]. The [index] is
  /// *not* the same as the value's position in the [Device]'s list of values.
  int get index;

  /// Returns the user-friendly label for the value.
  String get label;

  /// Sets the user-friendly label for the value.
  void set label(String newLabel);

  /// Get the help text for the value.
  String get help;

  /// Return the frequency of polling with respect to the [ZWave.pollInterval]
  /// where 0 = no polling, 1 = poll once every poll interval,
  /// 2 = poll every other poll interval, etc.
  int get pollIntensity;

  /// The current state of this value.
  /// Only very occasionally a value is [writeOnly]
  /// in which case this method will throw an exception.
  T get current;

  /// Set the current state of this value (if not [readOnly]).
  /// Due to the possibility of a device being asleep, the operation is assumed
  /// to suceed, the local value is updated directly, and an [onChange]
  /// notification sent. If the Z-Wave message failed to get through then
  /// the value will be reverted to its original state and another [onChange]
  /// notification will be sent.
  void set current(T newValue);

  /// A stream of state changes.
  Stream<T> get onChange;
}

/// Abstract representation of a specific [bool] value.
/// See [ValueType.BoolType]
abstract class BoolValue extends Value<bool> {}

/// Abstract representation of a specific [int] value.
/// See [ValueType.ByteType], [ValueType.ShortType], and [ValueType.IntType].
abstract class IntValue extends Value<int> {
  int get min;
  int get max;
}

/// Abstract representation of a specific [double] value.
/// See [ValueType.DecimalType].
abstract class DoubleValue extends Value<double> {}

/// Abstract representation of a specific [String] value.
/// See [ValueType.StringType].
abstract class StringValue extends Value<String> {}

/// Abstract representation of a specific list selection value.
/// See [ValueType.ListType].
abstract class ListSelectionValue extends Value<String> {
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
  /// Always return `null` because a ButtonValue can only be set.
  dynamic get current => null;
}

/// Abstract representation of a specific raw value.
/// See [ValueType.RawType].
abstract class RawValue extends Value {}
