import 'dart:async';

import 'package:zwave/command/zw_request.dart';
import 'package:zwave/handler/command_handler.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/node/zw_node.dart';
import 'package:zwave/report/zw_command_class_report.dart';
import 'package:zwave/src/queued_command_handler.dart';
import 'package:zwave/zw_exception.dart';

/// [SleepyNode] subclasses represent Z-Wave devices
/// that spend most time in an unresponsive sleeping state.
///
/// Typically these nodes wake up on a set schedule
/// or if they sense some physical event that they need to report.
/// Only during these awake periods can communication occur.
/// Commands are queued so that they can be sent during the awake periods.
class SleepyNode extends ZwNode {
  final _queue = QueuedCommandHandler();

  /// The last time that the wakeup notifications was received from the device
  /// or `null` if no wakeup notification has been received.
  DateTime lastWakeupTime;

  SleepyNode(int id) : super(id);

  @override
  CommandHandler get commandHandler => _queue;

  @override
  Future<void> handleWakeUpNotification(ZwCommandClassReport report) async {
    lastWakeupTime = DateTime.now();
    logger.finer('handle wakeup');
    try {
      await _queue.sendQueuedCommands(zwManager);
    } on ZwException catch (e) {
      logger.warning('queued command failed: $e');
    } catch (e, s) {
      logger.warning('queued command exception', e, s);
    }
    logger.finer('sending sleep command');
    await zwManager.request(ZwRequest(
      logger,
      id,
      buildSendDataRequest(id, [
        COMMAND_CLASS_WAKE_UP,
        WAKE_UP_NO_MORE_INFORMATION,
      ]),
    ));
  }
}
