import 'dart:async';

import 'package:zwave/capability/zw_node_mixin.dart';
import 'package:zwave/command/zw_request.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/report/zw_command_class_report.dart';

/// A switched node that supports the [SwitchBinarySet] command.
abstract class SwitchBinary implements ZwNodeMixin {
  /// `true` if the switch is on, `false` if it is off,
  /// or `null` if the current state is unknown.
  bool state;

  /// The % which the switch is on where
  /// 0x00       = off
  /// 0x01..0x63 = partially on
  /// 0xFF       = fully on
  /// null       = unknown
  /// Non-dimmable switches will only have values 0x00 and 0xFF.
  int stateValue;

  void handleCommandClassSwitchBinary(List<int> data) {
    switch (data[8]) {
      case SWITCH_BINARY_REPORT:
        final report = new SwitchBinaryReport(data);
        stateValue = report.value;
        state = stateValue > 0;
        processedResult<SwitchBinaryReport>(report);
        return;
      default:
        return unhandledCommandClass(
            COMMAND_CLASS_SWITCH_BINARY, 'COMMAND_CLASS_SWITCH_BINARY', data);
    }
  }

  /// Request the current state of the switch.
  /// Return true if the request was successful, else false.
  Future<void> requestState() async {
    SwitchBinaryReport report =
        await commandHandler.request(new ZwRequest<SwitchBinaryReport>(
      logger,
      id,
      buildSendDataRequest(id, [
        COMMAND_CLASS_SWITCH_BINARY,
        SWITCH_BINARY_GET,
      ]),
      processResponse: (data) => new SwitchBinaryReport(data),
      resultKey: SwitchBinaryReport,
    ));
    stateValue = report.value;
    state = stateValue > 0;
    return true;
  }

  /// Set the current state of the switch.
  Future<void> setState(bool newState) async {
    final newStateValue = newState ? 0xFF : 0x00;
    await commandHandler.request(new ZwRequest<void>(
      logger,
      id,
      buildSendDataRequest(id, [
        COMMAND_CLASS_SWITCH_BINARY,
        SWITCH_BINARY_SET,
        newStateValue,
      ]),
    ));
    state = newState;
    stateValue = newStateValue;
  }

  /// Set the current state of the switch as a percent.
  Future<void> setStateValue(int value) async {
    final newStateValue = value <= 0 ? 0 : value <= 0x63 ? value : 0xFF;
    final newState = value > 0;
    await commandHandler.request(new ZwRequest<void>(
      logger,
      id,
      buildSendDataRequest(id, [
        COMMAND_CLASS_SWITCH_BINARY,
        SWITCH_BINARY_SET,
        newStateValue,
      ]),
    ));
    state = newState;
    stateValue = newStateValue;
  }
}

/// [SwitchBinaryReport] decodes the
/// COMMAND_CLASS_SWITCH_BINARY, SWITCH_BINARY_REPORT message
class SwitchBinaryReport extends ZwCommandClassReport {
  SwitchBinaryReport(List<int> data) : super(data);

  /// 0x00       = off
  /// 0x01..0x63 = % on
  /// 0xFF       = on
  int get value => data[9];
}
