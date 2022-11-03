// Handler for notification reports
// Import zwave/lib/capability/notification_handler.dart rather than directly importing this file

import 'package:logging/logging.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/report/notification_report.dart';

/// [NotificationReportHandler] processes notification reports (/* 0x71 */ COMMAND_CLASS_NOTIFICATION)
/// from the physical devices and forwards them to the associated
/// handle<CommandClassName> method. Subclasses should override the
/// various handle methods as necessary.
mixin NotificationReportHandler<T> {
  Logger get logger;

  T? dispatchNotificationReport(List<int> data) {
    var report = NotificationReport(data);
    switch (report.notificationType) {
      case /* 0x01 */ NOTIFICATION_TYPE_SMOKE_ALARM:
        return handleSmokeAlarmNotification(report);
      case /* 0x02 */ NOTIFICATION_TYPE_CO_ALARM:
        return handleCoAlarmNotification(report);
      case /* 0x03 */ NOTIFICATION_TYPE_CO2_ALARM:
        return handleCo2AlarmNotification(report);
      case /* 0x04 */ NOTIFICATION_TYPE_HEAT_ALARM:
        return handleHeatAlarmNotification(report);
      case /* 0x05 */ NOTIFICATION_TYPE_WATER_ALARM:
        return handleWaterAlarmNotification(report);
      case /* 0x06 */ NOTIFICATION_TYPE_ACCESS_CONTROL:
        return handleAccessControlNotification(report);
      case /* 0x07 */ NOTIFICATION_TYPE_HOME_SECURITY:
        return handleHomeSecurityNotification(report);
      case /* 0x08 */ NOTIFICATION_TYPE_POWER_MANAGEMENT:
        return handlePowerManagementNotification(report);
      case /* 0x09 */ NOTIFICATION_TYPE_SYSTEM:
        return handleSystemNotification(report);
      case /* 0x0A */ NOTIFICATION_TYPE_EMERGENCY_ALARM:
        return handleEmergencyAlarmNotification(report);
      case /* 0x0B */ NOTIFICATION_TYPE_CLOCK:
        return handleClockNotification(report);
      case /* 0x0C */ NOTIFICATION_TYPE_APPLIANCE:
        return handleApplianceNotification(report);
      case /* 0x0D */ NOTIFICATION_TYPE_HOME_HEALTH:
        return handleHomeHealthNotification(report);
      case /* 0x0E */ NOTIFICATION_TYPE_SIREN:
        return handleSirenNotification(report);
      case /* 0x0F */ NOTIFICATION_TYPE_WATER_VALVE:
        return handleWaterValveNotification(report);
      case /* 0x10 */ NOTIFICATION_TYPE_WEATHER_ALARM:
        return handleWeatherAlarmNotification(report);
      case /* 0x11 */ NOTIFICATION_TYPE_IRRIGATION:
        return handleIrrigationNotification(report);
      case /* 0x12 */ NOTIFICATION_TYPE_GAS_ALARM:
        return handleGasAlarmNotification(report);
      case /* 0x13 */ NOTIFICATION_TYPE_PEST_CONTROL:
        return handlePestControlNotification(report);
      case /* 0x14 */ NOTIFICATION_TYPE_LIGHT_SENSOR:
        return handleLightSensorNotification(report);
      case /* 0x15 */ NOTIFICATION_TYPE_WATER_QUALITY_MONITORING:
        return handleWaterQualityMonitoringNotification(report);
      case /* 0x16 */ NOTIFICATION_TYPE_HOME_MONITORING:
        return handleHomeMonitoringNotification(report);
      case /* 0xFF */ NOTIFICATION_TYPE_REQUEST_PENDING:
        return handleRequestPendingNotification(report);
      default:
        return handleUnknownNotificationType(report);
    }
  }

  T? handleAccessControlNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleApplianceNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleClockNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleCo2AlarmNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleCoAlarmNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleEmergencyAlarmNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleGasAlarmNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleHeatAlarmNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleHomeHealthNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleHomeMonitoringNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleHomeSecurityNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleIrrigationNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleLightSensorNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handlePestControlNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handlePowerManagementNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleRequestPendingNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleSirenNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleSmokeAlarmNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleSystemNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleWaterAlarmNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleWaterQualityMonitoringNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleWaterValveNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleWeatherAlarmNotification(NotificationReport report) {
    return unhandledNotification(report);
  }

  T? handleUnknownNotificationType(NotificationReport report) {
    logger.warning(
        'Unknown notification type: ${report.sourceNode} ${report.notificationType} ${report.data}');
    return null;
  }

  T? unhandledNotification(NotificationReport report) {
    logger.warning(
        'Unhandled notification: ${report.sourceNode} ${report.notificationType} ${report.notification} ${report.data}');
    return null;
  }
}
