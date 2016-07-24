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
  Map<int, Map<int, _OZWDevice>> _networkDeviceMap =
      <int, Map<int, _OZWDevice>>{};

  Completer _driverConnected;
  Completer _awakeDevicesUpdated;
  Completer _allDevicesUpdated;

  @override
  Device device(int nodeId, {int networkId}) {
    Map<int, _OZWDevice> network;
    if (networkId != null) {
      network = _networkDeviceMap[networkId];
    } else {
      var networks = _networkDeviceMap.values;
      if (networks.length == 1) network = networks.first;
    }
    if (network == null) {
      var networkKeys = _networkDeviceMap.keys
          .map((key) => '0x${key.toRadixString(16)}')
          .toList();
      throw 'Expected networkId to be one of $networkKeys';
    }
    var device = network[nodeId];
    if (device == null) {
      throw 'Expected nodeId to be one of ${network.keys.toList()..sort()}';
    }
    return device;
  }

  @override
  List<Device> get devices {
    List<Device> result = <Device>[];
    for (Map<int, _OZWDevice> network in _networkDeviceMap.values) {
      result.addAll(network.values);
    }
    return result;
  }

  @override
  String get version native "version";

  /// Initialize the Z-Wave manager singleton.
  /// This should be called exactly once.
  ///
  /// [configPath] is the path to the configuration directory
  /// containing the manufacturer_specific.xml file.
  /// On Raspberry Pi this is "/usr/local/etc/openzwave/"
  ///
  /// The [userPath] specifies the directory in which the Z-Wave network
  /// configuration file is written (see [writeConfig]) and other local
  /// configuration information.
  void initialize(
      String configPath, String userPath, Level logLevel, bool logToConsole) {
    _notificationPort = new ReceivePort();
    _notificationSubscription = _notificationPort.listen(_processNotification);
    _initialize(configPath, userPath, _notificationPort.sendPort,
        logLevel?.value, logToConsole);
  }

  @override
  Future connect(String port) {
    _driverConnected = new Completer();
    _awakeDevicesUpdated = new Completer();
    _allDevicesUpdated = new Completer();
    Future future = _driverConnected.future;
    _connect(port);
    return future;
  }

  @override
  Future update() {
    if (_awakeDevicesUpdated == null) {
      // trigger an update of all known devices
      throw 'not implemented yet';
    }
    return _awakeDevicesUpdated.future;
  }

  @override
  Future allUpdated() => _allDevicesUpdated?.future ?? new Future.value();

  @override
  Future dispose() async {
    await _notificationSubscription?.cancel();
    _notificationSubscription = null;
    _notificationPort?.close();
    _notificationPort = null;
    _destroy();
  }

  @override
  void writeConfig() {
    for (int networkId in _networkDeviceMap.keys) {
      _writeConfig(networkId);
    }
  }

  // ===== Internal =======================================================

  /// Process a native notification.
  /// If the message is an integer, then it is the notification type.
  void _processNotification(dynamic message) {
    int notificationIndex;
    int networkId;
    int nodeId;
    if (message is int) {
      notificationIndex = message;
    } else if (message is List) {
      notificationIndex = message[0];
      networkId = message[1];
      nodeId = message[2];

      var network = _networkDeviceMap[networkId];
      if (network != null) {
        var device = network[nodeId];
        if (device != null) {
          var controller = device._notificationController;
          if (controller != null) {
            controller.add(new Notification(device, notificationIndex, message,
                sceneId: (notificationIndex == NotificationType.SceneEvent
                    ? message[3]
                    : null)));
          }
        }
      }
    } else {
      throw 'Unexpected message: $message';
    }

    switch (notificationIndex) {
      case NotificationType.DriverReady:
        _driverConnected?.complete();
        _driverConnected = null;
        return;
      case NotificationType.DriverFailed:
        _driverConnected?.completeError('Failed to load Open Z-Wave driver');
        _driverConnected = null;
        return;

      case NotificationType.AwakeNodesQueried:
        _awakeDevicesUpdated?.complete();
        _awakeDevicesUpdated = null;
        return;

      case NotificationType.AllNodesQueried:
      case NotificationType.AllNodesQueriedSomeDead:
        _awakeDevicesUpdated?.complete();
        _awakeDevicesUpdated = null;
        _allDevicesUpdated?.complete();
        _allDevicesUpdated = null;
        return;

      case NotificationType.NodeAdded:
        Map<int, _OZWDevice> network =
            _networkDeviceMap.putIfAbsent(networkId, () {
          return <int, Device>{};
        });
        Device device = network.putIfAbsent(nodeId, () {
          Device device = new _OZWDevice(this, networkId, nodeId);
          return device;
        });
        device.lastMsgTime = new DateTime.now();
        return;

      case NotificationType.NodeRemoved:
        _networkDeviceMap[networkId]?.remove(nodeId);
        return;

      case NotificationType.ValueAdded:
        Map<int, _OZWDevice> network = _networkDeviceMap[networkId];
        if (network != null) {
          _OZWDevice device = network[nodeId];
          if (device != null) {
            int valueId = message[3];
            // If value id does not fit in int64, then abort
            // TODO adjust value id to fit
            if (valueId < 0) throw 'value id is too large';
            _OZWValue value;
            switch (message[4]) {
              case ValueType.Bool:
                value = new _OZWBoolValue(device, valueId);
                break;
              case ValueType.Button:
                value = new _OZWButtonValue(device, valueId);
                break;
              case ValueType.Byte:
                value = new _OZWByteValue(device, valueId);
                break;
              case ValueType.Decimal:
                value = new _OZWDoubleValue(device, valueId);
                break;
              case ValueType.Int:
                value = new _OZWIntValue(device, valueId);
                break;
              case ValueType.List:
                value = new _OZWListSelectionValue(device, valueId);
                break;
              case ValueType.Short:
                value = new _OZWShortValue(device, valueId);
                break;
              case ValueType.String:
                value = new _OZWStringValue(device, valueId);
                break;
              default:
                value = new _OZWValue(device, valueId);
                break;
            }
            device._valueMap[valueId] = value;
          }
        }
        return;

      case NotificationType.ValueChanged:
      case NotificationType.ValueRefreshed:
        Map<int, _OZWDevice> network = _networkDeviceMap[networkId];
        if (network != null) {
          _OZWDevice device = network[nodeId];
          if (device != null) {
            int valueId = message[3];
            _OZWValue value = device.values.firstWhere((v) => v.id == valueId);
            if (value is _OZWValue) {
              value._changeController?.add(value.current);
              return;
            }
          }
        }
        return;

      case NotificationType.ValueRemoved:
        int valueId = message[3];
        Map<int, _OZWDevice> network = _networkDeviceMap[networkId];
        if (network != null) {
          _OZWDevice device = network[nodeId];
          if (device != null) {
            device._valueMap.remove(valueId);
          }
        }
        return;

      default:
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
  /// The [userPath] specifies the directory in which the Z-Wave network
  /// configuration file is written (see [writeConfig]) and other local
  /// configuration information.
  ///
  /// [notificationPort] is the isolate port used by the native library
  void _initialize(
      String configPath,
      String userPath,
      SendPort notificationPort,
      int logLevel,
      bool logToConsole) native "initialize";

  _destroy() native "destroy";

  _getNodeBasic(int networkId, int nodeId) native "getNodeBasic";
  _getNodeGeneric(int networkId, int nodeId) native "getNodeGeneric";
  _getNodeSpecific(int networkId, int nodeId) native "getNodeSpecific";
  _getNodeType(int networkId, int nodeId) native "getNodeType";

  _getNodeName(int networkId, int nodeId) native "getNodeName";
  _setNodeName(int networkId, int nodeId, String newName) native "setNodeName";

  _getNodeManufacturerId(int networkId, int nodeId)
      native "getNodeManufacturerId";
  _getNodeManufacturerName(int networkId, int nodeId)
      native "getNodeManufacturerName";
  _getNodeProductId(int networkId, int nodeId) native "getNodeProductId";
  _getNodeProductName(int networkId, int nodeId) native "getNodeProductName";
  _getNodeProductType(int networkId, int nodeId) native "getNodeProductType";

  _getValueAsBool(int networkId, int valueId) native "getValueAsBool";
  _getValueAsByte(int networkId, int valueId) native "getValueAsByte";
  _getValueAsFloat(int networkId, int valueId) native "getValueAsFloat";
  _getValueAsInt(int networkId, int valueId) native "getValueAsInt";
  _getValueAsShort(int networkId, int valueId) native "getValueAsShort";
  _getValueAsString(int networkId, int valueId) native "getValueAsString";

  _getValueListItems(int networkId, int valueId) native "getValueListItems";
  _getValueListSelection(int networkId, int valueId)
      native "getValueListSelection";
  _getValueListSelectionIndex(int networkId, int valueId)
      native "getValueListSelectionIndex";

  _getValueMin(int networkId, int valueId) native "getValueMin";
  _getValueMax(int networkId, int valueId) native "getValueMax";

  _getValueGenre(int networkId, int valueId) native "getValueGenre";
  _getValueIndex(int networkId, int valueId) native "getValueIndex";
  _getValueLabel(int networkId, int valueId) native "getValueLabel";
  _setValueLabel(int networkId, int valueId, String newLabel)
      native "setValueLabel";

  _isValueReadOnly(int networkId, int valueId) native "isValueReadOnly";
  _isValueWriteOnly(int networkId, int valueId) native "isValueWriteOnly";

  _setBoolValue(int networkId, int valueId, bool newValue)
      native "setBoolValue";
  _setByteValue(int networkId, int valueId, int newValue) native "setByteValue";
  _setIntValue(int networkId, int valueId, int newValue) native "setIntValue";
  _setListSelectionValue(int networkId, int valueId, String newValue)
      native "setListSelectionValue";
  _setShortValue(int networkId, int id, int newValue) native "setShortValue";

  _refreshNodeInfo(int networkId, int nodeId) native "refreshNodeInfo";

  _writeConfig(int networkId) native "writeConfig";
}

class _OZWDevice extends Device {
  final OZW zwave;
  final Map<int, _OZWValue> _valueMap = <int, _OZWValue>{};
  StreamController<Notification> _notificationController;
  Stream<Notification> _notificationStream;

  _OZWDevice(this.zwave, int networkId, int nodeId) : super(networkId, nodeId);

  @override
  String get name => zwave._getNodeName(networkId, nodeId);

  @override
  void set name(String newName) =>
      zwave._setNodeName(networkId, nodeId, newName);

  @override
  int get nodeBasic => zwave._getNodeBasic(networkId, nodeId);

  @override
  int get nodeGeneric => zwave._getNodeGeneric(networkId, nodeId);

  @override
  int get nodeSpecific => zwave._getNodeSpecific(networkId, nodeId);

  @override
  String get nodeType => zwave._getNodeType(networkId, nodeId);

  @override
  String get manufacturerId => zwave._getNodeManufacturerId(networkId, nodeId);

  @override
  String get manufacturerName =>
      zwave._getNodeManufacturerName(networkId, nodeId);

  @override
  String get productId => zwave._getNodeProductId(networkId, nodeId);

  @override
  String get productName => zwave._getNodeProductName(networkId, nodeId);

  @override
  String get productType => zwave._getNodeProductType(networkId, nodeId);

  @override
  List<Value> get values => new List.from(_valueMap.values);

  @override
  Stream<Notification> get onNotification {
    if (_notificationController == null) {
      _notificationController = new StreamController<Notification>();
      _notificationStream = _notificationController.stream.asBroadcastStream();
    }
    return _notificationStream;
  }

  @override
  Future<bool> update() async {
    // TODO watch for the appropriate addNode notifications
    // to determine if the node's data was refreshed.
    return zwave._refreshNodeInfo(networkId, nodeId);
  }
}

class _OZWValue<T> implements Value<T> {
  final _OZWDevice device;
  final int id;
  StreamController<T> _changeController;
  Stream<T> _changeStream;

  _OZWValue(this.device, this.id);

  @override
  int get genre => device.zwave._getValueGenre(device.networkId, id);

  @override
  bool get readOnly => device.zwave._isValueReadOnly(device.networkId, id);

  @override
  bool get writeOnly => device.zwave._isValueWriteOnly(device.networkId, id);

  @override
  String get label => device.zwave._getValueLabel(device.networkId, id);

  @override
  void set label(String newLabel) =>
      device.zwave._setValueLabel(device.networkId, id, newLabel);

  @override
  int get index => device.zwave._getValueIndex(device.networkId, id);

  @override
  T get current => null;

  @override
  void set current(T newValue) => throw 'unsupported';

  @override
  Stream<T> get onChange {
    if (_changeController == null) {
      _changeController = new StreamController<T>();
      _changeStream = _changeController.stream.asBroadcastStream();
    }
    return _changeStream;
  }

  String _toString(String typeName) {
    try {
      return '$label($typeName, $id)';
    } catch (_) {
      return '$typeName($id)';
    }
  }
}

class _OZWBoolValue extends _OZWValue<bool> implements BoolValue {
  _OZWBoolValue(_OZWDevice device, int id) : super(device, id);

  @override
  bool get current => device.zwave._getValueAsBool(device.networkId, id);

  @override
  void set current(bool newValue) =>
      device.zwave._setBoolValue(device.networkId, id, newValue);

  @override
  String toString() => _toString('BoolValue');
}

class _OZWButtonValue extends _OZWValue implements ButtonValue {
  _OZWButtonValue(_OZWDevice device, int id) : super(device, id);

  @override
  String toString() => _toString('ButtonValue');
}

class _OZWByteValue extends _OZWIntValue {
  _OZWByteValue(_OZWDevice device, int id) : super(device, id);

  @override
  int get current => device.zwave._getValueAsByte(device.networkId, id);

  @override
  void set current(int newValue) =>
      device.zwave._setByteValue(device.networkId, id, newValue);
}

class _OZWDoubleValue extends _OZWValue<double> implements DoubleValue {
  _OZWDoubleValue(_OZWDevice device, int id) : super(device, id);

  @override
  double get current => device.zwave._getValueAsFloat(device.networkId, id);

  @override
  String toString() => _toString('DoubleValue');
}

class _OZWIntValue extends _OZWValue<int> implements IntValue {
  _OZWIntValue(_OZWDevice device, int id) : super(device, id);

  @override
  int get current => device.zwave._getValueAsInt(device.networkId, id);

  @override
  void set current(int newValue) =>
      device.zwave._setIntValue(device.networkId, id, newValue);

  @override
  int get max => device.zwave._getValueMax(device.networkId, id);

  @override
  int get min => device.zwave._getValueMin(device.networkId, id);

  @override
  String toString() => _toString('IntValue');
}

class _OZWListSelectionValue extends _OZWValue<String>
    implements ListSelectionValue {
  _OZWListSelectionValue(_OZWDevice device, int id) : super(device, id);

  @override
  String get current =>
      device.zwave._getValueListSelection(device.networkId, id);

  @override
  void set current(String newValue) =>
      device.zwave._setListSelectionValue(device.networkId, id, newValue);

  @override
  int get currentIndex =>
      device.zwave._getValueListSelectionIndex(device.networkId, id);

  @override
  List<String> get list =>
      device.zwave._getValueListItems(device.networkId, id);

  @override
  String toString() => _toString('ListSelectionValue');
}

class _OZWShortValue extends _OZWIntValue {
  _OZWShortValue(_OZWDevice device, int id) : super(device, id);

  @override
  int get current => device.zwave._getValueAsShort(device.networkId, id);

  @override
  void set current(int newValue) =>
      device.zwave._setShortValue(device.networkId, id, newValue);
}

class _OZWStringValue extends _OZWValue<String> implements StringValue {
  _OZWStringValue(_OZWDevice device, int id) : super(device, id);

  @override
  String get current => device.zwave._getValueAsString(device.networkId, id);

  @override
  String toString() => _toString('StringValue');
}
