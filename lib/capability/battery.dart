import 'dart:async';

import 'package:zwave/capability/zw_node_mixin.dart';
import 'package:zwave/command/zw_request.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/report/zw_command_class_report.dart';

/// A node that has a battery and supports [COMMAND_CLASS_BATTERY].
abstract class Battery implements ZwNodeMixin {
  /// The last battery report or `null` if none.
  BatteryReport battery;

  /// Return a [Future] that completes with a current battery report.
  Future<BatteryReport> requestBattery() {
    return commandHandler.request(ZwRequest<BatteryReport>(logger, id,
        buildSendDataRequest(id, const [COMMAND_CLASS_BATTERY, BATTERY_GET]),
        processResponse: (data) => battery = BatteryReport(data),
        resultKey: BatteryReport));
  }

  void handleCommandClassBattery(List<int> data) {
    switch (data[8]) {
      case BATTERY_REPORT:
        final report = BatteryReport(data);
        battery = report;
        processedResult<BatteryReport>(report);
        return;
      default:
        return unhandledCommandClass(
            COMMAND_CLASS_BATTERY, 'COMMAND_CLASS_BATTERY', data);
    }
  }
}

class BatteryReport extends ZwCommandClassReport {
  BatteryReport(List<int> data) : super(data);
  /*
   0x01, // SOF
   0x09, // length excluding SOF and checksum
   0x00, // request
   0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
   0x00, // rxStatus
   0x10, // source node 16
   0x03, // command length
   0x80, // COMMAND_CLASS_BATTERY
   0x03, // BATTERY_REPORT
   0x1E, // battery %
   0x7C, // checksum
  */

  String get description =>
      lowBatteryWarning ? 'low battery warning' : 'battery $percent %';

  bool get lowBatteryWarning => data[9] == 0xFF;

  int get percent => lowBatteryWarning ? 0x00 : data[9];
}
