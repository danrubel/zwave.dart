import 'package:logging/logging.dart';
import 'package:zwave/src/command_class_ids.g.dart';
import 'package:zwave/report/basic_report.dart';
import 'package:zwave/report/sensor_binary_report.dart';
import 'package:zwave/report/meter_report.dart';
import 'package:zwave/report/sensor_multilevel_report.dart';

/// [CommandClassDispatcher] processes ApplicationCommandHandler messages
/// (messages with FUNC_ID_APPLICATION_COMMAND_HANDLER)
/// from the physical devices and forwards them to the associated
/// handle<CommandClassName> method. Subclasses should override the
/// various handle methods as necessary.
abstract class ApplicationCommandHandlerBase<T> {
  Logger get logger;
  List<T Function(List<int>)> handlers;

  T dispatchApplicationCommand(List<int> data) {
    switch (data[7]) {
      case /* 0x00 */ COMMAND_CLASS_NO_OPERATION:
        return handleCommandClassNoOperation(data);
      case /* 0x20 */ COMMAND_CLASS_BASIC:
        return handleCommandClassBasic(data);
      case /* 0x21 */ COMMAND_CLASS_CONTROLLER_REPLICATION:
        return handleCommandClassControllerReplication(data);
      case /* 0x22 */ COMMAND_CLASS_APPLICATION_STATUS:
        return handleCommandClassApplicationStatus(data);
      case /* 0x23 */ COMMAND_CLASS_ZIP:
        return handleCommandClassZip(data);
      case /* 0x25 */ COMMAND_CLASS_SWITCH_BINARY:
        return handleCommandClassSwitchBinary(data);
      case /* 0x26 */ COMMAND_CLASS_SWITCH_MULTILEVEL:
        return handleCommandClassSwitchMultilevel(data);
      case /* 0x27 */ COMMAND_CLASS_SWITCH_ALL:
        return handleCommandClassSwitchAll(data);
      case /* 0x28 */ COMMAND_CLASS_SWITCH_TOGGLE_BINARY:
        return handleCommandClassSwitchToggleBinary(data);
      case /* 0x29 */ COMMAND_CLASS_SWITCH_TOGGLE_MULTILEVEL:
        return handleCommandClassSwitchToggleMultilevel(data);
      case /* 0x2B */ COMMAND_CLASS_SCENE_ACTIVATION:
        return handleCommandClassSceneActivation(data);
      case /* 0x2C */ COMMAND_CLASS_SCENE_ACTUATOR_CONF:
        return handleCommandClassSceneActuatorConf(data);
      case /* 0x2D */ COMMAND_CLASS_SCENE_CONTROLLER_CONF:
        return handleCommandClassSceneControllerConf(data);
      case /* 0x30 */ COMMAND_CLASS_SENSOR_BINARY:
        return handleCommandClassSensorBinary(data);
      case /* 0x31 */ COMMAND_CLASS_SENSOR_MULTILEVEL:
        return handleCommandClassSensorMultilevel(data);
      case /* 0x32 */ COMMAND_CLASS_METER:
        return handleCommandClassMeter(data);
      case /* 0x33 */ COMMAND_CLASS_SWITCH_COLOR:
        return handleCommandClassSwitchColor(data);
      case /* 0x34 */ COMMAND_CLASS_NETWORK_MANAGEMENT_INCLUSION:
        return handleCommandClassNetworkManagementInclusion(data);
      case /* 0x35 */ COMMAND_CLASS_METER_PULSE:
        return handleCommandClassMeterPulse(data);
      case /* 0x36 */ COMMAND_CLASS_BASIC_TARIFF_INFO:
        return handleCommandClassBasicTariffInfo(data);
      case /* 0x37 */ COMMAND_CLASS_HRV_STATUS:
        return handleCommandClassHrvStatus(data);
      case /* 0x39 */ COMMAND_CLASS_HRV_CONTROL:
        return handleCommandClassHrvControl(data);
      case /* 0x3A */ COMMAND_CLASS_DCP_CONFIG:
        return handleCommandClassDcpConfig(data);
      case /* 0x3B */ COMMAND_CLASS_DCP_MONITOR:
        return handleCommandClassDcpMonitor(data);
      case /* 0x3C */ COMMAND_CLASS_METER_TBL_CONFIG:
        return handleCommandClassMeterTblConfig(data);
      case /* 0x3D */ COMMAND_CLASS_METER_TBL_MONITOR:
        return handleCommandClassMeterTblMonitor(data);
      case /* 0x3E */ COMMAND_CLASS_METER_TBL_PUSH:
        return handleCommandClassMeterTblPush(data);
      case /* 0x3F */ COMMAND_CLASS_PREPAYMENT:
        return handleCommandClassPrepayment(data);
      case /* 0x40 */ COMMAND_CLASS_THERMOSTAT_MODE:
        return handleCommandClassThermostatMode(data);
      case /* 0x41 */ COMMAND_CLASS_PREPAYMENT_ENCAPSULATION:
        return handleCommandClassPrepaymentEncapsulation(data);
      case /* 0x42 */ COMMAND_CLASS_THERMOSTAT_OPERATING_STATE:
        return handleCommandClassThermostatOperatingState(data);
      case /* 0x43 */ COMMAND_CLASS_THERMOSTAT_SETPOINT:
        return handleCommandClassThermostatSetpoint(data);
      case /* 0x44 */ COMMAND_CLASS_THERMOSTAT_FAN_MODE:
        return handleCommandClassThermostatFanMode(data);
      case /* 0x45 */ COMMAND_CLASS_THERMOSTAT_FAN_STATE:
        return handleCommandClassThermostatFanState(data);
      case /* 0x46 */ COMMAND_CLASS_CLIMATE_CONTROL_SCHEDULE:
        return handleCommandClassClimateControlSchedule(data);
      case /* 0x47 */ COMMAND_CLASS_THERMOSTAT_SETBACK:
        return handleCommandClassThermostatSetback(data);
      case /* 0x48 */ COMMAND_CLASS_RATE_TBL_CONFIG:
        return handleCommandClassRateTblConfig(data);
      case /* 0x49 */ COMMAND_CLASS_RATE_TBL_MONITOR:
        return handleCommandClassRateTblMonitor(data);
      case /* 0x4A */ COMMAND_CLASS_TARIFF_CONFIG:
        return handleCommandClassTariffConfig(data);
      case /* 0x4B */ COMMAND_CLASS_TARIFF_TBL_MONITOR:
        return handleCommandClassTariffTblMonitor(data);
      case /* 0x4C */ COMMAND_CLASS_DOOR_LOCK_LOGGING:
        return handleCommandClassDoorLockLogging(data);
      case /* 0x4D */ COMMAND_CLASS_NETWORK_MANAGEMENT_BASIC:
        return handleCommandClassNetworkManagementBasic(data);
      case /* 0x4E */ COMMAND_CLASS_SCHEDULE_ENTRY_LOCK:
        return handleCommandClassScheduleEntryLock(data);
      case /* 0x4F */ COMMAND_CLASS_ZIP_6LOWPAN:
        return handleCommandClassZip6lowpan(data);
      case /* 0x50 */ COMMAND_CLASS_BASIC_WINDOW_COVERING:
        return handleCommandClassBasicWindowCovering(data);
      case /* 0x51 */ COMMAND_CLASS_MTP_WINDOW_COVERING:
        return handleCommandClassMtpWindowCovering(data);
      case /* 0x52 */ COMMAND_CLASS_NETWORK_MANAGEMENT_PROXY:
        return handleCommandClassNetworkManagementProxy(data);
      case /* 0x53 */ COMMAND_CLASS_SCHEDULE:
        return handleCommandClassSchedule(data);
      case /* 0x54 */ COMMAND_CLASS_NETWORK_MANAGEMENT_PRIMARY:
        return handleCommandClassNetworkManagementPrimary(data);
      case /* 0x55 */ COMMAND_CLASS_TRANSPORT_SERVICE:
        return handleCommandClassTransportService(data);
      case /* 0x56 */ COMMAND_CLASS_CRC_16_ENCAP:
        return handleCommandClassCrc16Encap(data);
      case /* 0x57 */ COMMAND_CLASS_APPLICATION_CAPABILITY:
        return handleCommandClassApplicationCapability(data);
      case /* 0x58 */ COMMAND_CLASS_ZIP_ND:
        return handleCommandClassZipNd(data);
      case /* 0x59 */ COMMAND_CLASS_ASSOCIATION_GRP_INFO:
        return handleCommandClassAssociationGrpInfo(data);
      case /* 0x5A */ COMMAND_CLASS_DEVICE_RESET_LOCALLY:
        return handleCommandClassDeviceResetLocally(data);
      case /* 0x5B */ COMMAND_CLASS_CENTRAL_SCENE:
        return handleCommandClassCentralScene(data);
      case /* 0x5C */ COMMAND_CLASS_IP_ASSOCIATION:
        return handleCommandClassIpAssociation(data);
      case /* 0x5D */ COMMAND_CLASS_ANTITHEFT:
        return handleCommandClassAntitheft(data);
      case /* 0x5E */ COMMAND_CLASS_ZWAVEPLUS_INFO:
        return handleCommandClassZwaveplusInfo(data);
      case /* 0x5F */ COMMAND_CLASS_ZIP_GATEWAY:
        return handleCommandClassZipGateway(data);
      case /* 0x60 */ COMMAND_CLASS_MULTI_CHANNEL:
        return handleCommandClassMultiChannel(data);
      case /* 0x61 */ COMMAND_CLASS_ZIP_PORTAL:
        return handleCommandClassZipPortal(data);
      case /* 0x62 */ COMMAND_CLASS_DOOR_LOCK:
        return handleCommandClassDoorLock(data);
      case /* 0x63 */ COMMAND_CLASS_USER_CODE:
        return handleCommandClassUserCode(data);
      case /* 0x64 */ COMMAND_CLASS_HUMIDITY_CONTROL_SETPOINT:
        return handleCommandClassHumidityControlSetpoint(data);
      case /* 0x66 */ COMMAND_CLASS_BARRIER_OPERATOR:
        return handleCommandClassBarrierOperator(data);
      case /* 0x67 */ NETWORK_MANAGEMENT_INSTALLATION_MAINTENANCE:
        return handleNetworkManagementInstallationMaintenance(data);
      case /* 0x68 */ COMMAND_CLASS_ZIP_NAMING:
        return handleCommandClassZipNaming(data);
      case /* 0x69 */ COMMAND_CLASS_MAILBOX:
        return handleCommandClassMailbox(data);
      case /* 0x6A */ COMMAND_CLASS_WINDOW_COVERING:
        return handleCommandClassWindowCovering(data);
      case /* 0x6B */ COMMAND_CLASS_IRRIGATION:
        return handleCommandClassIrrigation(data);
      case /* 0x6C */ COMMAND_CLASS_SUPERVISION:
        return handleCommandClassSupervision(data);
      case /* 0x6D */ COMMAND_CLASS_HUMIDITY_CONTROL_MODE:
        return handleCommandClassHumidityControlMode(data);
      case /* 0x6E */ COMMAND_CLASS_HUMIDITY_CONTROL_OPERATING_STATE:
        return handleCommandClassHumidityControlOperatingState(data);
      case /* 0x6F */ COMMAND_CLASS_ENTRY_CONTROL:
        return handleCommandClassEntryControl(data);
      case /* 0x70 */ COMMAND_CLASS_CONFIGURATION:
        return handleCommandClassConfiguration(data);
      case /* 0x71 */ COMMAND_CLASS_NOTIFICATION:
        return handleCommandClassNotification(data);
      case /* 0x72 */ COMMAND_CLASS_MANUFACTURER_SPECIFIC:
        return handleCommandClassManufacturerSpecific(data);
      case /* 0x73 */ COMMAND_CLASS_POWERLEVEL:
        return handleCommandClassPowerlevel(data);
      case /* 0x74 */ COMMAND_CLASS_INCLUSION_CONTROLLER:
        return handleCommandClassInclusionController(data);
      case /* 0x75 */ COMMAND_CLASS_PROTECTION:
        return handleCommandClassProtection(data);
      case /* 0x76 */ COMMAND_CLASS_LOCK:
        return handleCommandClassLock(data);
      case /* 0x77 */ COMMAND_CLASS_NODE_NAMING:
        return handleCommandClassNodeNaming(data);
      case /* 0x78 */ COMMAND_CLASS_NODE_PROVISIONING:
        return handleCommandClassNodeProvisioning(data);
      case /* 0x79 */ COMMAND_CLASS_SOUND_SWITCH:
        return handleCommandClassSoundSwitch(data);
      case /* 0x7A */ COMMAND_CLASS_FIRMWARE_UPDATE_MD:
        return handleCommandClassFirmwareUpdateMd(data);
      case /* 0x7B */ COMMAND_CLASS_GROUPING_NAME:
        return handleCommandClassGroupingName(data);
      case /* 0x7C */ COMMAND_CLASS_REMOTE_ASSOCIATION_ACTIVATE:
        return handleCommandClassRemoteAssociationActivate(data);
      case /* 0x7D */ COMMAND_CLASS_REMOTE_ASSOCIATION:
        return handleCommandClassRemoteAssociation(data);
      case /* 0x80 */ COMMAND_CLASS_BATTERY:
        return handleCommandClassBattery(data);
      case /* 0x81 */ COMMAND_CLASS_CLOCK:
        return handleCommandClassClock(data);
      case /* 0x82 */ COMMAND_CLASS_HAIL:
        return handleCommandClassHail(data);
      case /* 0x84 */ COMMAND_CLASS_WAKE_UP:
        return handleCommandClassWakeUp(data);
      case /* 0x85 */ COMMAND_CLASS_ASSOCIATION:
        return handleCommandClassAssociation(data);
      case /* 0x86 */ COMMAND_CLASS_VERSION:
        return handleCommandClassVersion(data);
      case /* 0x87 */ COMMAND_CLASS_INDICATOR:
        return handleCommandClassIndicator(data);
      case /* 0x88 */ COMMAND_CLASS_PROPRIETARY:
        return handleCommandClassProprietary(data);
      case /* 0x89 */ COMMAND_CLASS_LANGUAGE:
        return handleCommandClassLanguage(data);
      case /* 0x8A */ COMMAND_CLASS_TIME:
        return handleCommandClassTime(data);
      case /* 0x8B */ COMMAND_CLASS_TIME_PARAMETERS:
        return handleCommandClassTimeParameters(data);
      case /* 0x8C */ COMMAND_CLASS_GEOGRAPHIC_LOCATION:
        return handleCommandClassGeographicLocation(data);
      case /* 0x8E */ COMMAND_CLASS_MULTI_CHANNEL_ASSOCIATION:
        return handleCommandClassMultiChannelAssociation(data);
      case /* 0x8F */ COMMAND_CLASS_MULTI_CMD:
        return handleCommandClassMultiCmd(data);
      case /* 0x90 */ COMMAND_CLASS_ENERGY_PRODUCTION:
        return handleCommandClassEnergyProduction(data);
      case /* 0x91 */ COMMAND_CLASS_MANUFACTURER_PROPRIETARY:
        return handleCommandClassManufacturerProprietary(data);
      case /* 0x92 */ COMMAND_CLASS_SCREEN_MD:
        return handleCommandClassScreenMd(data);
      case /* 0x93 */ COMMAND_CLASS_SCREEN_ATTRIBUTES:
        return handleCommandClassScreenAttributes(data);
      case /* 0x94 */ COMMAND_CLASS_SIMPLE_AV_CONTROL:
        return handleCommandClassSimpleAvControl(data);
      case /* 0x98 */ COMMAND_CLASS_SECURITY:
        return handleCommandClassSecurity(data);
      case /* 0x9A */ COMMAND_CLASS_IP_CONFIGURATION:
        return handleCommandClassIpConfiguration(data);
      case /* 0x9B */ COMMAND_CLASS_ASSOCIATION_COMMAND_CONFIGURATION:
        return handleCommandClassAssociationCommandConfiguration(data);
      case /* 0x9C */ COMMAND_CLASS_SENSOR_ALARM:
        return handleCommandClassSensorAlarm(data);
      case /* 0x9D */ COMMAND_CLASS_SILENCE_ALARM:
        return handleCommandClassSilenceAlarm(data);
      case /* 0x9E */ COMMAND_CLASS_SENSOR_CONFIGURATION:
        return handleCommandClassSensorConfiguration(data);
      case /* 0x9F */ COMMAND_CLASS_SECURITY_2:
        return handleCommandClassSecurity2(data);
      case /* 0xEF */ COMMAND_CLASS_MARK:
        return handleCommandClassMark(data);
      case 0xF1:
        switch (data[8]) {
          case 0x00: // COMMAND_CLASS_SECURITY_SCHEME0_MARK
            return handleCommandClassSecurityScheme0Mark(data);
        }
        return handleUnknownCommandClassId(data[7] * 256 + data[8], data);
      default:
        return handleUnknownCommandClassId(data[7], data);
    }
  }

  T handleCommandClassAlarm(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_ALARM, 'COMMAND_CLASS_ALARM', data);
  }

  T handleCommandClassAntitheft(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_ANTITHEFT, 'COMMAND_CLASS_ANTITHEFT', data);
  }

  T handleCommandClassApplicationCapability(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_APPLICATION_CAPABILITY,
        'COMMAND_CLASS_APPLICATION_CAPABILITY', data);
  }

  T handleCommandClassApplicationStatus(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_APPLICATION_STATUS,
        'COMMAND_CLASS_APPLICATION_STATUS', data);
  }

  T handleCommandClassAssociation(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_ASSOCIATION, 'COMMAND_CLASS_ASSOCIATION', data);
  }

  T handleCommandClassAssociationCommandConfiguration(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_ASSOCIATION_COMMAND_CONFIGURATION,
        'COMMAND_CLASS_ASSOCIATION_COMMAND_CONFIGURATION',
        data);
  }

  T handleCommandClassAssociationGrpInfo(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_ASSOCIATION_GRP_INFO,
        'COMMAND_CLASS_ASSOCIATION_GRP_INFO', data);
  }

  T handleCommandClassBarrierOperator(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_BARRIER_OPERATOR, 'COMMAND_CLASS_BARRIER_OPERATOR', data);
  }

  T handleCommandClassBasic(List<int> data) {
    switch (data[8]) {
      case BASIC_REPORT:
        return handleBasicReport(new BasicReport(data));
      default:
        return unhandledCommandClass(
            COMMAND_CLASS_BASIC, 'COMMAND_CLASS_BASIC', data);
    }
  }

  T handleBasicReport(BasicReport report) {
    logger.warning('Unhandled BasicReport from ${report.sourceNode}');
    return null;
  }

  T handleCommandClassBasicTariffInfo(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_BASIC_TARIFF_INFO,
        'COMMAND_CLASS_BASIC_TARIFF_INFO', data);
  }

  T handleCommandClassBasicWindowCovering(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_BASIC_WINDOW_COVERING,
        'COMMAND_CLASS_BASIC_WINDOW_COVERING', data);
  }

  T handleCommandClassBattery(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_BATTERY, 'COMMAND_CLASS_BATTERY', data);
  }

  T handleCommandClassCentralScene(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_CENTRAL_SCENE, 'COMMAND_CLASS_CENTRAL_SCENE', data);
  }

  T handleCommandClassClimateControlSchedule(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_CLIMATE_CONTROL_SCHEDULE,
        'COMMAND_CLASS_CLIMATE_CONTROL_SCHEDULE', data);
  }

  T handleCommandClassClock(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_CLOCK, 'COMMAND_CLASS_CLOCK', data);
  }

  T handleCommandClassConfiguration(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_CONFIGURATION, 'COMMAND_CLASS_CONFIGURATION', data);
  }

  T handleCommandClassControllerReplication(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_CONTROLLER_REPLICATION,
        'COMMAND_CLASS_CONTROLLER_REPLICATION', data);
  }

  T handleCommandClassCrc16Encap(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_CRC_16_ENCAP, 'COMMAND_CLASS_CRC_16_ENCAP', data);
  }

  T handleCommandClassDcpConfig(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_DCP_CONFIG, 'COMMAND_CLASS_DCP_CONFIG', data);
  }

  T handleCommandClassDcpMonitor(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_DCP_MONITOR, 'COMMAND_CLASS_DCP_MONITOR', data);
  }

  T handleCommandClassDeviceResetLocally(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_DEVICE_RESET_LOCALLY,
        'COMMAND_CLASS_DEVICE_RESET_LOCALLY', data);
  }

  T handleCommandClassDoorLock(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_DOOR_LOCK, 'COMMAND_CLASS_DOOR_LOCK', data);
  }

  T handleCommandClassDoorLockLogging(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_DOOR_LOCK_LOGGING,
        'COMMAND_CLASS_DOOR_LOCK_LOGGING', data);
  }

  T handleCommandClassEnergyProduction(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_ENERGY_PRODUCTION,
        'COMMAND_CLASS_ENERGY_PRODUCTION', data);
  }

  T handleCommandClassEntryControl(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_ENTRY_CONTROL, 'COMMAND_CLASS_ENTRY_CONTROL', data);
  }

  T handleCommandClassFirmwareUpdateMd(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_FIRMWARE_UPDATE_MD,
        'COMMAND_CLASS_FIRMWARE_UPDATE_MD', data);
  }

  T handleCommandClassGeographicLocation(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_GEOGRAPHIC_LOCATION,
        'COMMAND_CLASS_GEOGRAPHIC_LOCATION', data);
  }

  T handleCommandClassGroupingName(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_GROUPING_NAME, 'COMMAND_CLASS_GROUPING_NAME', data);
  }

  T handleCommandClassHail(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_HAIL, 'COMMAND_CLASS_HAIL', data);
  }

  T handleCommandClassHrvControl(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_HRV_CONTROL, 'COMMAND_CLASS_HRV_CONTROL', data);
  }

  T handleCommandClassHrvStatus(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_HRV_STATUS, 'COMMAND_CLASS_HRV_STATUS', data);
  }

  T handleCommandClassHumidityControlMode(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_HUMIDITY_CONTROL_MODE,
        'COMMAND_CLASS_HUMIDITY_CONTROL_MODE', data);
  }

  T handleCommandClassHumidityControlOperatingState(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_HUMIDITY_CONTROL_OPERATING_STATE,
        'COMMAND_CLASS_HUMIDITY_CONTROL_OPERATING_STATE', data);
  }

  T handleCommandClassHumidityControlSetpoint(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_HUMIDITY_CONTROL_SETPOINT,
        'COMMAND_CLASS_HUMIDITY_CONTROL_SETPOINT', data);
  }

  T handleCommandClassInclusionController(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_INCLUSION_CONTROLLER,
        'COMMAND_CLASS_INCLUSION_CONTROLLER', data);
  }

  T handleCommandClassIndicator(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_INDICATOR, 'COMMAND_CLASS_INDICATOR', data);
  }

  T handleCommandClassIpAssociation(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_IP_ASSOCIATION, 'COMMAND_CLASS_IP_ASSOCIATION', data);
  }

  T handleCommandClassIpConfiguration(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_IP_CONFIGURATION, 'COMMAND_CLASS_IP_CONFIGURATION', data);
  }

  T handleCommandClassIrrigation(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_IRRIGATION, 'COMMAND_CLASS_IRRIGATION', data);
  }

  T handleCommandClassLanguage(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_LANGUAGE, 'COMMAND_CLASS_LANGUAGE', data);
  }

  T handleCommandClassLock(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_LOCK, 'COMMAND_CLASS_LOCK', data);
  }

  T handleCommandClassMailbox(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_MAILBOX, 'COMMAND_CLASS_MAILBOX', data);
  }

  T handleCommandClassManufacturerProprietary(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_MANUFACTURER_PROPRIETARY,
        'COMMAND_CLASS_MANUFACTURER_PROPRIETARY', data);
  }

  T handleCommandClassManufacturerSpecific(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_MANUFACTURER_SPECIFIC,
        'COMMAND_CLASS_MANUFACTURER_SPECIFIC', data);
  }

  T handleCommandClassMark(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_MARK, 'COMMAND_CLASS_MARK', data);
  }

  T handleCommandClassMeter(List<int> data) {
    switch (data[8]) {
      case METER_REPORT:
        return handleMeterReport(new MeterReport(data));
      default:
        return unhandledCommandClass(
            COMMAND_CLASS_METER, 'COMMAND_CLASS_METER', data);
    }
  }

  T handleMeterReport(MeterReport report) {
    logger.warning('Unhandled MeterReport from ${report.sourceNode}');
    return null;
  }

  T handleCommandClassMeterPulse(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_METER_PULSE, 'COMMAND_CLASS_METER_PULSE', data);
  }

  T handleCommandClassMeterTblConfig(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_METER_TBL_CONFIG, 'COMMAND_CLASS_METER_TBL_CONFIG', data);
  }

  T handleCommandClassMeterTblMonitor(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_METER_TBL_MONITOR,
        'COMMAND_CLASS_METER_TBL_MONITOR', data);
  }

  T handleCommandClassMeterTblPush(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_METER_TBL_PUSH, 'COMMAND_CLASS_METER_TBL_PUSH', data);
  }

  T handleCommandClassMtpWindowCovering(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_MTP_WINDOW_COVERING,
        'COMMAND_CLASS_MTP_WINDOW_COVERING', data);
  }

  T handleCommandClassMultiChannel(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_MULTI_CHANNEL, 'COMMAND_CLASS_MULTI_CHANNEL', data);
  }

  T handleCommandClassMultiChannelAssociation(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_MULTI_CHANNEL_ASSOCIATION,
        'COMMAND_CLASS_MULTI_CHANNEL_ASSOCIATION', data);
  }

  T handleCommandClassMultiCmd(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_MULTI_CMD, 'COMMAND_CLASS_MULTI_CMD', data);
  }

  T handleCommandClassNetworkManagementBasic(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_NETWORK_MANAGEMENT_BASIC,
        'COMMAND_CLASS_NETWORK_MANAGEMENT_BASIC', data);
  }

  T handleCommandClassNetworkManagementInclusion(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_NETWORK_MANAGEMENT_INCLUSION,
        'COMMAND_CLASS_NETWORK_MANAGEMENT_INCLUSION', data);
  }

  T handleCommandClassNetworkManagementPrimary(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_NETWORK_MANAGEMENT_PRIMARY,
        'COMMAND_CLASS_NETWORK_MANAGEMENT_PRIMARY', data);
  }

  T handleCommandClassNetworkManagementProxy(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_NETWORK_MANAGEMENT_PROXY,
        'COMMAND_CLASS_NETWORK_MANAGEMENT_PROXY', data);
  }

  T handleCommandClassNodeNaming(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_NODE_NAMING, 'COMMAND_CLASS_NODE_NAMING', data);
  }

  T handleCommandClassNodeProvisioning(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_NODE_PROVISIONING,
        'COMMAND_CLASS_NODE_PROVISIONING', data);
  }

  T handleCommandClassNotification(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_NOTIFICATION, 'COMMAND_CLASS_NOTIFICATION', data);
  }

  T handleCommandClassNoOperation(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_NO_OPERATION, 'COMMAND_CLASS_NO_OPERATION', data);
  }

  T handleCommandClassPowerlevel(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_POWERLEVEL, 'COMMAND_CLASS_POWERLEVEL', data);
  }

  T handleCommandClassPrepayment(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_PREPAYMENT, 'COMMAND_CLASS_PREPAYMENT', data);
  }

  T handleCommandClassPrepaymentEncapsulation(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_PREPAYMENT_ENCAPSULATION,
        'COMMAND_CLASS_PREPAYMENT_ENCAPSULATION', data);
  }

  T handleCommandClassProprietary(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_PROPRIETARY, 'COMMAND_CLASS_PROPRIETARY', data);
  }

  T handleCommandClassProtection(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_PROTECTION, 'COMMAND_CLASS_PROTECTION', data);
  }

  T handleCommandClassRateTblConfig(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_RATE_TBL_CONFIG, 'COMMAND_CLASS_RATE_TBL_CONFIG', data);
  }

  T handleCommandClassRateTblMonitor(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_RATE_TBL_MONITOR, 'COMMAND_CLASS_RATE_TBL_MONITOR', data);
  }

  T handleCommandClassRemoteAssociation(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_REMOTE_ASSOCIATION,
        'COMMAND_CLASS_REMOTE_ASSOCIATION', data);
  }

  T handleCommandClassRemoteAssociationActivate(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_REMOTE_ASSOCIATION_ACTIVATE,
        'COMMAND_CLASS_REMOTE_ASSOCIATION_ACTIVATE', data);
  }

  T handleCommandClassSceneActivation(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_SCENE_ACTIVATION, 'COMMAND_CLASS_SCENE_ACTIVATION', data);
  }

  T handleCommandClassSceneActuatorConf(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_SCENE_ACTUATOR_CONF,
        'COMMAND_CLASS_SCENE_ACTUATOR_CONF', data);
  }

  T handleCommandClassSceneControllerConf(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_SCENE_CONTROLLER_CONF,
        'COMMAND_CLASS_SCENE_CONTROLLER_CONF', data);
  }

  T handleCommandClassSchedule(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_SCHEDULE, 'COMMAND_CLASS_SCHEDULE', data);
  }

  T handleCommandClassScheduleEntryLock(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_SCHEDULE_ENTRY_LOCK,
        'COMMAND_CLASS_SCHEDULE_ENTRY_LOCK', data);
  }

  T handleCommandClassScreenAttributes(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_SCREEN_ATTRIBUTES,
        'COMMAND_CLASS_SCREEN_ATTRIBUTES', data);
  }

  T handleCommandClassScreenMd(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_SCREEN_MD, 'COMMAND_CLASS_SCREEN_MD', data);
  }

  T handleCommandClassSecurity(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_SECURITY, 'COMMAND_CLASS_SECURITY', data);
  }

  T handleCommandClassSecurity2(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_SECURITY_2, 'COMMAND_CLASS_SECURITY_2', data);
  }

  T handleCommandClassSecurityScheme0Mark(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_SECURITY_SCHEME0_MARK,
        'COMMAND_CLASS_SECURITY_SCHEME0_MARK', data);
  }

  T handleCommandClassSensorAlarm(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_SENSOR_ALARM, 'COMMAND_CLASS_SENSOR_ALARM', data);
  }

  T handleCommandClassSensorBinary(List<int> data) {
    switch (data[8]) {
      case SENSOR_BINARY_REPORT:
        return handleSensorBinaryReport(new SensorBinaryReport(data));
      default:
        return unhandledCommandClass(
            COMMAND_CLASS_SENSOR_BINARY, 'COMMAND_CLASS_SENSOR_BINARY', data);
    }
  }

  T handleSensorBinaryReport(SensorBinaryReport report) {
    logger.warning('Unhandled SensorBinaryReport from ${report.sourceNode}');
    return null;
  }

  T handleCommandClassSensorConfiguration(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_SENSOR_CONFIGURATION,
        'COMMAND_CLASS_SENSOR_CONFIGURATION', data);
  }

  T handleCommandClassSensorMultilevel(List<int> data) {
    switch (data[8]) {
      case SENSOR_MULTILEVEL_REPORT:
        return handleSensorMultilevelReport(new SensorMultilevelReport(data));
      default:
        return unhandledCommandClass(COMMAND_CLASS_SENSOR_MULTILEVEL,
            'COMMAND_CLASS_SENSOR_MULTILEVEL', data);
    }
  }

  T handleSensorMultilevelReport(SensorMultilevelReport report) {
    logger
        .warning('Unhandled SensorMultilevelReport from ${report.sourceNode}');
    return null;
  }

  T handleCommandClassSilenceAlarm(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_SILENCE_ALARM, 'COMMAND_CLASS_SILENCE_ALARM', data);
  }

  T handleCommandClassSimpleAvControl(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_SIMPLE_AV_CONTROL,
        'COMMAND_CLASS_SIMPLE_AV_CONTROL', data);
  }

  T handleCommandClassSoundSwitch(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_SOUND_SWITCH, 'COMMAND_CLASS_SOUND_SWITCH', data);
  }

  T handleCommandClassSupervision(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_SUPERVISION, 'COMMAND_CLASS_SUPERVISION', data);
  }

  T handleCommandClassSwitchAll(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_SWITCH_ALL, 'COMMAND_CLASS_SWITCH_ALL', data);
  }

  T handleCommandClassSwitchBinary(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_SWITCH_BINARY, 'COMMAND_CLASS_SWITCH_BINARY', data);
  }

  T handleCommandClassSwitchColor(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_SWITCH_COLOR, 'COMMAND_CLASS_SWITCH_COLOR', data);
  }

  T handleCommandClassSwitchMultilevel(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_SWITCH_MULTILEVEL,
        'COMMAND_CLASS_SWITCH_MULTILEVEL', data);
  }

  T handleCommandClassSwitchToggleBinary(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_SWITCH_TOGGLE_BINARY,
        'COMMAND_CLASS_SWITCH_TOGGLE_BINARY', data);
  }

  T handleCommandClassSwitchToggleMultilevel(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_SWITCH_TOGGLE_MULTILEVEL,
        'COMMAND_CLASS_SWITCH_TOGGLE_MULTILEVEL', data);
  }

  T handleCommandClassTariffConfig(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_TARIFF_CONFIG, 'COMMAND_CLASS_TARIFF_CONFIG', data);
  }

  T handleCommandClassTariffTblMonitor(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_TARIFF_TBL_MONITOR,
        'COMMAND_CLASS_TARIFF_TBL_MONITOR', data);
  }

  T handleCommandClassThermostatFanMode(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_THERMOSTAT_FAN_MODE,
        'COMMAND_CLASS_THERMOSTAT_FAN_MODE', data);
  }

  T handleCommandClassThermostatFanState(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_THERMOSTAT_FAN_STATE,
        'COMMAND_CLASS_THERMOSTAT_FAN_STATE', data);
  }

  T handleCommandClassThermostatMode(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_THERMOSTAT_MODE, 'COMMAND_CLASS_THERMOSTAT_MODE', data);
  }

  T handleCommandClassThermostatOperatingState(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_THERMOSTAT_OPERATING_STATE,
        'COMMAND_CLASS_THERMOSTAT_OPERATING_STATE', data);
  }

  T handleCommandClassThermostatSetback(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_THERMOSTAT_SETBACK,
        'COMMAND_CLASS_THERMOSTAT_SETBACK', data);
  }

  T handleCommandClassThermostatSetpoint(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_THERMOSTAT_SETPOINT,
        'COMMAND_CLASS_THERMOSTAT_SETPOINT', data);
  }

  T handleCommandClassTime(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_TIME, 'COMMAND_CLASS_TIME', data);
  }

  T handleCommandClassTimeParameters(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_TIME_PARAMETERS, 'COMMAND_CLASS_TIME_PARAMETERS', data);
  }

  T handleCommandClassTransportService(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_TRANSPORT_SERVICE,
        'COMMAND_CLASS_TRANSPORT_SERVICE', data);
  }

  T handleCommandClassUserCode(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_USER_CODE, 'COMMAND_CLASS_USER_CODE', data);
  }

  T handleCommandClassVersion(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_VERSION, 'COMMAND_CLASS_VERSION', data);
  }

  T handleCommandClassWakeUp(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_WAKE_UP, 'COMMAND_CLASS_WAKE_UP', data);
  }

  T handleCommandClassWindowCovering(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_WINDOW_COVERING, 'COMMAND_CLASS_WINDOW_COVERING', data);
  }

  T handleCommandClassZip(List<int> data) {
    return unhandledCommandClass(COMMAND_CLASS_ZIP, 'COMMAND_CLASS_ZIP', data);
  }

  T handleCommandClassZip6lowpan(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_ZIP_6LOWPAN, 'COMMAND_CLASS_ZIP_6LOWPAN', data);
  }

  T handleCommandClassZipGateway(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_ZIP_GATEWAY, 'COMMAND_CLASS_ZIP_GATEWAY', data);
  }

  T handleCommandClassZipNaming(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_ZIP_NAMING, 'COMMAND_CLASS_ZIP_NAMING', data);
  }

  T handleCommandClassZipNd(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_ZIP_ND, 'COMMAND_CLASS_ZIP_ND', data);
  }

  T handleCommandClassZipPortal(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_ZIP_PORTAL, 'COMMAND_CLASS_ZIP_PORTAL', data);
  }

  T handleCommandClassZwaveplusInfo(List<int> data) {
    return unhandledCommandClass(
        COMMAND_CLASS_ZWAVEPLUS_INFO, 'COMMAND_CLASS_ZWAVEPLUS_INFO', data);
  }

  T handleNetworkManagementInstallationMaintenance(List<int> data) {
    return unhandledCommandClass(NETWORK_MANAGEMENT_INSTALLATION_MAINTENANCE,
        'NETWORK_MANAGEMENT_INSTALLATION_MAINTENANCE', data);
  }

  T handleUnknownCommandClassId(int cmdId, List<int> data) {
    final nodeId = data[5];
    logger.warning('Unknown command class id: $nodeId $cmdId $data');
    return null;
  }

  T unhandledCommandClass(int cmdId, String cmdName, List<int> data) {
    final nodeId = data[5];
    logger.warning('Unhandled command: $nodeId $cmdId $cmdName $data');
    return null;
  }
}
