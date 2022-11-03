import 'dart:async';

import 'package:zwave/capability/zw_node_mixin.dart';
import 'package:zwave/command/zw_request.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/report/zw_command_class_report.dart';

/// A node that supports the various [COMMAND_CLASS_THERMOSTAT_*] commands.
abstract class Thermostat implements ZwNodeMixin {
  /// The current fan mode or `null` if unknown.
  /// This correlates to the thermostat fan setting.
  ThermostatFanModeReport? fanMode;

  /// The current fan state or `null` if unknown.
  /// This indicates whether or not the fan is running.
  ThermostatFanStateReport? fanState;

  /// The current thermostat mode or `null` if unknown.
  /// This correlates to the thermostat heat/cool setting.
  ThermostatModeReport? mode;

  /// The current thermostat state or `null` if unknown.
  /// This indicates system is currently heating or cooling.
  ThermostatOperatingStateReport? operatingState;

  /// The current thermostat heating set point or `null` if unknown.
  /// This correlates to the thermostat heating target temperature.
  ThermostatSetPointReport? heatingSetPoint;

  /// The current thermostat cooling set point or `null` if unknown.
  /// This correlates to the thermostat cooling target temperature.
  ThermostatSetPointReport? coolingSetPoint;

  @override
  void handleCommandClassThermostatFanMode(List<int> data) {
    switch (data[8]) {
      case THERMOSTAT_FAN_MODE_REPORT:
        processedResult<ThermostatFanModeReport>(
            fanMode = ThermostatFanModeReport(data));
        return;
      case THERMOSTAT_FAN_MODE_SUPPORTED_REPORT:
        processedResult<ThermostatFanModeSupportedReport>(
            ThermostatFanModeSupportedReport(data));
        return;
      default:
        return unhandledCommandClass(COMMAND_CLASS_THERMOSTAT_FAN_MODE,
            'COMMAND_CLASS_THERMOSTAT_FAN_MODE', data);
    }
  }

  @override
  void handleCommandClassThermostatFanState(List<int> data) {
    switch (data[8]) {
      case THERMOSTAT_FAN_STATE_REPORT:
        processedResult<ThermostatFanStateReport>(
            fanState = ThermostatFanStateReport(data));
        return;
      default:
        return unhandledCommandClass(COMMAND_CLASS_THERMOSTAT_FAN_STATE,
            'COMMAND_CLASS_THERMOSTAT_FAN_STATE', data);
    }
  }

  @override
  void handleCommandClassThermostatMode(List<int> data) {
    switch (data[8]) {
      case THERMOSTAT_MODE_REPORT:
        processedResult<ThermostatModeReport>(
            mode = ThermostatModeReport(data));
        return;
      case THERMOSTAT_MODE_SUPPORTED_REPORT:
        processedResult<ThermostatModeSupportedReport>(
            ThermostatModeSupportedReport(data));
        return;
      default:
        return unhandledCommandClass(COMMAND_CLASS_THERMOSTAT_MODE,
            'COMMAND_CLASS_THERMOSTAT_MODE', data);
    }
  }

  @override
  void handleCommandClassThermostatOperatingState(List<int> data) {
    switch (data[8]) {
      case THERMOSTAT_OPERATING_STATE_REPORT:
        processedResult<ThermostatOperatingStateReport>(
            operatingState = ThermostatOperatingStateReport(data));
        return;
      default:
        return unhandledCommandClass(COMMAND_CLASS_THERMOSTAT_OPERATING_STATE,
            'COMMAND_CLASS_THERMOSTAT_OPERATING_STATE', data);
    }
  }

  @override
  void handleCommandClassThermostatSetpoint(List<int> data) {
    switch (data[8]) {
      case THERMOSTAT_SETPOINT_REPORT:
        processedResult<ThermostatSetPointReport>(updateSetPoint(data));
        return;
      default:
        return unhandledCommandClass(COMMAND_CLASS_THERMOSTAT_SETPOINT,
            'COMMAND_CLASS_THERMOSTAT_SETPOINT', data);
    }
  }

  Future<ThermostatFanModeReport> requestFanMode() {
    return commandHandler!.request(ZwRequest(
        logger,
        id,
        buildSendDataRequest(id, [
          COMMAND_CLASS_THERMOSTAT_FAN_MODE,
          THERMOSTAT_FAN_MODE_GET,
        ]),
        processResponse: (data) => fanMode = ThermostatFanModeReport(data),
        resultKey: ThermostatFanModeReport));
  }

  Future<ThermostatFanModeSupportedReport> requestFanModeSupported() {
    return commandHandler!.request(ZwRequest(
        logger,
        id,
        buildSendDataRequest(id, [
          COMMAND_CLASS_THERMOSTAT_FAN_MODE,
          THERMOSTAT_FAN_MODE_SUPPORTED_GET,
        ]),
        processResponse: (data) => ThermostatFanModeSupportedReport(data),
        resultKey: ThermostatFanModeSupportedReport));
  }

  Future<ThermostatFanStateReport> requestFanState() {
    return commandHandler!.request(ZwRequest(
        logger,
        id,
        buildSendDataRequest(id, [
          COMMAND_CLASS_THERMOSTAT_FAN_STATE,
          THERMOSTAT_FAN_STATE_GET,
        ]),
        processResponse: (data) => fanState = ThermostatFanStateReport(data),
        resultKey: ThermostatFanStateReport));
  }

  Future<ThermostatModeReport> requestMode() {
    return commandHandler!.request(ZwRequest(
        logger,
        id,
        buildSendDataRequest(id, [
          COMMAND_CLASS_THERMOSTAT_MODE,
          THERMOSTAT_MODE_GET,
        ]),
        processResponse: (data) => mode = ThermostatModeReport(data),
        resultKey: ThermostatModeReport));
  }

  Future<ThermostatModeSupportedReport> requestModeSupported() {
    return commandHandler!.request(ZwRequest(
        logger,
        id,
        buildSendDataRequest(id, [
          COMMAND_CLASS_THERMOSTAT_MODE,
          THERMOSTAT_MODE_SUPPORTED_GET,
        ]),
        processResponse: (data) => ThermostatModeSupportedReport(data),
        resultKey: ThermostatModeSupportedReport));
  }

  Future<ThermostatOperatingStateReport> requestOperatingState() {
    return commandHandler!.request(ZwRequest(
        logger,
        id,
        buildSendDataRequest(id, [
          COMMAND_CLASS_THERMOSTAT_OPERATING_STATE,
          THERMOSTAT_OPERATING_STATE_GET,
        ]),
        processResponse: (data) =>
            operatingState = ThermostatOperatingStateReport(data),
        resultKey: ThermostatOperatingStateReport));
  }

  Future<void> setFanMode(int mode, {bool fanOn = true}) async {
    var offAndMode = (fanOn ? 0x00 : 0x80) + (mode & 0x0F);
    await commandHandler!.request(ZwRequest(
      logger,
      id,
      buildSendDataRequest(id, [
        COMMAND_CLASS_THERMOSTAT_FAN_MODE,
        THERMOSTAT_FAN_MODE_SET,
        offAndMode,
      ]),
    ));
    fanMode = ThermostatFanModeReport._(id, offAndMode);
  }

  Future<ThermostatSetPointReport> requestSetPoint(int setPointType) {
    return commandHandler!.request(ZwRequest(
        logger,
        id,
        buildSendDataRequest(id, [
          COMMAND_CLASS_THERMOSTAT_SETPOINT,
          THERMOSTAT_SETPOINT_GET,
          setPointType,
        ]),
        processResponse: (data) => updateSetPoint(data),
        resultKey: ThermostatSetPointReport));
  }

  ThermostatSetPointReport updateSetPoint(List<int> data) {
    var setPoint = ThermostatSetPointReport(data);
    switch (setPoint.setPointType) {
      case ThermostatSetPointType.heating:
        heatingSetPoint = setPoint;
        break;
      case ThermostatSetPointType.cooling:
        coolingSetPoint = setPoint;
        break;
    }
    return setPoint;
  }
}

class ThermostatFanModeReport extends ZwCommandClassReport {
  ThermostatFanModeReport(List<int> data) : super(data);

  ThermostatFanModeReport._(int id, int offAndMode)
      : super([
          0x01, 0x09, 0x00, 0x04, 0x00, id,
          0x03, 0x80, 0x03, offAndMode,
          0x00, //
        ]);
  /*
   0x01, // SOF
   0x09, // length excluding SOF and checksum
   0x00, // request
   0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
   0x00, // rxStatus
   0x10, // source node 16
   0x03, // command length
   0x80, // COMMAND_CLASS_THERMOSTAT_FAN_MODE
   0x03, // THERMOSTAT_FAN_MODE_REPORT
   0x01, // fan mode
   0x7C, // checksum
  */

  bool get isOff => (data[9] & 0x80) > 0;

  bool get isOn => !isOff;

  /// The current fan mode, where:
  /// * 0x00 low speed - auto on/off
  /// * 0x01 low speed - continuous
  /// * 0x02 high speed - auto on/off
  /// * 0x03 high speed - continuous
  /// * 0x04 medium speed - auto on/off
  /// * 0x05 medium speed - continuous
  int get mode => data[9] & 0x0F;
}

class ThermostatFanModeSupportedReport extends ZwCommandClassReport {
  ThermostatFanModeSupportedReport(List<int> data) : super(data);
  /*
   0x01, // SOF
   0x09, // length excluding SOF and checksum
   0x00, // request
   0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
   0x00, // rxStatus
   0x10, // source node 16
   0x03, // command length
   0x80, // COMMAND_CLASS_THERMOSTAT_FAN_MODE
   0x03, // THERMOSTAT_FAN_MODE_SUPPORTED_REPORT
   0x01, // bit mask 1 - flags for modes 0 - 7
   ...
   0x10, // bit mask n - flags for modes
   0x7C, // checksum
  */
}

class ThermostatFanStateReport extends ZwCommandClassReport {
  ThermostatFanStateReport(List<int> data) : super(data);

  /// The current fan state, where:
  /// * 0x00 idle/off
  /// * 0x01 running/running-low
  /// * 0x02 running high
  int get state => data[9] & 0x1F;
}

/// Thermostat mode constants
class ThermostatMode {
  ThermostatMode._();
  static const off = 0x00;
  static const heat = 0x01;
  static const cool = 0x02;
  static const auto = 0x03;
  static const auxiliary = 0x04;
  static const resume = 0x05;
  static const fan = 0x06;
}

class ThermostatModeReport extends ZwCommandClassReport {
  ThermostatModeReport(List<int> data) : super(data);

  /// The current thermostat mode as defined in [ThermostatMode]
  int get mode => data[9] & 0x1F;
}

class ThermostatModeSupportedReport extends ZwCommandClassReport {
  ThermostatModeSupportedReport(List<int> data) : super(data);
}

class ThermostatOperatingState {
  ThermostatOperatingState._();
  static const idle = 0x00;
  static const heating = 0x01;
  static const cooling = 0x02;
  static const fanOnly = 0x03;
}

class ThermostatOperatingStateReport extends ZwCommandClassReport {
  ThermostatOperatingStateReport(List<int> data) : super(data);

  /// The current thermostat state as defined in [ThermostatOperatingState]
  int get state => data[9] & 0x0F;
}

/// Thermostat set point type constants
class ThermostatSetPointType {
  ThermostatSetPointType._();
  static const heating = 0x01;
  static const cooling = 0x02;
  static const furnace = 0x07;
  static const dryAir = 0x08;
  static const moistAir = 0x09;
  static const autoChangeover = 0x0A;
  static const energySaveHeating = 0x0B;
  static const energySaveCooling = 0x0C;
  static const awayHeating = 0x0D;
  static const awayCooling = 0x0E;
  static const fullPower = 0x0F;
}

/// Thermostat set point scale constants
class ThermostatSetPointScale {
  ThermostatSetPointScale._();
  static const celsius = 0;
  static const fahrenheit = 1;
}

class ThermostatSetPointReport extends ZwCommandClassReport {
  ThermostatSetPointReport(List<int> data) : super(data);

  /// The current set point types are defined in [ThermostatSetPointType]
  int get setPointType => data[9] & 0x0F;

  /// The units of measurement as defined in [ThermostatSetPointScale]
  int get scale => (data[10] >> 3) & 0x03;

  /// [precision] is the # of decimal places in the value
  int get precision => (data[10] >> 5) & 0x07;

  /// # of bytes in the value = 1, 2, 4
  int get valueSize => data[10] & 0x07;

  /// The raw temperature in either fahrenheit or celsius depending on [scale]
  num get value => bytesToNum(data.sublist(11, 11 + valueSize), precision);

  /// The temperature in degrees Celsius
  num get temperature {
    var temperature = value;
    if (scale == ThermostatSetPointScale.fahrenheit)
      temperature = (temperature - 32) * 5 / 9;
    return temperature;
  }
}
