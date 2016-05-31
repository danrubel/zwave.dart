library ozw;

import 'dart:async';
import 'dart:isolate';

import 'package:logging/logging.dart';

import '../zwave.dart';
import 'dart-ext:ozw_ext';

/// [OZW] provides synchronous access to a Z-Wave controller
/// via the Open Z-Wave native library.
class OZW extends ZWave {
  /// The port used by the native library to forward notifications.
  ReceivePort _notificationPort;
  StreamSubscription _notificationSubscription;

  /// A map of {networkId --> map of {nodeId --> device}}
  Map<int, Map<int, Device>> _deviceMap = <int, Map<int, Device>>{};

  /// A list of known devices;
  List<Device> _devices = <Device>[];

  Completer _driverConnected;
  Completer _devicesUpdated;

  @override
  List<Device> get devices => new List<Device>.unmodifiable(_devices);

  @override
  String get version native "version";

  /// Initialize the Z-Wave manager singleton.
  /// This should be called exactly once.
  ///
  /// [configPath] is the path to the configuration directory
  /// containing the manufacturer_specific.xml file.
  /// On Raspberry Pi this is "/usr/local/etc/openzwave/"
  void initialize(String configPath, Level logLevel) {
    _notificationPort = new ReceivePort();
    _notificationSubscription = _notificationPort.listen(_processNotification);
    _initialize(configPath, _notificationPort.sendPort, logLevel?.value);
  }

  @override
  Future connect(String port) {
    _driverConnected = new Completer();
    _devicesUpdated = new Completer();
    Future future = _driverConnected.future;
    _connect(port);
    return future;
  }

  @override
  Future update() {
    if (_devicesUpdated == null) {
      // trigger an update of all known devices
      throw 'not implemented yet';
    }
    return _devicesUpdated.future;
  }

  @override
  Future dispose() async {
    await _notificationSubscription?.cancel();
    _notificationSubscription = null;
    _notificationPort?.close();
    _notificationPort = null;
  }

  // ===== Internal =======================================================

  /// Process a native notification.
  /// If the message is an integer, then it is the notification type.
  void _processNotification(dynamic message) {
    int notificationIndex;
    if (message is int) {
      notificationIndex = message;
    } else if (message is List) {
      notificationIndex = message[0];
    } else {
      throw 'Unexpected message: $message';
    }

    switch (notificationIndex) {
      case NotificationIndex_DriverReady:
        _driverConnected?.complete();
        _driverConnected = null;
        return;
      case NotificationIndex_DriverFailed:
        _driverConnected?.completeError('Failed to load Open Z-Wave driver');
        _driverConnected = null;
        return;

      case NotificationIndex_AllNodesQueried:
      case NotificationIndex_AllNodesQueriedSomeDead:
      case NotificationIndex_AwakeNodesQueried:
        _devicesUpdated?.complete();
        _devicesUpdated = null;
        return;

      case NotificationIndex_NodeAdded:
        int networkId = message[1];
        int nodeId = message[2];
        Map<int, Device> network = _deviceMap.putIfAbsent(networkId, () {
          return <int, Device>{};
        });
        Device device = network.putIfAbsent(nodeId, () {
          Device device = new Device(networkId, nodeId);
          _devices.add(device);
          return device;
        });
        device.lastMsgTime = new DateTime.now();
        return;

      default:
        // NotificationType type = NotificationType.list[notificationIndex];
        // print('>>> notification: ${type.name} $message');
        return;
    }
  }

  // ===== Native =========================================================

  /// Connect to the Z-Wave controller, where [port] is the port used by
  /// the native Open Z-Wave library to communicate with the controller.
  /// The connection operation is not complete
  /// until the [NotificationType.DriverReady] notification is received.
  void _connect(String port) native "connect";

  /// Initialize the Open Z-Wave library.
  ///
  /// [configPath] is the path to the configuration directory
  /// containing the manufacturer_specific.xml file.
  /// On Raspberry Pi this is "/usr/local/etc/openzwave/"
  ///
  /// [notificationPort] is the isolate port used by the native library
  void _initialize(String configPath, SendPort notificationPort, int logLevel)
      native "initialize";
}
