// Notification type constants
// Import zwave/lib/message_consts.dart rather than directly importing this file

export 'package:zwave/src/notification_types.g.dart';

/// [NotificationType] represents the various notifications for [COMMAND_CLASS_NOTIFICATION].
class NotificationType {
  final int value;
  final String name;
  final List<NotificationValue?> notifications;

  const NotificationType(this.value, this.name, this.notifications);
}

/// [NotificationValue] represents the various notifications for a given [NotificationType].
class NotificationValue {
  final int value;
  final String name;

  const NotificationValue(this.value, this.name);
}
