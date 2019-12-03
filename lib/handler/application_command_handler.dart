import 'package:zwave/message_consts.dart';
import 'package:zwave/report/basic_report.dart';
import 'package:zwave/report/meter_report.dart';
import 'package:zwave/report/scene_activation_set.dart';
import 'package:zwave/report/security_message_encapsulation.dart';
import 'package:zwave/report/sensor_multilevel_report.dart';
import 'package:zwave/report/zw_command_class_report.dart';
import 'package:zwave/src/application_command_handler_base.g.dart';

/// [ApplicationCommandHandler] decodes some of the various
/// ApplicationCommandHandler messages from the physical devices
/// and forwards those messages to various handle methods
abstract class ApplicationCommandHandler<T>
    extends ApplicationCommandHandlerBase<T> {
  /*
  command class message data:
  data[0] - 0x01 SOF
  data[1] - message length excluding SOF and checksum
  data[2] - 0x00 request or 0x01 response
  data[3] - function id 0x04 application command
  data[4] - rxStatus
  data[5] - source node
  data[6] - command length
  data[7] - command class (e.g. COMMAND_CLASS_METER)
  data[*] - command data
  data[n] - checksum
  */

  T handleCommandClassBasic(List<int> data) {
    switch (data[8]) {
      case BASIC_SET:
        return handleBasicSet(BasicReport(data));
      default:
        return super.handleCommandClassBasic(data);
    }
  }

  T handleBasicSet(BasicReport report) {
    logger.warning('Unhandled BasicSet from ${report.sourceNode}');
    return null;
  }

  T handleCommandClassSceneActivation(List<int> data) {
    switch (data[8]) {
      case SCENE_ACTIVATION_SET:
        return handleSceneActivationSet(SceneActivationSet(data));
      default:
        return super.handleCommandClassSceneActivation(data);
    }
  }

  T handleSceneActivationSet(SceneActivationSet scene) {
    return unhandledReport('SceneActivationSet', scene);
  }

  T handleCommandClassSecurity(List<int> data) {
    switch (data[8]) {
      case SECURITY_NONCE_GET:
        return handleSecurityNonceGet(ZwCommandClassReport(data));
      case SECURITY_MESSAGE_ENCAPSULATION:
        return handleSecurityMessageEncapsulation(
            SecurityMessageEncapsulation(data));
      case SECURITY_MESSAGE_ENCAPSULATION_NONCE_GET:
        return handleSecurityMessageEncapsulationNonceGet(
            SecurityMessageEncapsulation(data));
      default:
        return super.handleCommandClassSecurity(data);
    }
  }

  T handleSecurityNonceGet(ZwCommandClassReport report) {
    logger.warning('Unhandled SecurityNonceGet from ${report.sourceNode}');
    return null;
  }

  T handleSecurityMessageEncapsulation(SecurityMessageEncapsulation message) {
    logger.warning(
        'Unhandled SecurityMessageEncapsulation from ${message.sourceNode}');
    return null;
  }

  T handleSecurityMessageEncapsulationNonceGet(
      SecurityMessageEncapsulation message) {
    logger.warning(
        'Unhandled SecurityMessageEncapsulationNonceGet from ${message.sourceNode}');
    return null;
  }

  T handleMeterReport(MeterReport report) {
    switch (report.type) {
      case METER_ELECTRICAL:
        return handleElectricalMeterReport(report);
      default:
        return unhandledReport('MeterReport', report);
    }
  }

  T handleElectricalMeterReport(MeterReport report) =>
      unhandledReport('ElectricalMeterReport', report);

  T handleSensorMultilevelReport(SensorMultilevelReport report) {
    switch (report.type) {
      case SENSOR_MULTILEVEL_AIR_TEMPERATURE:
        return handleSensorMultilevelAirTemperature(report);
      case SENSOR_MULTILEVEL_POWER:
        return handleSensorMultilevelPower(report);
      case SENSOR_MULTILEVEL_HUMIDITY:
        return handleSensorMultilevelHumidity(report);
      default:
        return unhandledReport('SensorMultilevelReport', report);
    }
  }

  T handleSensorMultilevelAirTemperature(SensorMultilevelReport report) =>
      unhandledReport('SensorMultilevelAirTemperature', report);

  T handleSensorMultilevelHumidity(SensorMultilevelReport report) =>
      unhandledReport('SensorMultilevelHumidity', report);

  T handleSensorMultilevelPower(SensorMultilevelReport report) =>
      unhandledReport('SensorMultilevelPower', report);

  @override
  T handleCommandClassWakeUp(List<int> data) {
    switch (data[8]) {
      case WAKE_UP_NOTIFICATION:
        return handleWakeUpNotification(ZwCommandClassReport(data));
      default:
        return super.handleCommandClassWakeUp(data);
    }
  }

  T handleWakeUpNotification(ZwCommandClassReport report) {
    logger.warning('Unhandled wake up notification from ${report.sourceNode}');
    return null;
  }

  T unhandledReport(String reportName, ZwCommandClassReport report) {
    logger.warning(
        'Unhandled $reportName from ${report.sourceNode}: ${report.data}');
    return null;
  }
}
