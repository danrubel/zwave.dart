import 'package:zwave/report/zw_command_class_report.dart';

/// [NotificationReport] decodes the COMMAND_CLASS_NOTIFICATION, NOTIFICATION_REPORT message
class NotificationReport extends ZwCommandClassReport {
  NotificationReport(List<int> data) : super(data);

  int get notificationType => data[13];

  int get notification => data[14];
}
