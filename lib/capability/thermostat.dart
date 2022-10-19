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

  Future<void> setFanMode(int mode, {bool? fanOn}) async {
    int offAndMode = ((fanOn ?? true) ? 0x00 : 0x80) + (mode & 0x0F);
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

class ThermostatModeReport extends ZwCommandClassReport {
  ThermostatModeReport(List<int> data) : super(data);

  /// The current thermostat mode, where:
  /// * 0x00 off
  /// * 0x01 heat
  /// * 0x02 cool
  /// * 0x03 auto
  /// * 0x04 auxiliary
  /// * 0x05 resume (on) - command only
  /// * 0x06 fan
  int get mode => data[9] & 0x1F;
}

class ThermostatModeSupportedReport extends ZwCommandClassReport {
  ThermostatModeSupportedReport(List<int> data) : super(data);
}

class ThermostatOperatingStateReport extends ZwCommandClassReport {
  ThermostatOperatingStateReport(List<int> data) : super(data);

  /// The current thermostat state, where:
  /// * 0x00 idle
  /// * 0x01 heating
  /// * 0x02 cooling
  /// * 0x03 fan only
  int get state => data[9] & 0x0F;
}
