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
  void initialize(String configPath, Level logLevel) {
    _notificationPort = new ReceivePort();
    _notificationSubscription = _notificationPort.listen(_processNotification);
    _initialize(configPath, _notificationPort.sendPort, logLevel?.value);
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
        print('>>> ${NotificationType.name(notificationIndex)}: $message');
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
        print('>>> ${NotificationType.name(notificationIndex)}: $message');
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

  _destroy() native "destroy";

  _getNodeBasic(int networkId, int nodeId) native "getNodeBasic";
  _getNodeGeneric(int networkId, int nodeId) native "getNodeGeneric";
  _getNodeSpecific(int networkId, int nodeId) native "getNodeSpecific";
  _getNodeType(int networkId, int nodeId) native "getNodeType";

  _getNodeManufacturerId(int networkId, int nodeId) native "getNodeManufacturerId";
  _getNodeManufacturerName(int networkId, int nodeId) native "getNodeManufacturerName";
  _getNodeProductId(int networkId, int nodeId) native "getNodeProductId";
  _getNodeProductName(int networkId, int nodeId) native "getNodeProductName";
  _getNodeProductType(int networkId, int nodeId) native "getNodeProductType";

  _getValueAsBool(int networkId, int valueId) native "getValueAsBool";
  _getValueAsByte(int networkId, int id) native "getValueAsByte";
  _getValueAsInt(int networkId, int id) native "getValueAsInt";
  _getValueAsShort(int networkId, int id) native "getValueAsShort";
  _getValueAsString(int networkId, int id) native "getValueAsString";

  _getValueListItems(int networkId, int id) native "getValueListItems";
  _getValueListSelection(int networkId, int id) native "getValueListSelection";
  _getValueListSelectionIndex(int networkId, int id)
      native "getValueListSelectionIndex";

  _getValueMin(int networkId, int id) native "getValueMin";
  _getValueMax(int networkId, int id) native "getValueMax";
}

class _OZWDevice extends Device {
  final OZW zwave;
  final Map<int, _OZWValue> _valueMap = <int, _OZWValue>{};

  _OZWDevice(this.zwave, int networkId, int nodeId) : super(networkId, nodeId);

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
}

class _OZWValue implements Value {
  final _OZWDevice device;
  final int id;

  _OZWValue(this.device, this.id);

  @override
  get current => null;

  @override
  String toString() => 'Value($id)';
}

class _OZWBoolValue extends _OZWValue implements BoolValue {
  _OZWBoolValue(_OZWDevice device, int id) : super(device, id);

  @override
  bool get current => device.zwave._getValueAsBool(device.networkId, id);

  @override
  String toString() => 'BoolValue($id)';
}

class _OZWButtonValue extends _OZWValue implements ButtonValue {
  _OZWButtonValue(_OZWDevice device, int id) : super(device, id);

  @override
  String toString() => 'ButtonValue($id)';
}

class _OZWByteValue extends _OZWIntValue {
  _OZWByteValue(_OZWDevice device, int id) : super(device, id);

  @override
  int get current => device.zwave._getValueAsByte(device.networkId, id);

  @override
  String toString() => 'ByteValue($id)';
}

class _OZWIntValue extends _OZWValue implements IntValue {
  _OZWIntValue(_OZWDevice device, int id) : super(device, id);

  @override
  int get current => device.zwave._getValueAsInt(device.networkId, id);

  @override
  int get max => device.zwave._getValueMin(device.networkId, id);

  @override
  int get min => device.zwave._getValueMax(device.networkId, id);

  @override
  String toString() => 'IntValue($id)';
}

class _OZWListSelectionValue extends _OZWValue implements ListSelectionValue {
  _OZWListSelectionValue(_OZWDevice device, int id) : super(device, id);

  @override
  String get current =>
      device.zwave._getValueListSelection(device.networkId, id);

  @override
  int get currentIndex =>
      device.zwave._getValueListSelectionIndex(device.networkId, id);

  @override
  List<String> get list =>
      device.zwave._getValueListItems(device.networkId, id);

  @override
  String toString() => 'ListSelectionValue($id)';
}

class _OZWShortValue extends _OZWIntValue {
  _OZWShortValue(_OZWDevice device, int id) : super(device, id);

  @override
  int get current => device.zwave._getValueAsShort(device.networkId, id);

  @override
  String toString() => 'ShortValue($id)';
}

class _OZWStringValue extends _OZWValue implements StringValue {
  _OZWStringValue(_OZWDevice device, int id) : super(device, id);

  @override
  String get current => device.zwave._getValueAsString(device.networkId, id);

  @override
  String toString() => 'StringValue($id)';
}
