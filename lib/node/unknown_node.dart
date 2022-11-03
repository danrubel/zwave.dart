import 'dart:async';

import 'package:zwave/node/unknown_sleepy_node.dart';
import 'package:zwave/node/zw_node.dart';
import 'package:zwave/report/zw_command_class_report.dart';

class UnknownNode extends ZwNode {
  UnknownNode(int id) : super(id);

  @override
  Future<void> handleWakeUpNotification(ZwCommandClassReport report) async {
    final sleepyNode = UnknownSleepyNode(id);
    zwManager!.add(sleepyNode);
    return sleepyNode.handleWakeUpNotification(report);
  }
}
