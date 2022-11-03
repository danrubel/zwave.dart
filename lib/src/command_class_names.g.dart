// Command class names

const COMMAND_CLASS_NAMES = <int, String>{
  0x00: 'COMMAND_CLASS_NO_OPERATION',
  0x20: 'COMMAND_CLASS_BASIC',
  0x21: 'COMMAND_CLASS_CONTROLLER_REPLICATION',
  0x22: 'COMMAND_CLASS_APPLICATION_STATUS',
  0x23: 'COMMAND_CLASS_ZIP',
  0x25: 'COMMAND_CLASS_SWITCH_BINARY',
  0x26: 'COMMAND_CLASS_SWITCH_MULTILEVEL',
  0x27: 'COMMAND_CLASS_SWITCH_ALL',
  0x28: 'COMMAND_CLASS_SWITCH_TOGGLE_BINARY',
  0x29: 'COMMAND_CLASS_SWITCH_TOGGLE_MULTILEVEL',
  0x2B: 'COMMAND_CLASS_SCENE_ACTIVATION',
  0x2C: 'COMMAND_CLASS_SCENE_ACTUATOR_CONF',
  0x2D: 'COMMAND_CLASS_SCENE_CONTROLLER_CONF',
  0x30: 'COMMAND_CLASS_SENSOR_BINARY',
  0x31: 'COMMAND_CLASS_SENSOR_MULTILEVEL',
  0x32: 'COMMAND_CLASS_METER',
  0x33: 'COMMAND_CLASS_SWITCH_COLOR',
  0x34: 'COMMAND_CLASS_NETWORK_MANAGEMENT_INCLUSION',
  0x35: 'COMMAND_CLASS_METER_PULSE',
  0x36: 'COMMAND_CLASS_BASIC_TARIFF_INFO',
  0x37: 'COMMAND_CLASS_HRV_STATUS',
  0x39: 'COMMAND_CLASS_HRV_CONTROL',
  0x3A: 'COMMAND_CLASS_DCP_CONFIG',
  0x3B: 'COMMAND_CLASS_DCP_MONITOR',
  0x3C: 'COMMAND_CLASS_METER_TBL_CONFIG',
  0x3D: 'COMMAND_CLASS_METER_TBL_MONITOR',
  0x3E: 'COMMAND_CLASS_METER_TBL_PUSH',
  0x3F: 'COMMAND_CLASS_PREPAYMENT',
  0x40: 'COMMAND_CLASS_THERMOSTAT_MODE',
  0x41: 'COMMAND_CLASS_PREPAYMENT_ENCAPSULATION',
  0x42: 'COMMAND_CLASS_THERMOSTAT_OPERATING_STATE',
  0x43: 'COMMAND_CLASS_THERMOSTAT_SETPOINT',
  0x44: 'COMMAND_CLASS_THERMOSTAT_FAN_MODE',
  0x45: 'COMMAND_CLASS_THERMOSTAT_FAN_STATE',
  0x46: 'COMMAND_CLASS_CLIMATE_CONTROL_SCHEDULE',
  0x47: 'COMMAND_CLASS_THERMOSTAT_SETBACK',
  0x48: 'COMMAND_CLASS_RATE_TBL_CONFIG',
  0x49: 'COMMAND_CLASS_RATE_TBL_MONITOR',
  0x4A: 'COMMAND_CLASS_TARIFF_CONFIG',
  0x4B: 'COMMAND_CLASS_TARIFF_TBL_MONITOR',
  0x4C: 'COMMAND_CLASS_DOOR_LOCK_LOGGING',
  0x4D: 'COMMAND_CLASS_NETWORK_MANAGEMENT_BASIC',
  0x4E: 'COMMAND_CLASS_SCHEDULE_ENTRY_LOCK',
  0x4F: 'COMMAND_CLASS_ZIP_6LOWPAN',
  0x50: 'COMMAND_CLASS_BASIC_WINDOW_COVERING',
  0x51: 'COMMAND_CLASS_MTP_WINDOW_COVERING',
  0x52: 'COMMAND_CLASS_NETWORK_MANAGEMENT_PROXY',
  0x53: 'COMMAND_CLASS_SCHEDULE',
  0x54: 'COMMAND_CLASS_NETWORK_MANAGEMENT_PRIMARY',
  0x55: 'COMMAND_CLASS_TRANSPORT_SERVICE',
  0x56: 'COMMAND_CLASS_CRC_16_ENCAP',
  0x57: 'COMMAND_CLASS_APPLICATION_CAPABILITY',
  0x58: 'COMMAND_CLASS_ZIP_ND',
  0x59: 'COMMAND_CLASS_ASSOCIATION_GRP_INFO',
  0x5A: 'COMMAND_CLASS_DEVICE_RESET_LOCALLY',
  0x5B: 'COMMAND_CLASS_CENTRAL_SCENE',
  0x5C: 'COMMAND_CLASS_IP_ASSOCIATION',
  0x5D: 'COMMAND_CLASS_ANTITHEFT',
  0x5E: 'COMMAND_CLASS_ZWAVEPLUS_INFO',
  0x5F: 'COMMAND_CLASS_ZIP_GATEWAY',
  0x60: 'COMMAND_CLASS_MULTI_CHANNEL',
  0x61: 'COMMAND_CLASS_ZIP_PORTAL',
  0x62: 'COMMAND_CLASS_DOOR_LOCK',
  0x63: 'COMMAND_CLASS_USER_CODE',
  0x64: 'COMMAND_CLASS_HUMIDITY_CONTROL_SETPOINT',
  0x66: 'COMMAND_CLASS_BARRIER_OPERATOR',
  0x67: 'NETWORK_MANAGEMENT_INSTALLATION_MAINTENANCE',
  0x68: 'COMMAND_CLASS_ZIP_NAMING',
  0x69: 'COMMAND_CLASS_MAILBOX',
  0x6A: 'COMMAND_CLASS_WINDOW_COVERING',
  0x6B: 'COMMAND_CLASS_IRRIGATION',
  0x6C: 'COMMAND_CLASS_SUPERVISION',
  0x6D: 'COMMAND_CLASS_HUMIDITY_CONTROL_MODE',
  0x6E: 'COMMAND_CLASS_HUMIDITY_CONTROL_OPERATING_STATE',
  0x6F: 'COMMAND_CLASS_ENTRY_CONTROL',
  0x70: 'COMMAND_CLASS_CONFIGURATION',
  0x71: 'COMMAND_CLASS_NOTIFICATION',
  0x72: 'COMMAND_CLASS_MANUFACTURER_SPECIFIC',
  0x73: 'COMMAND_CLASS_POWERLEVEL',
  0x74: 'COMMAND_CLASS_INCLUSION_CONTROLLER',
  0x75: 'COMMAND_CLASS_PROTECTION',
  0x76: 'COMMAND_CLASS_LOCK',
  0x77: 'COMMAND_CLASS_NODE_NAMING',
  0x78: 'COMMAND_CLASS_NODE_PROVISIONING',
  0x79: 'COMMAND_CLASS_SOUND_SWITCH',
  0x7A: 'COMMAND_CLASS_FIRMWARE_UPDATE_MD',
  0x7B: 'COMMAND_CLASS_GROUPING_NAME',
  0x7C: 'COMMAND_CLASS_REMOTE_ASSOCIATION_ACTIVATE',
  0x7D: 'COMMAND_CLASS_REMOTE_ASSOCIATION',
  0x7E: 'COMMAND_CLASS_ANTITHEFT_UNLOCK',
  0x80: 'COMMAND_CLASS_BATTERY',
  0x81: 'COMMAND_CLASS_CLOCK',
  0x82: 'COMMAND_CLASS_HAIL',
  0x84: 'COMMAND_CLASS_WAKE_UP',
  0x85: 'COMMAND_CLASS_ASSOCIATION',
  0x86: 'COMMAND_CLASS_VERSION',
  0x87: 'COMMAND_CLASS_INDICATOR',
  0x88: 'COMMAND_CLASS_PROPRIETARY',
  0x89: 'COMMAND_CLASS_LANGUAGE',
  0x8A: 'COMMAND_CLASS_TIME',
  0x8B: 'COMMAND_CLASS_TIME_PARAMETERS',
  0x8C: 'COMMAND_CLASS_GEOGRAPHIC_LOCATION',
  0x8E: 'COMMAND_CLASS_MULTI_CHANNEL_ASSOCIATION',
  0x8F: 'COMMAND_CLASS_MULTI_CMD',
  0x90: 'COMMAND_CLASS_ENERGY_PRODUCTION',
  0x91: 'COMMAND_CLASS_MANUFACTURER_PROPRIETARY',
  0x92: 'COMMAND_CLASS_SCREEN_MD',
  0x93: 'COMMAND_CLASS_SCREEN_ATTRIBUTES',
  0x94: 'COMMAND_CLASS_SIMPLE_AV_CONTROL',
  0x98: 'COMMAND_CLASS_SECURITY',
  0x9A: 'COMMAND_CLASS_IP_CONFIGURATION',
  0x9B: 'COMMAND_CLASS_ASSOCIATION_COMMAND_CONFIGURATION',
  0x9C: 'COMMAND_CLASS_SENSOR_ALARM',
  0x9D: 'COMMAND_CLASS_SILENCE_ALARM',
  0x9E: 'COMMAND_CLASS_SENSOR_CONFIGURATION',
  0x9F: 'COMMAND_CLASS_SECURITY_2',
  0xA0: 'COMMAND_CLASS_IR_REPEATER',
  0xA1: 'COMMAND_CLASS_AUTHENTICATION',
  0xA2: 'COMMAND_CLASS_AUTHENTICATION_MEDIA_WRITE',
  0xA3: 'COMMAND_CLASS_GENERIC_SCHEDULE',
  0xEF: 'COMMAND_CLASS_MARK',
  0xF100: 'COMMAND_CLASS_SECURITY_SCHEME0_MARK',
};

const COMMAND_NAMES = <int, Map<int, String>>{
  0x5D /* COMMAND_CLASS_ANTITHEFT */ : {
    0x01: 'ANTITHEFT_SET',
    0x02: 'ANTITHEFT_GET',
    0x03: 'ANTITHEFT_REPORT',
  },
  0x7E /* COMMAND_CLASS_ANTITHEFT_UNLOCK */ : {
    0x01: 'COMMAND_ANTITHEFT_UNLOCK_STATE_GET',
    0x02: 'COMMAND_ANTITHEFT_UNLOCK_STATE_REPORT',
    0x03: 'COMMAND_ANTITHEFT_UNLOCK_SET',
  },
  0x57 /* COMMAND_CLASS_APPLICATION_CAPABILITY */ : {
    0x01: 'COMMAND_COMMAND_CLASS_NOT_SUPPORTED',
  },
  0x22 /* COMMAND_CLASS_APPLICATION_STATUS */ : {
    0x01: 'APPLICATION_BUSY',
    0x02: 'APPLICATION_REJECTED_REQUEST',
  },
  0x85 /* COMMAND_CLASS_ASSOCIATION */ : {
    0x01: 'ASSOCIATION_SET',
    0x02: 'ASSOCIATION_GET',
    0x03: 'ASSOCIATION_REPORT',
    0x04: 'ASSOCIATION_REMOVE',
    0x05: 'ASSOCIATION_GROUPINGS_GET',
    0x06: 'ASSOCIATION_GROUPINGS_REPORT',
    0x0B: 'ASSOCIATION_SPECIFIC_GROUP_GET',
    0x0C: 'ASSOCIATION_SPECIFIC_GROUP_REPORT',
  },
  0x9B /* COMMAND_CLASS_ASSOCIATION_COMMAND_CONFIGURATION */ : {
    0x01: 'COMMAND_RECORDS_SUPPORTED_GET',
    0x02: 'COMMAND_RECORDS_SUPPORTED_REPORT',
    0x03: 'COMMAND_CONFIGURATION_SET',
    0x04: 'COMMAND_CONFIGURATION_GET',
    0x05: 'COMMAND_CONFIGURATION_REPORT',
  },
  0x59 /* COMMAND_CLASS_ASSOCIATION_GRP_INFO */ : {
    0x01: 'ASSOCIATION_GROUP_NAME_GET',
    0x02: 'ASSOCIATION_GROUP_NAME_REPORT',
    0x03: 'ASSOCIATION_GROUP_INFO_GET',
    0x04: 'ASSOCIATION_GROUP_INFO_REPORT',
    0x05: 'ASSOCIATION_GROUP_COMMAND_LIST_GET',
    0x06: 'ASSOCIATION_GROUP_COMMAND_LIST_REPORT',
  },
  0xA1 /* COMMAND_CLASS_AUTHENTICATION */ : {
    0x01: 'AUTHENTICATION_CAPABILITIES_GET',
    0x02: 'AUTHENTICATION_CAPABILITIES_REPORT',
    0x03: 'AUTHENTICATION_DATA_SET',
    0x04: 'AUTHENTICATION_DATA_GET',
    0x05: 'AUTHENTICATION_DATA_REPORT',
    0x06: 'AUTHENTICATION_TECHNOLOGIES_COMBINATION_SET',
    0x07: 'AUTHENTICATION_TECHNOLOGIES_COMBINATION_GET',
    0x08: 'AUTHENTICATION_TECHNOLOGIES_COMBINATION_REPORT',
    0x09: 'AUTHENTICATION_CHECKSUM_GET',
    0x0F: 'AUTHENTICATION_DATA_CHECKSUM_REPORT',
  },
  0xA2 /* COMMAND_CLASS_AUTHENTICATION_MEDIA_WRITE */ : {
    0x01: 'AUTHENTICATION_MEDIA_CAPABILITIES_GET',
    0x02: 'AUTHENTICATION_MEDIA_CAPABILITIES_REPORT',
    0x03: 'AUTHENTICATION_MEDIA_WRITE_START',
    0x04: 'AUTHENTICATION_MEDIA_WRITE_STOP',
    0x05: 'AUTHENTICATION_MEDIA_WRITE_STATUS',
  },
  0x66 /* COMMAND_CLASS_BARRIER_OPERATOR */ : {
    0x01: 'BARRIER_OPERATOR_SET',
    0x02: 'BARRIER_OPERATOR_GET',
    0x03: 'BARRIER_OPERATOR_REPORT',
    0x04: 'BARRIER_OPERATOR_SIGNAL_SUPPORTED_GET',
    0x05: 'BARRIER_OPERATOR_SIGNAL_SUPPORTED_REPORT',
    0x06: 'BARRIER_OPERATOR_SIGNAL_SET',
    0x07: 'BARRIER_OPERATOR_SIGNAL_GET',
    0x08: 'BARRIER_OPERATOR_SIGNAL_REPORT',
  },
  0x20 /* COMMAND_CLASS_BASIC */ : {
    0x01: 'BASIC_SET',
    0x02: 'BASIC_GET',
    0x03: 'BASIC_REPORT',
  },
  0x36 /* COMMAND_CLASS_BASIC_TARIFF_INFO */ : {
    0x01: 'BASIC_TARIFF_INFO_GET',
    0x02: 'BASIC_TARIFF_INFO_REPORT',
  },
  0x50 /* COMMAND_CLASS_BASIC_WINDOW_COVERING */ : {
    0x01: 'BASIC_WINDOW_COVERING_START_LEVEL_CHANGE',
    0x02: 'BASIC_WINDOW_COVERING_STOP_LEVEL_CHANGE',
  },
  0x80 /* COMMAND_CLASS_BATTERY */ : {
    0x02: 'BATTERY_GET',
    0x03: 'BATTERY_REPORT',
    0x04: 'BATTERY_HEALTH_GET',
    0x05: 'BATTERY_HEALTH_REPORT',
  },
  0x5B /* COMMAND_CLASS_CENTRAL_SCENE */ : {
    0x01: 'CENTRAL_SCENE_SUPPORTED_GET',
    0x02: 'CENTRAL_SCENE_SUPPORTED_REPORT',
    0x03: 'CENTRAL_SCENE_NOTIFICATION',
    0x04: 'CENTRAL_SCENE_CONFIGURATION_SET',
    0x05: 'CENTRAL_SCENE_CONFIGURATION_GET',
    0x06: 'CENTRAL_SCENE_CONFIGURATION_REPORT',
  },
  0x46 /* COMMAND_CLASS_CLIMATE_CONTROL_SCHEDULE */ : {
    0x01: 'CLIMATE_CONTROL_SCHEDULE_SET',
    0x02: 'CLIMATE_CONTROL_SCHEDULE_GET',
    0x03: 'CLIMATE_CONTROL_SCHEDULE_REPORT',
    0x04: 'CLIMATE_CONTROL_SCHEDULE_CHANGED_GET',
    0x05: 'CLIMATE_CONTROL_SCHEDULE_CHANGED_REPORT',
    0x06: 'CLIMATE_CONTROL_SCHEDULE_OVERRIDE_SET',
    0x07: 'CLIMATE_CONTROL_SCHEDULE_OVERRIDE_GET',
    0x08: 'CLIMATE_CONTROL_SCHEDULE_OVERRIDE_REPORT',
  },
  0x81 /* COMMAND_CLASS_CLOCK */ : {
    0x04: 'CLOCK_SET',
    0x05: 'CLOCK_GET',
    0x06: 'CLOCK_REPORT',
  },
  0x70 /* COMMAND_CLASS_CONFIGURATION */ : {
    0x04: 'CONFIGURATION_SET',
    0x05: 'CONFIGURATION_GET',
    0x06: 'CONFIGURATION_REPORT',
    0x07: 'CONFIGURATION_BULK_SET',
    0x08: 'CONFIGURATION_BULK_GET',
    0x09: 'CONFIGURATION_BULK_REPORT',
    0x0A: 'CONFIGURATION_NAME_GET',
    0x0B: 'CONFIGURATION_NAME_REPORT',
    0x0C: 'CONFIGURATION_INFO_GET',
    0x0D: 'CONFIGURATION_INFO_REPORT',
    0x0E: 'CONFIGURATION_PROPERTIES_GET',
    0x0F: 'CONFIGURATION_PROPERTIES_REPORT',
    0x01: 'CONFIGURATION_DEFAULT_RESET',
  },
  0x21 /* COMMAND_CLASS_CONTROLLER_REPLICATION */ : {
    0x31: 'CTRL_REPLICATION_TRANSFER_GROUP',
    0x32: 'CTRL_REPLICATION_TRANSFER_GROUP_NAME',
    0x33: 'CTRL_REPLICATION_TRANSFER_SCENE',
    0x34: 'CTRL_REPLICATION_TRANSFER_SCENE_NAME',
  },
  0x56 /* COMMAND_CLASS_CRC_16_ENCAP */ : {
    0x01: 'CRC_16_ENCAP',
  },
  0x3A /* COMMAND_CLASS_DCP_CONFIG */ : {
    0x01: 'DCP_LIST_SUPPORTED_GET',
    0x02: 'DCP_LIST_SUPPORTED_REPORT',
    0x03: 'DCP_LIST_SET',
    0x04: 'DCP_LIST_REMOVE',
  },
  0x3B /* COMMAND_CLASS_DCP_MONITOR */ : {
    0x01: 'DCP_LIST_GET',
    0x02: 'DCP_LIST_REPORT',
    0x03: 'DCP_EVENT_STATUS_GET',
    0x04: 'DCP_EVENT_STATUS_REPORT',
  },
  0x5A /* COMMAND_CLASS_DEVICE_RESET_LOCALLY */ : {
    0x01: 'DEVICE_RESET_LOCALLY_NOTIFICATION',
  },
  0x62 /* COMMAND_CLASS_DOOR_LOCK */ : {
    0x01: 'DOOR_LOCK_OPERATION_SET',
    0x02: 'DOOR_LOCK_OPERATION_GET',
    0x03: 'DOOR_LOCK_OPERATION_REPORT',
    0x04: 'DOOR_LOCK_CONFIGURATION_SET',
    0x05: 'DOOR_LOCK_CONFIGURATION_GET',
    0x06: 'DOOR_LOCK_CONFIGURATION_REPORT',
    0x07: 'DOOR_LOCK_CAPABILITIES_GET',
    0x08: 'DOOR_LOCK_CAPABILITIES_REPORT',
  },
  0x4C /* COMMAND_CLASS_DOOR_LOCK_LOGGING */ : {
    0x01: 'DOOR_LOCK_LOGGING_RECORDS_SUPPORTED_GET',
    0x02: 'DOOR_LOCK_LOGGING_RECORDS_SUPPORTED_REPORT',
    0x03: 'RECORD_GET',
    0x04: 'RECORD_REPORT',
  },
  0x90 /* COMMAND_CLASS_ENERGY_PRODUCTION */ : {
    0x02: 'ENERGY_PRODUCTION_GET',
    0x03: 'ENERGY_PRODUCTION_REPORT',
  },
  0x6F /* COMMAND_CLASS_ENTRY_CONTROL */ : {
    0x01: 'ENTRY_CONTROL_NOTIFICATION',
    0x02: 'ENTRY_CONTROL_KEY_SUPPORTED_GET',
    0x03: 'ENTRY_CONTROL_KEY_SUPPORTED_REPORT',
    0x04: 'ENTRY_CONTROL_EVENT_SUPPORTED_GET',
    0x05: 'ENTRY_CONTROL_EVENT_SUPPORTED_REPORT',
    0x06: 'ENTRY_CONTROL_CONFIGURATION_SET',
    0x07: 'ENTRY_CONTROL_CONFIGURATION_GET',
    0x08: 'ENTRY_CONTROL_CONFIGURATION_REPORT',
  },
  0x7A /* COMMAND_CLASS_FIRMWARE_UPDATE_MD */ : {
    0x01: 'FIRMWARE_MD_GET',
    0x02: 'FIRMWARE_MD_REPORT',
    0x03: 'FIRMWARE_UPDATE_MD_REQUEST_GET',
    0x04: 'FIRMWARE_UPDATE_MD_REQUEST_REPORT',
    0x05: 'FIRMWARE_UPDATE_MD_GET',
    0x06: 'FIRMWARE_UPDATE_MD_REPORT',
    0x07: 'FIRMWARE_UPDATE_MD_STATUS_REPORT',
    0x08: 'FIRMWARE_UPDATE_ACTIVATION_SET',
    0x09: 'FIRMWARE_UPDATE_ACTIVATION_STATUS_REPORT',
    0x0A: 'FIRMWARE_UPDATE_MD_PREPARE_GET',
    0x0B: 'FIRMWARE_UPDATE_MD_PREPARE_REPORT',
  },
  0xA3 /* COMMAND_CLASS_GENERIC_SCHEDULE */ : {
    0x01: 'GENERIC_SCHEDULE_CAPABILITIES_GET',
    0x02: 'GENERIC_SCHEDULE_CAPABILITIES_REPORT',
    0x03: 'GENERIC_SCHEDULE_TIME_RANGE_SET',
    0x04: 'GENERIC_SCHEDULE_TIME_RANGE_GET',
    0x05: 'GENERIC_SCHEDULE_TIME_RANGE_REPORT',
    0x06: 'GENERIC_SCHEDULE_SET',
    0x07: 'GENERIC_SCHEDULE_GET',
    0x08: 'GENERIC_SCHEDULE_REPORT',
  },
  0x8C /* COMMAND_CLASS_GEOGRAPHIC_LOCATION */ : {
    0x01: 'GEOGRAPHIC_LOCATION_SET',
    0x02: 'GEOGRAPHIC_LOCATION_GET',
    0x03: 'GEOGRAPHIC_LOCATION_REPORT',
  },
  0x7B /* COMMAND_CLASS_GROUPING_NAME */ : {
    0x01: 'GROUPING_NAME_SET',
    0x02: 'GROUPING_NAME_GET',
    0x03: 'GROUPING_NAME_REPORT',
  },
  0x82 /* COMMAND_CLASS_HAIL */ : {
    0x01: 'HAIL',
  },
  0x39 /* COMMAND_CLASS_HRV_CONTROL */ : {
    0x01: 'HRV_CONTROL_MODE_SET',
    0x02: 'HRV_CONTROL_MODE_GET',
    0x03: 'HRV_CONTROL_MODE_REPORT',
    0x04: 'HRV_CONTROL_BYPASS_SET',
    0x05: 'HRV_CONTROL_BYPASS_GET',
    0x06: 'HRV_CONTROL_BYPASS_REPORT',
    0x07: 'HRV_CONTROL_VENTILATION_RATE_SET',
    0x08: 'HRV_CONTROL_VENTILATION_RATE_GET',
    0x09: 'HRV_CONTROL_VENTILATION_RATE_REPORT',
    0x0A: 'HRV_CONTROL_MODE_SUPPORTED_GET',
    0x0B: 'HRV_CONTROL_MODE_SUPPORTED_REPORT',
  },
  0x37 /* COMMAND_CLASS_HRV_STATUS */ : {
    0x01: 'HRV_STATUS_GET',
    0x02: 'HRV_STATUS_REPORT',
    0x03: 'HRV_STATUS_SUPPORTED_GET',
    0x04: 'HRV_STATUS_SUPPORTED_REPORT',
  },
  0x6D /* COMMAND_CLASS_HUMIDITY_CONTROL_MODE */ : {
    0x01: 'HUMIDITY_CONTROL_MODE_SET',
    0x02: 'HUMIDITY_CONTROL_MODE_GET',
    0x03: 'HUMIDITY_CONTROL_MODE_REPORT',
    0x04: 'HUMIDITY_CONTROL_MODE_SUPPORTED_GET',
    0x05: 'HUMIDITY_CONTROL_MODE_SUPPORTED_REPORT',
  },
  0x6E /* COMMAND_CLASS_HUMIDITY_CONTROL_OPERATING_STATE */ : {
    0x01: 'HUMIDITY_CONTROL_OPERATING_STATE_GET',
    0x02: 'HUMIDITY_CONTROL_OPERATING_STATE_REPORT',
  },
  0x64 /* COMMAND_CLASS_HUMIDITY_CONTROL_SETPOINT */ : {
    0x01: 'HUMIDITY_CONTROL_SETPOINT_SET',
    0x02: 'HUMIDITY_CONTROL_SETPOINT_GET',
    0x03: 'HUMIDITY_CONTROL_SETPOINT_REPORT',
    0x04: 'HUMIDITY_CONTROL_SETPOINT_SUPPORTED_GET',
    0x05: 'HUMIDITY_CONTROL_SETPOINT_SUPPORTED_REPORT',
    0x06: 'HUMIDITY_CONTROL_SETPOINT_SCALE_SUPPORTED_GET',
    0x07: 'HUMIDITY_CONTROL_SETPOINT_SCALE_SUPPORTED_REPORT',
    0x08: 'HUMIDITY_CONTROL_SETPOINT_CAPABILITIES_GET',
    0x09: 'HUMIDITY_CONTROL_SETPOINT_CAPABILITIES_REPORT',
  },
  0x74 /* COMMAND_CLASS_INCLUSION_CONTROLLER */ : {
    0x01: 'INITIATE',
    0x02: 'COMPLETE',
  },
  0x87 /* COMMAND_CLASS_INDICATOR */ : {
    0x01: 'INDICATOR_SET',
    0x02: 'INDICATOR_GET',
    0x03: 'INDICATOR_REPORT',
    0x04: 'INDICATOR_SUPPORTED_GET',
    0x05: 'INDICATOR_SUPPORTED_REPORT',
    0x06: 'INDICATOR_DESCRIPTION_GET',
    0x07: 'INDICATOR_DESCRIPTION_REPORT',
  },
  0x5C /* COMMAND_CLASS_IP_ASSOCIATION */ : {},
  0x9A /* COMMAND_CLASS_IP_CONFIGURATION */ : {
    0x01: 'IP_CONFIGURATION_SET',
    0x02: 'IP_CONFIGURATION_GET',
    0x03: 'IP_CONFIGURATION_REPORT',
    0x04: 'IP_CONFIGURATION_RELEASE',
    0x05: 'IP_CONFIGURATION_RENEW',
  },
  0x6B /* COMMAND_CLASS_IRRIGATION */ : {
    0x01: 'IRRIGATION_SYSTEM_INFO_GET',
    0x02: 'IRRIGATION_SYSTEM_INFO_REPORT',
    0x03: 'IRRIGATION_SYSTEM_STATUS_GET',
    0x04: 'IRRIGATION_SYSTEM_STATUS_REPORT',
    0x05: 'IRRIGATION_SYSTEM_CONFIG_SET',
    0x06: 'IRRIGATION_SYSTEM_CONFIG_GET',
    0x07: 'IRRIGATION_SYSTEM_CONFIG_REPORT',
    0x08: 'IRRIGATION_VALVE_INFO_GET',
    0x09: 'IRRIGATION_VALVE_INFO_REPORT',
    0x0A: 'IRRIGATION_VALVE_CONFIG_SET',
    0x0B: 'IRRIGATION_VALVE_CONFIG_GET',
    0x0C: 'IRRIGATION_VALVE_CONFIG_REPORT',
    0x0D: 'IRRIGATION_VALVE_RUN',
    0x0E: 'IRRIGATION_VALVE_TABLE_SET',
    0x0F: 'IRRIGATION_VALVE_TABLE_GET',
    0x10: 'IRRIGATION_VALVE_TABLE_REPORT',
    0x11: 'IRRIGATION_VALVE_TABLE_RUN',
    0x12: 'IRRIGATION_SYSTEM_SHUTOFF',
  },
  0xA0 /* COMMAND_CLASS_IR_REPEATER */ : {
    0x01: 'IR_REPEATER_CAPABILITIES_GET',
    0x02: 'IR_REPEATER_CAPABILITIES_REPORT',
    0x03: 'IR_REPEATER_IR_CODE_LEARNING_START',
    0x04: 'IR_REPEATER_IR_CODE_LEARNING_STOP',
    0x05: 'IR_REPEATER_IR_CODE_LEARNING_STATUS',
    0x06: 'IR_REPEATER_LEARNT_IR_CODE_REMOVE',
    0x07: 'IR_REPEATER_LEARNT_IR_CODE_GET',
    0x08: 'IR_REPEATER_LEARNT_IR_CODE_REPORT',
    0x09: 'IR_REPEATER_LEARNT_IR_CODE_READBACK_GET',
    0x0A: 'IR_REPEATER_LEARNT_IR_CODE_READBACK_REPORT',
    0x0B: 'IR_REPEATER_CONFIGURATION_SET',
    0x0C: 'IR_REPEATER_CONFIGURATION_GET',
    0x0D: 'IR_REPEATER_CONFIGURATION_REPORT',
    0x0E: 'IR_REPEATER_REPEAT_LEARNT_CODE',
    0x0F: 'IR_REPEATER_REPEAT',
  },
  0x89 /* COMMAND_CLASS_LANGUAGE */ : {
    0x01: 'LANGUAGE_SET',
    0x02: 'LANGUAGE_GET',
    0x03: 'LANGUAGE_REPORT',
  },
  0x76 /* COMMAND_CLASS_LOCK */ : {
    0x01: 'LOCK_SET',
    0x02: 'LOCK_GET',
    0x03: 'LOCK_REPORT',
  },
  0x69 /* COMMAND_CLASS_MAILBOX */ : {
    0x01: 'MAILBOX_CONFIGURATION_GET',
    0x02: 'MAILBOX_CONFIGURATION_SET',
    0x03: 'MAILBOX_CONFIGURATION_REPORT',
    0x04: 'MAILBOX_QUEUE',
    0x05: 'MAILBOX_WAKEUP_NOTIFICATION',
    0x06: 'MAILBOX_NODE_FAILING',
  },
  0x91 /* COMMAND_CLASS_MANUFACTURER_PROPRIETARY */ : {},
  0x72 /* COMMAND_CLASS_MANUFACTURER_SPECIFIC */ : {
    0x04: 'MANUFACTURER_SPECIFIC_GET',
    0x05: 'MANUFACTURER_SPECIFIC_REPORT',
    0x06: 'DEVICE_SPECIFIC_GET',
    0x07: 'DEVICE_SPECIFIC_REPORT',
  },
  0xEF /* COMMAND_CLASS_MARK */ : {},
  0x32 /* COMMAND_CLASS_METER */ : {
    0x01: 'METER_GET',
    0x02: 'METER_REPORT',
    0x03: 'METER_SUPPORTED_GET',
    0x04: 'METER_SUPPORTED_REPORT',
    0x05: 'METER_RESET',
  },
  0x35 /* COMMAND_CLASS_METER_PULSE */ : {
    0x04: 'METER_PULSE_GET',
    0x05: 'METER_PULSE_REPORT',
  },
  0x3C /* COMMAND_CLASS_METER_TBL_CONFIG */ : {
    0x01: 'METER_TBL_TABLE_POINT_ADM_NO_SET',
  },
  0x3D /* COMMAND_CLASS_METER_TBL_MONITOR */ : {
    0x01: 'METER_TBL_TABLE_POINT_ADM_NO_GET',
    0x02: 'METER_TBL_TABLE_POINT_ADM_NO_REPORT',
    0x03: 'METER_TBL_TABLE_ID_GET',
    0x04: 'METER_TBL_TABLE_ID_REPORT',
    0x05: 'METER_TBL_TABLE_CAPABILITY_GET',
    0x06: 'METER_TBL_TABLE_CAPABILITY_REPORT',
    0x07: 'METER_TBL_STATUS_SUPPORTED_GET',
    0x08: 'METER_TBL_STATUS_SUPPORTED_REPORT',
    0x09: 'METER_TBL_STATUS_DEPTH_GET',
    0x0A: 'METER_TBL_STATUS_DATE_GET',
    0x0B: 'METER_TBL_STATUS_REPORT',
    0x0C: 'METER_TBL_CURRENT_DATA_GET',
    0x0D: 'METER_TBL_CURRENT_DATA_REPORT',
    0x0E: 'METER_TBL_HISTORICAL_DATA_GET',
    0x0F: 'METER_TBL_HISTORICAL_DATA_REPORT',
  },
  0x3E /* COMMAND_CLASS_METER_TBL_PUSH */ : {
    0x01: 'METER_TBL_PUSH_CONFIGURATION_SET',
    0x02: 'METER_TBL_PUSH_CONFIGURATION_GET',
    0x03: 'METER_TBL_PUSH_CONFIGURATION_REPORT',
  },
  0x51 /* COMMAND_CLASS_MTP_WINDOW_COVERING */ : {
    0x01: 'MOVE_TO_POSITION_SET',
    0x02: 'MOVE_TO_POSITION_GET',
    0x03: 'MOVE_TO_POSITION_REPORT',
  },
  0x60 /* COMMAND_CLASS_MULTI_CHANNEL */ : {
    0x07: 'MULTI_CHANNEL_END_POINT_GET',
    0x08: 'MULTI_CHANNEL_END_POINT_REPORT',
    0x09: 'MULTI_CHANNEL_CAPABILITY_GET',
    0x0A: 'MULTI_CHANNEL_CAPABILITY_REPORT',
    0x0B: 'MULTI_CHANNEL_END_POINT_FIND',
    0x0C: 'MULTI_CHANNEL_END_POINT_FIND_REPORT',
    0x0D: 'MULTI_CHANNEL_CMD_ENCAP',
    0x0E: 'MULTI_CHANNEL_AGGREGATED_MEMBERS_GET',
    0x0F: 'MULTI_CHANNEL_AGGREGATED_MEMBERS_REPORT',
  },
  0x8E /* COMMAND_CLASS_MULTI_CHANNEL_ASSOCIATION */ : {
    0x01: 'MULTI_CHANNEL_ASSOCIATION_SET',
    0x02: 'MULTI_CHANNEL_ASSOCIATION_GET',
    0x03: 'MULTI_CHANNEL_ASSOCIATION_REPORT',
    0x04: 'MULTI_CHANNEL_ASSOCIATION_REMOVE',
    0x05: 'MULTI_CHANNEL_ASSOCIATION_GROUPINGS_GET',
    0x06: 'MULTI_CHANNEL_ASSOCIATION_GROUPINGS_REPORT',
  },
  0x8F /* COMMAND_CLASS_MULTI_CMD */ : {
    0x01: 'MULTI_CMD_ENCAP',
  },
  0x4D /* COMMAND_CLASS_NETWORK_MANAGEMENT_BASIC */ : {
    0x01: 'COMMAND_LEARN_MODE_SET',
    0x02: 'COMMAND_LEARN_MODE_SET_STATUS',
    0x03: 'COMMAND_NETWORK_UPDATE_REQUEST',
    0x04: 'COMMAND_NETWORK_UPDATE_REQUEST_STATUS',
    0x05: 'COMMAND_NODE_INFORMATION_SEND',
    0x06: 'COMMAND_DEFAULT_SET',
    0x07: 'COMMAND_DEFAULT_SET_COMPLETE',
    0x08: 'COMMAND_DSK_GET',
    0x09: 'COMMAND_DSK_REPORT',
  },
  0x34 /* COMMAND_CLASS_NETWORK_MANAGEMENT_INCLUSION */ : {
    0x01: 'COMMAND_NODE_ADD',
    0x02: 'COMMAND_NODE_ADD_STATUS',
    0x03: 'COMMAND_NODE_REMOVE',
    0x04: 'COMMAND_NODE_REMOVE_STATUS',
    0x07: 'COMMAND_FAILED_NODE_REMOVE',
    0x08: 'COMMAND_FAILED_NODE_REMOVE_STATUS',
    0x09: 'COMMAND_FAILED_NODE_REPLACE',
    0x0A: 'COMMAND_FAILED_NODE_REPLACE_STATUS',
    0x0B: 'COMMAND_NODE_NEIGHBOR_UPDATE_REQUEST',
    0x0C: 'COMMAND_NODE_NEIGHBOR_UPDATE_STATUS',
    0x0D: 'COMMAND_RETURN_ROUTE_ASSIGN',
    0x0E: 'COMMAND_RETURN_ROUTE_ASSIGN_COMPLETE',
    0x0F: 'COMMAND_RETURN_ROUTE_DELETE',
    0x10: 'COMMAND_RETURN_ROUTE_DELETE_COMPLETE',
    0x11: 'COMMAND_NODE_ADD_KEYS_REPORT',
    0x12: 'COMMAND_NODE_ADD_KEYS_SET',
    0x13: 'COMMAND_NODE_ADD_DSK_REPORT',
    0x14: 'COMMAND_NODE_ADD_DSK_SET',
    0x19: 'COMMAND_INCLUDED_NIF_REPORT',
    0x15: 'COMMAND_SMART_START_JOIN_STARTED_REPORT',
    0x16: 'COMMAND_EXTENDED_NODE_ADD_STATUS',
  },
  0x54 /* COMMAND_CLASS_NETWORK_MANAGEMENT_PRIMARY */ : {
    0x01: 'COMMAND_CONTROLLER_CHANGE',
    0x02: 'COMMAND_CONTROLLER_CHANGE_STATUS',
  },
  0x52 /* COMMAND_CLASS_NETWORK_MANAGEMENT_PROXY */ : {
    0x01: 'COMMAND_NODE_LIST_GET',
    0x02: 'COMMAND_NODE_LIST_REPORT',
    0x03: 'COMMAND_NODE_INFO_CACHED_GET',
    0x04: 'COMMAND_NODE_INFO_CACHED_REPORT',
    0x05: 'NM_MULTI_CHANNEL_END_POINT_GET',
    0x06: 'NM_MULTI_CHANNEL_END_POINT_REPORT',
    0x07: 'NM_MULTI_CHANNEL_CAPABILITY_GET',
    0x08: 'NM_MULTI_CHANNEL_CAPABILITY_REPORT',
    0x09: 'NM_MULTI_CHANNEL_AGGREGATED_MEMBERS_GET',
    0x0A: 'NM_MULTI_CHANNEL_AGGREGATED_MEMBERS_REPORT',
    0x0B: 'COMMAND_FAILED_NODE_LIST_GET',
    0x0C: 'COMMAND_FAILED_NODE_LIST_REPORT',
  },
  0x77 /* COMMAND_CLASS_NODE_NAMING */ : {
    0x01: 'NODE_NAMING_NODE_NAME_SET',
    0x02: 'NODE_NAMING_NODE_NAME_GET',
    0x03: 'NODE_NAMING_NODE_NAME_REPORT',
    0x04: 'NODE_NAMING_NODE_LOCATION_SET',
    0x05: 'NODE_NAMING_NODE_LOCATION_GET',
    0x06: 'NODE_NAMING_NODE_LOCATION_REPORT',
  },
  0x78 /* COMMAND_CLASS_NODE_PROVISIONING */ : {
    0x01: 'COMMAND_NODE_PROVISIONING_SET',
    0x02: 'COMMAND_NODE_PROVISIONING_DELETE',
    0x05: 'COMMAND_NODE_PROVISIONING_GET',
    0x06: 'COMMAND_NODE_PROVISIONING_REPORT',
    0x03: 'COMMAND_NODE_PROVISIONING_LIST_ITERATION_GET',
    0x04: 'COMMAND_NODE_PROVISIONING_LIST_ITERATION_REPORT',
  },
  0x71 /* COMMAND_CLASS_NOTIFICATION */ : {
    0x01: 'EVENT_SUPPORTED_GET',
    0x02: 'EVENT_SUPPORTED_REPORT',
    0x04: 'NOTIFICATION_GET',
    0x05: 'NOTIFICATION_REPORT',
    0x06: 'NOTIFICATION_SET',
    0x07: 'NOTIFICATION_SUPPORTED_GET',
    0x08: 'NOTIFICATION_SUPPORTED_REPORT',
  },
  0x00 /* COMMAND_CLASS_NO_OPERATION */ : {},
  0x73 /* COMMAND_CLASS_POWERLEVEL */ : {
    0x01: 'POWERLEVEL_SET',
    0x02: 'POWERLEVEL_GET',
    0x03: 'POWERLEVEL_REPORT',
    0x04: 'POWERLEVEL_TEST_NODE_SET',
    0x05: 'POWERLEVEL_TEST_NODE_GET',
    0x06: 'POWERLEVEL_TEST_NODE_REPORT',
  },
  0x3F /* COMMAND_CLASS_PREPAYMENT */ : {
    0x01: 'PREPAYMENT_BALANCE_GET',
    0x02: 'PREPAYMENT_BALANCE_REPORT',
    0x03: 'PREPAYMENT_SUPPORTED_GET',
    0x04: 'PREPAYMENT_SUPPORTED_REPORT',
  },
  0x41 /* COMMAND_CLASS_PREPAYMENT_ENCAPSULATION */ : {
    0x01: 'CMD_ENCAPSULATION',
  },
  0x88 /* COMMAND_CLASS_PROPRIETARY */ : {
    0x01: 'PROPRIETARY_SET',
    0x02: 'PROPRIETARY_GET',
    0x03: 'PROPRIETARY_REPORT',
  },
  0x75 /* COMMAND_CLASS_PROTECTION */ : {
    0x01: 'PROTECTION_SET',
    0x02: 'PROTECTION_GET',
    0x03: 'PROTECTION_REPORT',
    0x04: 'PROTECTION_SUPPORTED_GET',
    0x05: 'PROTECTION_SUPPORTED_REPORT',
    0x06: 'PROTECTION_EC_SET',
    0x07: 'PROTECTION_EC_GET',
    0x08: 'PROTECTION_EC_REPORT',
    0x09: 'PROTECTION_TIMEOUT_SET',
    0x0A: 'PROTECTION_TIMEOUT_GET',
    0x0B: 'PROTECTION_TIMEOUT_REPORT',
  },
  0x48 /* COMMAND_CLASS_RATE_TBL_CONFIG */ : {
    0x01: 'RATE_TBL_SET',
    0x02: 'RATE_TBL_REMOVE',
  },
  0x49 /* COMMAND_CLASS_RATE_TBL_MONITOR */ : {
    0x01: 'RATE_TBL_SUPPORTED_GET',
    0x02: 'RATE_TBL_SUPPORTED_REPORT',
    0x03: 'RATE_TBL_GET',
    0x04: 'RATE_TBL_REPORT',
    0x05: 'RATE_TBL_ACTIVE_RATE_GET',
    0x06: 'RATE_TBL_ACTIVE_RATE_REPORT',
    0x07: 'RATE_TBL_CURRENT_DATA_GET',
    0x08: 'RATE_TBL_CURRENT_DATA_REPORT',
    0x09: 'RATE_TBL_HISTORICAL_DATA_GET',
    0x0A: 'RATE_TBL_HISTORICAL_DATA_REPORT',
  },
  0x7D /* COMMAND_CLASS_REMOTE_ASSOCIATION */ : {
    0x01: 'REMOTE_ASSOCIATION_CONFIGURATION_SET',
    0x02: 'REMOTE_ASSOCIATION_CONFIGURATION_GET',
    0x03: 'REMOTE_ASSOCIATION_CONFIGURATION_REPORT',
  },
  0x7C /* COMMAND_CLASS_REMOTE_ASSOCIATION_ACTIVATE */ : {
    0x01: 'REMOTE_ASSOCIATION_ACTIVATE',
  },
  0x2B /* COMMAND_CLASS_SCENE_ACTIVATION */ : {
    0x01: 'SCENE_ACTIVATION_SET',
  },
  0x2C /* COMMAND_CLASS_SCENE_ACTUATOR_CONF */ : {
    0x01: 'SCENE_ACTUATOR_CONF_SET',
    0x02: 'SCENE_ACTUATOR_CONF_GET',
    0x03: 'SCENE_ACTUATOR_CONF_REPORT',
  },
  0x2D /* COMMAND_CLASS_SCENE_CONTROLLER_CONF */ : {
    0x01: 'SCENE_CONTROLLER_CONF_SET',
    0x02: 'SCENE_CONTROLLER_CONF_GET',
    0x03: 'SCENE_CONTROLLER_CONF_REPORT',
  },
  0x53 /* COMMAND_CLASS_SCHEDULE */ : {
    0x01: 'SCHEDULE_SUPPORTED_GET',
    0x02: 'SCHEDULE_SUPPORTED_REPORT',
    0x03: 'SCHEDULE_SET',
    0x04: 'SCHEDULE_GET',
    0x05: 'SCHEDULE_REPORT',
    0x06: 'SCHEDULE_REMOVE',
    0x07: 'SCHEDULE_STATE_SET',
    0x08: 'SCHEDULE_STATE_GET',
    0x09: 'SCHEDULE_STATE_REPORT',
    0x0A: 'SCHEDULE_SUPPORTED_COMMANDS_GET',
    0x0B: 'SCHEDULE_SUPPORTED_COMMANDS_REPORT',
  },
  0x4E /* COMMAND_CLASS_SCHEDULE_ENTRY_LOCK */ : {
    0x01: 'SCHEDULE_ENTRY_LOCK_ENABLE_SET',
    0x02: 'SCHEDULE_ENTRY_LOCK_ENABLE_ALL_SET',
    0x03: 'SCHEDULE_ENTRY_LOCK_WEEK_DAY_SET',
    0x04: 'SCHEDULE_ENTRY_LOCK_WEEK_DAY_GET',
    0x05: 'SCHEDULE_ENTRY_LOCK_WEEK_DAY_REPORT',
    0x06: 'SCHEDULE_ENTRY_LOCK_YEAR_DAY_SET',
    0x07: 'SCHEDULE_ENTRY_LOCK_YEAR_DAY_GET',
    0x08: 'SCHEDULE_ENTRY_LOCK_YEAR_DAY_REPORT',
    0x09: 'SCHEDULE_ENTRY_TYPE_SUPPORTED_GET',
    0x0A: 'SCHEDULE_ENTRY_TYPE_SUPPORTED_REPORT',
    0x0B: 'SCHEDULE_ENTRY_LOCK_TIME_OFFSET_GET',
    0x0C: 'SCHEDULE_ENTRY_LOCK_TIME_OFFSET_REPORT',
    0x0D: 'SCHEDULE_ENTRY_LOCK_TIME_OFFSET_SET',
    0x0E: 'SCHEDULE_ENTRY_LOCK_DAILY_REPEATING_GET',
    0x0F: 'SCHEDULE_ENTRY_LOCK_DAILY_REPEATING_REPORT',
    0x10: 'SCHEDULE_ENTRY_LOCK_DAILY_REPEATING_SET',
  },
  0x93 /* COMMAND_CLASS_SCREEN_ATTRIBUTES */ : {
    0x01: 'SCREEN_ATTRIBUTES_GET',
    0x02: 'SCREEN_ATTRIBUTES_REPORT',
  },
  0x92 /* COMMAND_CLASS_SCREEN_MD */ : {
    0x01: 'SCREEN_MD_GET',
    0x02: 'SCREEN_MD_REPORT',
  },
  0x98 /* COMMAND_CLASS_SECURITY */ : {
    0x02: 'SECURITY_COMMANDS_SUPPORTED_GET',
    0x03: 'SECURITY_COMMANDS_SUPPORTED_REPORT',
    0x04: 'SECURITY_SCHEME_GET',
    0x05: 'SECURITY_SCHEME_REPORT',
    0x06: 'NETWORK_KEY_SET',
    0x07: 'NETWORK_KEY_VERIFY',
    0x08: 'SECURITY_SCHEME_INHERIT',
    0x40: 'SECURITY_NONCE_GET',
    0x80: 'SECURITY_NONCE_REPORT',
    0x81: 'SECURITY_MESSAGE_ENCAPSULATION',
    0xC1: 'SECURITY_MESSAGE_ENCAPSULATION_NONCE_GET',
  },
  0x9F /* COMMAND_CLASS_SECURITY_2 */ : {
    0x01: 'SECURITY_2_NONCE_GET',
    0x02: 'SECURITY_2_NONCE_REPORT',
    0x03: 'SECURITY_2_MESSAGE_ENCAPSULATION',
    0x04: 'KEX_GET',
    0x05: 'KEX_REPORT',
    0x06: 'KEX_SET',
    0x07: 'KEX_FAIL',
    0x08: 'PUBLIC_KEY_REPORT',
    0x09: 'SECURITY_2_NETWORK_KEY_GET',
    0x0A: 'SECURITY_2_NETWORK_KEY_REPORT',
    0x0B: 'SECURITY_2_NETWORK_KEY_VERIFY',
    0x0C: 'SECURITY_2_TRANSFER_END',
    0x0D: 'SECURITY_2_COMMANDS_SUPPORTED_GET',
    0x0E: 'SECURITY_2_COMMANDS_SUPPORTED_REPORT',
  },
  0xF100 /* COMMAND_CLASS_SECURITY_SCHEME0_MARK */ : {},
  0x9C /* COMMAND_CLASS_SENSOR_ALARM */ : {
    0x01: 'SENSOR_ALARM_GET',
    0x02: 'SENSOR_ALARM_REPORT',
    0x03: 'SENSOR_ALARM_SUPPORTED_GET',
    0x04: 'SENSOR_ALARM_SUPPORTED_REPORT',
  },
  0x30 /* COMMAND_CLASS_SENSOR_BINARY */ : {
    0x02: 'SENSOR_BINARY_GET',
    0x03: 'SENSOR_BINARY_REPORT',
    0x01: 'SENSOR_BINARY_SUPPORTED_GET_SENSOR',
    0x04: 'SENSOR_BINARY_SUPPORTED_SENSOR_REPORT',
  },
  0x9E /* COMMAND_CLASS_SENSOR_CONFIGURATION */ : {
    0x01: 'SENSOR_TRIGGER_LEVEL_SET',
    0x02: 'SENSOR_TRIGGER_LEVEL_GET',
    0x03: 'SENSOR_TRIGGER_LEVEL_REPORT',
  },
  0x31 /* COMMAND_CLASS_SENSOR_MULTILEVEL */ : {
    0x01: 'SENSOR_MULTILEVEL_SUPPORTED_GET_SENSOR',
    0x02: 'SENSOR_MULTILEVEL_SUPPORTED_SENSOR_REPORT',
    0x03: 'SENSOR_MULTILEVEL_SUPPORTED_GET_SCALE',
    0x04: 'SENSOR_MULTILEVEL_GET',
    0x05: 'SENSOR_MULTILEVEL_REPORT',
    0x06: 'SENSOR_MULTILEVEL_SUPPORTED_SCALE_REPORT',
  },
  0x9D /* COMMAND_CLASS_SILENCE_ALARM */ : {
    0x01: 'SENSOR_ALARM_SET',
  },
  0x94 /* COMMAND_CLASS_SIMPLE_AV_CONTROL */ : {
    0x01: 'SIMPLE_AV_CONTROL_SET',
    0x02: 'SIMPLE_AV_CONTROL_GET',
    0x03: 'SIMPLE_AV_CONTROL_REPORT',
    0x04: 'SIMPLE_AV_CONTROL_SUPPORTED_GET',
    0x05: 'SIMPLE_AV_CONTROL_SUPPORTED_REPORT',
  },
  0x79 /* COMMAND_CLASS_SOUND_SWITCH */ : {
    0x01: 'SOUND_SWITCH_TONES_NUMBER_GET',
    0x02: 'SOUND_SWITCH_TONES_NUMBER_REPORT',
    0x03: 'SOUND_SWITCH_TONE_INFO_GET',
    0x04: 'SOUND_SWITCH_TONE_INFO_REPORT',
    0x05: 'SOUND_SWITCH_CONFIGURATION_SET',
    0x06: 'SOUND_SWITCH_CONFIGURATION_GET',
    0x07: 'SOUND_SWITCH_CONFIGURATION_REPORT',
    0x08: 'SOUND_SWITCH_TONE_PLAY_SET',
    0x09: 'SOUND_SWITCH_TONE_PLAY_GET',
    0x0A: 'SOUND_SWITCH_TONE_PLAY_REPORT',
  },
  0x6C /* COMMAND_CLASS_SUPERVISION */ : {
    0x01: 'SUPERVISION_GET',
    0x02: 'SUPERVISION_REPORT',
  },
  0x27 /* COMMAND_CLASS_SWITCH_ALL */ : {
    0x01: 'SWITCH_ALL_SET',
    0x02: 'SWITCH_ALL_GET',
    0x03: 'SWITCH_ALL_REPORT',
    0x04: 'SWITCH_ALL_ON',
    0x05: 'SWITCH_ALL_OFF',
  },
  0x25 /* COMMAND_CLASS_SWITCH_BINARY */ : {
    0x01: 'SWITCH_BINARY_SET',
    0x02: 'SWITCH_BINARY_GET',
    0x03: 'SWITCH_BINARY_REPORT',
  },
  0x33 /* COMMAND_CLASS_SWITCH_COLOR */ : {
    0x01: 'SWITCH_COLOR_SUPPORTED_GET',
    0x02: 'SWITCH_COLOR_SUPPORTED_REPORT',
    0x03: 'SWITCH_COLOR_GET',
    0x04: 'SWITCH_COLOR_REPORT',
    0x05: 'SWITCH_COLOR_SET',
    0x06: 'SWITCH_COLOR_START_LEVEL_CHANGE',
    0x07: 'SWITCH_COLOR_STOP_LEVEL_CHANGE',
  },
  0x26 /* COMMAND_CLASS_SWITCH_MULTILEVEL */ : {
    0x01: 'SWITCH_MULTILEVEL_SET',
    0x02: 'SWITCH_MULTILEVEL_GET',
    0x03: 'SWITCH_MULTILEVEL_REPORT',
    0x04: 'SWITCH_MULTILEVEL_START_LEVEL_CHANGE',
    0x05: 'SWITCH_MULTILEVEL_STOP_LEVEL_CHANGE',
    0x06: 'SWITCH_MULTILEVEL_SUPPORTED_GET',
    0x07: 'SWITCH_MULTILEVEL_SUPPORTED_REPORT',
  },
  0x28 /* COMMAND_CLASS_SWITCH_TOGGLE_BINARY */ : {
    0x01: 'SWITCH_TOGGLE_BINARY_SET',
    0x02: 'SWITCH_TOGGLE_BINARY_GET',
    0x03: 'SWITCH_TOGGLE_BINARY_REPORT',
  },
  0x29 /* COMMAND_CLASS_SWITCH_TOGGLE_MULTILEVEL */ : {
    0x01: 'SWITCH_TOGGLE_MULTILEVEL_SET',
    0x02: 'SWITCH_TOGGLE_MULTILEVEL_GET',
    0x03: 'SWITCH_TOGGLE_MULTILEVEL_REPORT',
    0x04: 'SWITCH_TOGGLE_MULTILEVEL_START_LEVEL_CHANGE',
    0x05: 'SWITCH_TOGGLE_MULTILEVEL_STOP_LEVEL_CHANGE',
  },
  0x4A /* COMMAND_CLASS_TARIFF_CONFIG */ : {
    0x01: 'TARIFF_TBL_SUPPLIER_SET',
    0x02: 'TARIFF_TBL_SET',
    0x03: 'TARIFF_TBL_REMOVE',
  },
  0x4B /* COMMAND_CLASS_TARIFF_TBL_MONITOR */ : {
    0x01: 'TARIFF_TBL_SUPPLIER_GET',
    0x02: 'TARIFF_TBL_SUPPLIER_REPORT',
    0x03: 'TARIFF_TBL_GET',
    0x04: 'TARIFF_TBL_REPORT',
    0x05: 'TARIFF_TBL_COST_GET',
    0x06: 'TARIFF_TBL_COST_REPORT',
  },
  0x44 /* COMMAND_CLASS_THERMOSTAT_FAN_MODE */ : {
    0x01: 'THERMOSTAT_FAN_MODE_SET',
    0x02: 'THERMOSTAT_FAN_MODE_GET',
    0x03: 'THERMOSTAT_FAN_MODE_REPORT',
    0x04: 'THERMOSTAT_FAN_MODE_SUPPORTED_GET',
    0x05: 'THERMOSTAT_FAN_MODE_SUPPORTED_REPORT',
  },
  0x45 /* COMMAND_CLASS_THERMOSTAT_FAN_STATE */ : {
    0x02: 'THERMOSTAT_FAN_STATE_GET',
    0x03: 'THERMOSTAT_FAN_STATE_REPORT',
  },
  0x40 /* COMMAND_CLASS_THERMOSTAT_MODE */ : {
    0x01: 'THERMOSTAT_MODE_SET',
    0x02: 'THERMOSTAT_MODE_GET',
    0x03: 'THERMOSTAT_MODE_REPORT',
    0x04: 'THERMOSTAT_MODE_SUPPORTED_GET',
    0x05: 'THERMOSTAT_MODE_SUPPORTED_REPORT',
  },
  0x42 /* COMMAND_CLASS_THERMOSTAT_OPERATING_STATE */ : {
    0x02: 'THERMOSTAT_OPERATING_STATE_GET',
    0x03: 'THERMOSTAT_OPERATING_STATE_REPORT',
    0x01: 'THERMOSTAT_OPERATING_STATE_LOGGING_SUPPORTED_GET',
    0x04: 'THERMOSTAT_OPERATING_LOGGING_SUPPORTED_REPORT',
    0x05: 'THERMOSTAT_OPERATING_STATE_LOGGING_GET',
    0x06: 'THERMOSTAT_OPERATING_STATE_LOGGING_REPORT',
  },
  0x47 /* COMMAND_CLASS_THERMOSTAT_SETBACK */ : {
    0x01: 'THERMOSTAT_SETBACK_SET',
    0x02: 'THERMOSTAT_SETBACK_GET',
    0x03: 'THERMOSTAT_SETBACK_REPORT',
  },
  0x43 /* COMMAND_CLASS_THERMOSTAT_SETPOINT */ : {
    0x01: 'THERMOSTAT_SETPOINT_SET',
    0x02: 'THERMOSTAT_SETPOINT_GET',
    0x03: 'THERMOSTAT_SETPOINT_REPORT',
    0x04: 'THERMOSTAT_SETPOINT_SUPPORTED_GET',
    0x05: 'THERMOSTAT_SETPOINT_SUPPORTED_REPORT',
    0x09: 'THERMOSTAT_SETPOINT_CAPABILITIES_GET',
    0x0A: 'THERMOSTAT_SETPOINT_CAPABILITIES_REPORT',
  },
  0x8A /* COMMAND_CLASS_TIME */ : {
    0x01: 'TIME_GET',
    0x02: 'TIME_REPORT',
    0x03: 'DATE_GET',
    0x04: 'DATE_REPORT',
    0x05: 'TIME_OFFSET_SET',
    0x06: 'TIME_OFFSET_GET',
    0x07: 'TIME_OFFSET_REPORT',
  },
  0x8B /* COMMAND_CLASS_TIME_PARAMETERS */ : {
    0x01: 'TIME_PARAMETERS_SET',
    0x02: 'TIME_PARAMETERS_GET',
    0x03: 'TIME_PARAMETERS_REPORT',
  },
  0x55 /* COMMAND_CLASS_TRANSPORT_SERVICE */ : {
    0xC0: 'COMMAND_FIRST_FRAGMENT',
    0xE8: 'COMMAND_FRAGMENT_COMPLETE',
    0xC8: 'COMMAND_FRAGMENT_REQUEST',
    0xF0: 'COMMAND_FRAGMENT_WAIT',
    0xE0: 'COMMAND_SUBSEQUENT_FRAGMENT',
  },
  0x63 /* COMMAND_CLASS_USER_CODE */ : {
    0x01: 'USER_CODE_SET',
    0x02: 'USER_CODE_GET',
    0x03: 'USER_CODE_REPORT',
    0x04: 'USERS_NUMBER_GET',
    0x05: 'USERS_NUMBER_REPORT',
    0x06: 'USER_CODE_CAPABILITIES_GET',
    0x07: 'USER_CODE_CAPABILITIES_REPORT',
    0x08: 'USER_CODE_KEYPAD_MODE_SET',
    0x09: 'USER_CODE_KEYPAD_MODE_GET',
    0x0A: 'USER_CODE_KEYPAD_MODE_REPORT',
    0x0B: 'EXTENDED_USER_CODE_SET',
    0x0C: 'EXTENDED_USER_CODE_GET',
    0x0D: 'EXTENDED_USER_CODE_REPORT',
    0x0E: 'MASTER_CODE_SET',
    0x0F: 'MASTER_CODE_GET',
    0x10: 'MASTER_CODE_REPORT',
    0x11: 'USER_CODE_CHECKSUM_GET',
    0x12: 'USER_CODE_CHECKSUM_REPORT',
  },
  0x86 /* COMMAND_CLASS_VERSION */ : {
    0x11: 'VERSION_GET',
    0x12: 'VERSION_REPORT',
    0x13: 'VERSION_COMMAND_CLASS_GET',
    0x14: 'VERSION_COMMAND_CLASS_REPORT',
    0x15: 'VERSION_CAPABILITIES_GET',
    0x16: 'VERSION_CAPABILITIES_REPORT',
    0x17: 'VERSION_ZWAVE_SOFTWARE_GET',
    0x18: 'VERSION_ZWAVE_SOFTWARE_REPORT',
  },
  0x84 /* COMMAND_CLASS_WAKE_UP */ : {
    0x04: 'WAKE_UP_INTERVAL_SET',
    0x05: 'WAKE_UP_INTERVAL_GET',
    0x06: 'WAKE_UP_INTERVAL_REPORT',
    0x07: 'WAKE_UP_NOTIFICATION',
    0x08: 'WAKE_UP_NO_MORE_INFORMATION',
    0x09: 'WAKE_UP_INTERVAL_CAPABILITIES_GET',
    0x0A: 'WAKE_UP_INTERVAL_CAPABILITIES_REPORT',
  },
  0x6A /* COMMAND_CLASS_WINDOW_COVERING */ : {
    0x01: 'WINDOW_COVERING_SUPPORTED_GET',
    0x02: 'WINDOW_COVERING_SUPPORTED_REPORT',
    0x03: 'WINDOW_COVERING_GET',
    0x04: 'WINDOW_COVERING_REPORT',
    0x05: 'WINDOW_COVERING_SET',
    0x06: 'WINDOW_COVERING_START_LEVEL_CHANGE',
    0x07: 'WINDOW_COVERING_STOP_LEVEL_CHANGE',
  },
  0x23 /* COMMAND_CLASS_ZIP */ : {
    0x02: 'COMMAND_ZIP_PACKET',
    0x03: 'COMMAND_ZIP_KEEP_ALIVE',
  },
  0x4F /* COMMAND_CLASS_ZIP_6LOWPAN */ : {},
  0x5F /* COMMAND_CLASS_ZIP_GATEWAY */ : {
    0x01: 'GATEWAY_MODE_SET',
    0x02: 'GATEWAY_MODE_GET',
    0x03: 'GATEWAY_MODE_REPORT',
    0x04: 'GATEWAY_PEER_SET',
    0x05: 'GATEWAY_PEER_GET',
    0x06: 'GATEWAY_PEER_REPORT',
    0x07: 'GATEWAY_LOCK_SET',
    0x08: 'UNSOLICITED_DESTINATION_SET',
    0x09: 'UNSOLICITED_DESTINATION_GET',
    0x0A: 'UNSOLICITED_DESTINATION_REPORT',
    0x0B: 'COMMAND_APPLICATION_NODE_INFO_SET',
    0x0C: 'COMMAND_APPLICATION_NODE_INFO_GET',
    0x0D: 'COMMAND_APPLICATION_NODE_INFO_REPORT',
  },
  0x68 /* COMMAND_CLASS_ZIP_NAMING */ : {
    0x01: 'ZIP_NAMING_NAME_SET',
    0x02: 'ZIP_NAMING_NAME_GET',
    0x03: 'ZIP_NAMING_NAME_REPORT',
    0x04: 'ZIP_NAMING_LOCATION_SET',
    0x05: 'ZIP_NAMING_LOCATION_GET',
    0x06: 'ZIP_NAMING_LOCATION_REPORT',
  },
  0x58 /* COMMAND_CLASS_ZIP_ND */ : {
    0x01: 'ZIP_NODE_ADVERTISEMENT',
    0x03: 'ZIP_NODE_SOLICITATION',
    0x04: 'ZIP_INV_NODE_SOLICITATION',
  },
  0x61 /* COMMAND_CLASS_ZIP_PORTAL */ : {
    0x01: 'GATEWAY_CONFIGURATION_SET',
    0x02: 'GATEWAY_CONFIGURATION_STATUS',
    0x03: 'GATEWAY_CONFIGURATION_GET',
    0x04: 'GATEWAY_CONFIGURATION_REPORT',
  },
  0x5E /* COMMAND_CLASS_ZWAVEPLUS_INFO */ : {
    0x01: 'ZWAVEPLUS_INFO_GET',
    0x02: 'ZWAVEPLUS_INFO_REPORT',
  },
  0x67 /* NETWORK_MANAGEMENT_INSTALLATION_MAINTENANCE */ : {
    0x01: 'LAST_WORKING_ROUTE_SET',
    0x02: 'LAST_WORKING_ROUTE_GET',
    0x03: 'LAST_WORKING_ROUTE_REPORT',
    0x04: 'STATISTICS_GET',
    0x05: 'STATISTICS_REPORT',
    0x06: 'STATISTICS_CLEAR',
    0x07: 'COMMAND_RSSI_GET',
    0x08: 'COMMAND_RSSI_REPORT',
    0x09: 'S2_RESYNCHRONIZATION_EVENT',
    0x0B: 'EXTENDED_STATISTICS_GET',
    0x0C: 'EXTENDED_STATISTICS_REPORT',
    0x0A: 'ZWAVE_LR_CHANNEL_CONFIGURATION_SET',
    0x0D: 'ZWAVE_LR_CHANNEL_CONFIGURATION_GET',
    0x0E: 'ZWAVE_LR_CHANNEL_CONFIGURATION_REPORT',
  },
};
