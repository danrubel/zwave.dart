import 'dart:async';

import 'package:zwave/node/sleepy_node.dart';
import 'package:zwave/report/zw_command_class_report.dart';

class UnknownSleepyNode extends SleepyNode {
  UnknownSleepyNode(int id) : super(id);

  @override
  Future<void> handleWakeUpNotification(ZwCommandClassReport? report) {
    logger.warning('wakeup');
    return super.handleWakeUpNotification(report);
  }
}
