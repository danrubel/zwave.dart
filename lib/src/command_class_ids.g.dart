// Command class constants
// Import zwave/lib/message_consts.dart rather than directly importing this file

// The first const in each group is the command class const
// followed by consts for each command in that command class.

const COMMAND_CLASS_ANTITHEFT = 0x5D;
const ANTITHEFT_SET = 0x01;
const ANTITHEFT_GET = 0x02;
const ANTITHEFT_REPORT = 0x03;

const COMMAND_CLASS_ANTITHEFT_UNLOCK = 0x7E;
const COMMAND_ANTITHEFT_UNLOCK_STATE_GET = 0x01;
const COMMAND_ANTITHEFT_UNLOCK_STATE_REPORT = 0x02;
const COMMAND_ANTITHEFT_UNLOCK_SET = 0x03;

const COMMAND_CLASS_APPLICATION_CAPABILITY = 0x57;
const COMMAND_COMMAND_CLASS_NOT_SUPPORTED = 0x01;

const COMMAND_CLASS_APPLICATION_STATUS = 0x22;
const APPLICATION_BUSY = 0x01;
const APPLICATION_REJECTED_REQUEST = 0x02;

const COMMAND_CLASS_ASSOCIATION = 0x85;
const ASSOCIATION_SET = 0x01;
const ASSOCIATION_GET = 0x02;
const ASSOCIATION_REPORT = 0x03;
const ASSOCIATION_REMOVE = 0x04;
const ASSOCIATION_GROUPINGS_GET = 0x05;
const ASSOCIATION_GROUPINGS_REPORT = 0x06;
const ASSOCIATION_SPECIFIC_GROUP_GET = 0x0B;
const ASSOCIATION_SPECIFIC_GROUP_REPORT = 0x0C;

const COMMAND_CLASS_ASSOCIATION_COMMAND_CONFIGURATION = 0x9B;
const COMMAND_RECORDS_SUPPORTED_GET = 0x01;
const COMMAND_RECORDS_SUPPORTED_REPORT = 0x02;
const COMMAND_CONFIGURATION_SET = 0x03;
const COMMAND_CONFIGURATION_GET = 0x04;
const COMMAND_CONFIGURATION_REPORT = 0x05;

const COMMAND_CLASS_ASSOCIATION_GRP_INFO = 0x59;
const ASSOCIATION_GROUP_NAME_GET = 0x01;
const ASSOCIATION_GROUP_NAME_REPORT = 0x02;
const ASSOCIATION_GROUP_INFO_GET = 0x03;
const ASSOCIATION_GROUP_INFO_REPORT = 0x04;
const ASSOCIATION_GROUP_COMMAND_LIST_GET = 0x05;
const ASSOCIATION_GROUP_COMMAND_LIST_REPORT = 0x06;

const COMMAND_CLASS_AUTHENTICATION = 0xA1;
const AUTHENTICATION_CAPABILITIES_GET = 0x01;
const AUTHENTICATION_CAPABILITIES_REPORT = 0x02;
const AUTHENTICATION_DATA_SET = 0x03;
const AUTHENTICATION_DATA_GET = 0x04;
const AUTHENTICATION_DATA_REPORT = 0x05;
const AUTHENTICATION_TECHNOLOGIES_COMBINATION_SET = 0x06;
const AUTHENTICATION_TECHNOLOGIES_COMBINATION_GET = 0x07;
const AUTHENTICATION_TECHNOLOGIES_COMBINATION_REPORT = 0x08;
const AUTHENTICATION_CHECKSUM_GET = 0x09;
const AUTHENTICATION_DATA_CHECKSUM_REPORT = 0x0F;

const COMMAND_CLASS_AUTHENTICATION_MEDIA_WRITE = 0xA2;
const AUTHENTICATION_MEDIA_CAPABILITIES_GET = 0x01;
const AUTHENTICATION_MEDIA_CAPABILITIES_REPORT = 0x02;
const AUTHENTICATION_MEDIA_WRITE_START = 0x03;
const AUTHENTICATION_MEDIA_WRITE_STOP = 0x04;
const AUTHENTICATION_MEDIA_WRITE_STATUS = 0x05;

const COMMAND_CLASS_BARRIER_OPERATOR = 0x66;
const BARRIER_OPERATOR_SET = 0x01;
const BARRIER_OPERATOR_GET = 0x02;
const BARRIER_OPERATOR_REPORT = 0x03;
const BARRIER_OPERATOR_SIGNAL_SUPPORTED_GET = 0x04;
const BARRIER_OPERATOR_SIGNAL_SUPPORTED_REPORT = 0x05;
const BARRIER_OPERATOR_SIGNAL_SET = 0x06;
const BARRIER_OPERATOR_SIGNAL_GET = 0x07;
const BARRIER_OPERATOR_SIGNAL_REPORT = 0x08;

const COMMAND_CLASS_BASIC = 0x20;
const BASIC_SET = 0x01;
const BASIC_GET = 0x02;
const BASIC_REPORT = 0x03;

const COMMAND_CLASS_BASIC_TARIFF_INFO = 0x36;
const BASIC_TARIFF_INFO_GET = 0x01;
const BASIC_TARIFF_INFO_REPORT = 0x02;

const COMMAND_CLASS_BASIC_WINDOW_COVERING = 0x50;
const BASIC_WINDOW_COVERING_START_LEVEL_CHANGE = 0x01;
const BASIC_WINDOW_COVERING_STOP_LEVEL_CHANGE = 0x02;

const COMMAND_CLASS_BATTERY = 0x80;
const BATTERY_GET = 0x02;
const BATTERY_REPORT = 0x03;
const BATTERY_HEALTH_GET = 0x04;
const BATTERY_HEALTH_REPORT = 0x05;

const COMMAND_CLASS_CENTRAL_SCENE = 0x5B;
const CENTRAL_SCENE_SUPPORTED_GET = 0x01;
const CENTRAL_SCENE_SUPPORTED_REPORT = 0x02;
const CENTRAL_SCENE_NOTIFICATION = 0x03;
const CENTRAL_SCENE_CONFIGURATION_SET = 0x04;
const CENTRAL_SCENE_CONFIGURATION_GET = 0x05;
const CENTRAL_SCENE_CONFIGURATION_REPORT = 0x06;

const COMMAND_CLASS_CLIMATE_CONTROL_SCHEDULE = 0x46;
const CLIMATE_CONTROL_SCHEDULE_SET = 0x01;
const CLIMATE_CONTROL_SCHEDULE_GET = 0x02;
const CLIMATE_CONTROL_SCHEDULE_REPORT = 0x03;
const CLIMATE_CONTROL_SCHEDULE_CHANGED_GET = 0x04;
const CLIMATE_CONTROL_SCHEDULE_CHANGED_REPORT = 0x05;
const CLIMATE_CONTROL_SCHEDULE_OVERRIDE_SET = 0x06;
const CLIMATE_CONTROL_SCHEDULE_OVERRIDE_GET = 0x07;
const CLIMATE_CONTROL_SCHEDULE_OVERRIDE_REPORT = 0x08;

const COMMAND_CLASS_CLOCK = 0x81;
const CLOCK_SET = 0x04;
const CLOCK_GET = 0x05;
const CLOCK_REPORT = 0x06;

const COMMAND_CLASS_CONFIGURATION = 0x70;
const CONFIGURATION_SET = 0x04;
const CONFIGURATION_GET = 0x05;
const CONFIGURATION_REPORT = 0x06;
const CONFIGURATION_BULK_SET = 0x07;
const CONFIGURATION_BULK_GET = 0x08;
const CONFIGURATION_BULK_REPORT = 0x09;
const CONFIGURATION_NAME_GET = 0x0A;
const CONFIGURATION_NAME_REPORT = 0x0B;
const CONFIGURATION_INFO_GET = 0x0C;
const CONFIGURATION_INFO_REPORT = 0x0D;
const CONFIGURATION_PROPERTIES_GET = 0x0E;
const CONFIGURATION_PROPERTIES_REPORT = 0x0F;
const CONFIGURATION_DEFAULT_RESET = 0x01;

const COMMAND_CLASS_CONTROLLER_REPLICATION = 0x21;
const CTRL_REPLICATION_TRANSFER_GROUP = 0x31;
const CTRL_REPLICATION_TRANSFER_GROUP_NAME = 0x32;
const CTRL_REPLICATION_TRANSFER_SCENE = 0x33;
const CTRL_REPLICATION_TRANSFER_SCENE_NAME = 0x34;

const COMMAND_CLASS_CRC_16_ENCAP = 0x56;
const CRC_16_ENCAP = 0x01;

const COMMAND_CLASS_DCP_CONFIG = 0x3A;
const DCP_LIST_SUPPORTED_GET = 0x01;
const DCP_LIST_SUPPORTED_REPORT = 0x02;
const DCP_LIST_SET = 0x03;
const DCP_LIST_REMOVE = 0x04;

const COMMAND_CLASS_DCP_MONITOR = 0x3B;
const DCP_LIST_GET = 0x01;
const DCP_LIST_REPORT = 0x02;
const DCP_EVENT_STATUS_GET = 0x03;
const DCP_EVENT_STATUS_REPORT = 0x04;

const COMMAND_CLASS_DEVICE_RESET_LOCALLY = 0x5A;
const DEVICE_RESET_LOCALLY_NOTIFICATION = 0x01;

const COMMAND_CLASS_DOOR_LOCK = 0x62;
const DOOR_LOCK_OPERATION_SET = 0x01;
const DOOR_LOCK_OPERATION_GET = 0x02;
const DOOR_LOCK_OPERATION_REPORT = 0x03;
const DOOR_LOCK_CONFIGURATION_SET = 0x04;
const DOOR_LOCK_CONFIGURATION_GET = 0x05;
const DOOR_LOCK_CONFIGURATION_REPORT = 0x06;
const DOOR_LOCK_CAPABILITIES_GET = 0x07;
const DOOR_LOCK_CAPABILITIES_REPORT = 0x08;

const COMMAND_CLASS_DOOR_LOCK_LOGGING = 0x4C;
const DOOR_LOCK_LOGGING_RECORDS_SUPPORTED_GET = 0x01;
const DOOR_LOCK_LOGGING_RECORDS_SUPPORTED_REPORT = 0x02;
const RECORD_GET = 0x03;
const RECORD_REPORT = 0x04;

const COMMAND_CLASS_ENERGY_PRODUCTION = 0x90;
const ENERGY_PRODUCTION_GET = 0x02;
const ENERGY_PRODUCTION_REPORT = 0x03;

const COMMAND_CLASS_ENTRY_CONTROL = 0x6F;
const ENTRY_CONTROL_NOTIFICATION = 0x01;
const ENTRY_CONTROL_KEY_SUPPORTED_GET = 0x02;
const ENTRY_CONTROL_KEY_SUPPORTED_REPORT = 0x03;
const ENTRY_CONTROL_EVENT_SUPPORTED_GET = 0x04;
const ENTRY_CONTROL_EVENT_SUPPORTED_REPORT = 0x05;
const ENTRY_CONTROL_CONFIGURATION_SET = 0x06;
const ENTRY_CONTROL_CONFIGURATION_GET = 0x07;
const ENTRY_CONTROL_CONFIGURATION_REPORT = 0x08;

const COMMAND_CLASS_FIRMWARE_UPDATE_MD = 0x7A;
const FIRMWARE_MD_GET = 0x01;
const FIRMWARE_MD_REPORT = 0x02;
const FIRMWARE_UPDATE_MD_REQUEST_GET = 0x03;
const FIRMWARE_UPDATE_MD_REQUEST_REPORT = 0x04;
const FIRMWARE_UPDATE_MD_GET = 0x05;
const FIRMWARE_UPDATE_MD_REPORT = 0x06;
const FIRMWARE_UPDATE_MD_STATUS_REPORT = 0x07;
const FIRMWARE_UPDATE_ACTIVATION_SET = 0x08;
const FIRMWARE_UPDATE_ACTIVATION_STATUS_REPORT = 0x09;
const FIRMWARE_UPDATE_MD_PREPARE_GET = 0x0A;
const FIRMWARE_UPDATE_MD_PREPARE_REPORT = 0x0B;

const COMMAND_CLASS_GENERIC_SCHEDULE = 0xA3;
const GENERIC_SCHEDULE_CAPABILITIES_GET = 0x01;
const GENERIC_SCHEDULE_CAPABILITIES_REPORT = 0x02;
const GENERIC_SCHEDULE_TIME_RANGE_SET = 0x03;
const GENERIC_SCHEDULE_TIME_RANGE_GET = 0x04;
const GENERIC_SCHEDULE_TIME_RANGE_REPORT = 0x05;
const GENERIC_SCHEDULE_SET = 0x06;
const GENERIC_SCHEDULE_GET = 0x07;
const GENERIC_SCHEDULE_REPORT = 0x08;

const COMMAND_CLASS_GEOGRAPHIC_LOCATION = 0x8C;
const GEOGRAPHIC_LOCATION_SET = 0x01;
const GEOGRAPHIC_LOCATION_GET = 0x02;
const GEOGRAPHIC_LOCATION_REPORT = 0x03;

const COMMAND_CLASS_GROUPING_NAME = 0x7B;
const GROUPING_NAME_SET = 0x01;
const GROUPING_NAME_GET = 0x02;
const GROUPING_NAME_REPORT = 0x03;

const COMMAND_CLASS_HAIL = 0x82;
const HAIL = 0x01;

const COMMAND_CLASS_HRV_CONTROL = 0x39;
const HRV_CONTROL_MODE_SET = 0x01;
const HRV_CONTROL_MODE_GET = 0x02;
const HRV_CONTROL_MODE_REPORT = 0x03;
const HRV_CONTROL_BYPASS_SET = 0x04;
const HRV_CONTROL_BYPASS_GET = 0x05;
const HRV_CONTROL_BYPASS_REPORT = 0x06;
const HRV_CONTROL_VENTILATION_RATE_SET = 0x07;
const HRV_CONTROL_VENTILATION_RATE_GET = 0x08;
const HRV_CONTROL_VENTILATION_RATE_REPORT = 0x09;
const HRV_CONTROL_MODE_SUPPORTED_GET = 0x0A;
const HRV_CONTROL_MODE_SUPPORTED_REPORT = 0x0B;

const COMMAND_CLASS_HRV_STATUS = 0x37;
const HRV_STATUS_GET = 0x01;
const HRV_STATUS_REPORT = 0x02;
const HRV_STATUS_SUPPORTED_GET = 0x03;
const HRV_STATUS_SUPPORTED_REPORT = 0x04;

const COMMAND_CLASS_HUMIDITY_CONTROL_MODE = 0x6D;
const HUMIDITY_CONTROL_MODE_SET = 0x01;
const HUMIDITY_CONTROL_MODE_GET = 0x02;
const HUMIDITY_CONTROL_MODE_REPORT = 0x03;
const HUMIDITY_CONTROL_MODE_SUPPORTED_GET = 0x04;
const HUMIDITY_CONTROL_MODE_SUPPORTED_REPORT = 0x05;

const COMMAND_CLASS_HUMIDITY_CONTROL_OPERATING_STATE = 0x6E;
const HUMIDITY_CONTROL_OPERATING_STATE_GET = 0x01;
const HUMIDITY_CONTROL_OPERATING_STATE_REPORT = 0x02;

const COMMAND_CLASS_HUMIDITY_CONTROL_SETPOINT = 0x64;
const HUMIDITY_CONTROL_SETPOINT_SET = 0x01;
const HUMIDITY_CONTROL_SETPOINT_GET = 0x02;
const HUMIDITY_CONTROL_SETPOINT_REPORT = 0x03;
const HUMIDITY_CONTROL_SETPOINT_SUPPORTED_GET = 0x04;
const HUMIDITY_CONTROL_SETPOINT_SUPPORTED_REPORT = 0x05;
const HUMIDITY_CONTROL_SETPOINT_SCALE_SUPPORTED_GET = 0x06;
const HUMIDITY_CONTROL_SETPOINT_SCALE_SUPPORTED_REPORT = 0x07;
const HUMIDITY_CONTROL_SETPOINT_CAPABILITIES_GET = 0x08;
const HUMIDITY_CONTROL_SETPOINT_CAPABILITIES_REPORT = 0x09;

const COMMAND_CLASS_INCLUSION_CONTROLLER = 0x74;
const INITIATE = 0x01;
const COMPLETE = 0x02;

const COMMAND_CLASS_INDICATOR = 0x87;
const INDICATOR_SET = 0x01;
const INDICATOR_GET = 0x02;
const INDICATOR_REPORT = 0x03;
const INDICATOR_SUPPORTED_GET = 0x04;
const INDICATOR_SUPPORTED_REPORT = 0x05;
const INDICATOR_DESCRIPTION_GET = 0x06;
const INDICATOR_DESCRIPTION_REPORT = 0x07;

const COMMAND_CLASS_IP_ASSOCIATION = 0x5C;

const COMMAND_CLASS_IP_CONFIGURATION = 0x9A;
const IP_CONFIGURATION_SET = 0x01;
const IP_CONFIGURATION_GET = 0x02;
const IP_CONFIGURATION_REPORT = 0x03;
const IP_CONFIGURATION_RELEASE = 0x04;
const IP_CONFIGURATION_RENEW = 0x05;

const COMMAND_CLASS_IRRIGATION = 0x6B;
const IRRIGATION_SYSTEM_INFO_GET = 0x01;
const IRRIGATION_SYSTEM_INFO_REPORT = 0x02;
const IRRIGATION_SYSTEM_STATUS_GET = 0x03;
const IRRIGATION_SYSTEM_STATUS_REPORT = 0x04;
const IRRIGATION_SYSTEM_CONFIG_SET = 0x05;
const IRRIGATION_SYSTEM_CONFIG_GET = 0x06;
const IRRIGATION_SYSTEM_CONFIG_REPORT = 0x07;
const IRRIGATION_VALVE_INFO_GET = 0x08;
const IRRIGATION_VALVE_INFO_REPORT = 0x09;
const IRRIGATION_VALVE_CONFIG_SET = 0x0A;
const IRRIGATION_VALVE_CONFIG_GET = 0x0B;
const IRRIGATION_VALVE_CONFIG_REPORT = 0x0C;
const IRRIGATION_VALVE_RUN = 0x0D;
const IRRIGATION_VALVE_TABLE_SET = 0x0E;
const IRRIGATION_VALVE_TABLE_GET = 0x0F;
const IRRIGATION_VALVE_TABLE_REPORT = 0x10;
const IRRIGATION_VALVE_TABLE_RUN = 0x11;
const IRRIGATION_SYSTEM_SHUTOFF = 0x12;

const COMMAND_CLASS_IR_REPEATER = 0xA0;
const IR_REPEATER_CAPABILITIES_GET = 0x01;
const IR_REPEATER_CAPABILITIES_REPORT = 0x02;
const IR_REPEATER_IR_CODE_LEARNING_START = 0x03;
const IR_REPEATER_IR_CODE_LEARNING_STOP = 0x04;
const IR_REPEATER_IR_CODE_LEARNING_STATUS = 0x05;
const IR_REPEATER_LEARNT_IR_CODE_REMOVE = 0x06;
const IR_REPEATER_LEARNT_IR_CODE_GET = 0x07;
const IR_REPEATER_LEARNT_IR_CODE_REPORT = 0x08;
const IR_REPEATER_LEARNT_IR_CODE_READBACK_GET = 0x09;
const IR_REPEATER_LEARNT_IR_CODE_READBACK_REPORT = 0x0A;
const IR_REPEATER_CONFIGURATION_SET = 0x0B;
const IR_REPEATER_CONFIGURATION_GET = 0x0C;
const IR_REPEATER_CONFIGURATION_REPORT = 0x0D;
const IR_REPEATER_REPEAT_LEARNT_CODE = 0x0E;
const IR_REPEATER_REPEAT = 0x0F;

const COMMAND_CLASS_LANGUAGE = 0x89;
const LANGUAGE_SET = 0x01;
const LANGUAGE_GET = 0x02;
const LANGUAGE_REPORT = 0x03;

const COMMAND_CLASS_LOCK = 0x76;
const LOCK_SET = 0x01;
const LOCK_GET = 0x02;
const LOCK_REPORT = 0x03;

const COMMAND_CLASS_MAILBOX = 0x69;
const MAILBOX_CONFIGURATION_GET = 0x01;
const MAILBOX_CONFIGURATION_SET = 0x02;
const MAILBOX_CONFIGURATION_REPORT = 0x03;
const MAILBOX_QUEUE = 0x04;
const MAILBOX_WAKEUP_NOTIFICATION = 0x05;
const MAILBOX_NODE_FAILING = 0x06;

const COMMAND_CLASS_MANUFACTURER_PROPRIETARY = 0x91;

const COMMAND_CLASS_MANUFACTURER_SPECIFIC = 0x72;
const MANUFACTURER_SPECIFIC_GET = 0x04;
const MANUFACTURER_SPECIFIC_REPORT = 0x05;
const DEVICE_SPECIFIC_GET = 0x06;
const DEVICE_SPECIFIC_REPORT = 0x07;

const COMMAND_CLASS_MARK = 0xEF;

const COMMAND_CLASS_METER = 0x32;
const METER_GET = 0x01;
const METER_REPORT = 0x02;
const METER_SUPPORTED_GET = 0x03;
const METER_SUPPORTED_REPORT = 0x04;
const METER_RESET = 0x05;

const COMMAND_CLASS_METER_PULSE = 0x35;
const METER_PULSE_GET = 0x04;
const METER_PULSE_REPORT = 0x05;

const COMMAND_CLASS_METER_TBL_CONFIG = 0x3C;
const METER_TBL_TABLE_POINT_ADM_NO_SET = 0x01;

const COMMAND_CLASS_METER_TBL_MONITOR = 0x3D;
const METER_TBL_TABLE_POINT_ADM_NO_GET = 0x01;
const METER_TBL_TABLE_POINT_ADM_NO_REPORT = 0x02;
const METER_TBL_TABLE_ID_GET = 0x03;
const METER_TBL_TABLE_ID_REPORT = 0x04;
const METER_TBL_TABLE_CAPABILITY_GET = 0x05;
const METER_TBL_TABLE_CAPABILITY_REPORT = 0x06;
const METER_TBL_STATUS_SUPPORTED_GET = 0x07;
const METER_TBL_STATUS_SUPPORTED_REPORT = 0x08;
const METER_TBL_STATUS_DEPTH_GET = 0x09;
const METER_TBL_STATUS_DATE_GET = 0x0A;
const METER_TBL_STATUS_REPORT = 0x0B;
const METER_TBL_CURRENT_DATA_GET = 0x0C;
const METER_TBL_CURRENT_DATA_REPORT = 0x0D;
const METER_TBL_HISTORICAL_DATA_GET = 0x0E;
const METER_TBL_HISTORICAL_DATA_REPORT = 0x0F;

const COMMAND_CLASS_METER_TBL_PUSH = 0x3E;
const METER_TBL_PUSH_CONFIGURATION_SET = 0x01;
const METER_TBL_PUSH_CONFIGURATION_GET = 0x02;
const METER_TBL_PUSH_CONFIGURATION_REPORT = 0x03;

const COMMAND_CLASS_MTP_WINDOW_COVERING = 0x51;
const MOVE_TO_POSITION_SET = 0x01;
const MOVE_TO_POSITION_GET = 0x02;
const MOVE_TO_POSITION_REPORT = 0x03;

const COMMAND_CLASS_MULTI_CHANNEL = 0x60;
const MULTI_CHANNEL_END_POINT_GET = 0x07;
const MULTI_CHANNEL_END_POINT_REPORT = 0x08;
const MULTI_CHANNEL_CAPABILITY_GET = 0x09;
const MULTI_CHANNEL_CAPABILITY_REPORT = 0x0A;
const MULTI_CHANNEL_END_POINT_FIND = 0x0B;
const MULTI_CHANNEL_END_POINT_FIND_REPORT = 0x0C;
const MULTI_CHANNEL_CMD_ENCAP = 0x0D;
const MULTI_CHANNEL_AGGREGATED_MEMBERS_GET = 0x0E;
const MULTI_CHANNEL_AGGREGATED_MEMBERS_REPORT = 0x0F;

const COMMAND_CLASS_MULTI_CHANNEL_ASSOCIATION = 0x8E;
const MULTI_CHANNEL_ASSOCIATION_SET = 0x01;
const MULTI_CHANNEL_ASSOCIATION_GET = 0x02;
const MULTI_CHANNEL_ASSOCIATION_REPORT = 0x03;
const MULTI_CHANNEL_ASSOCIATION_REMOVE = 0x04;
const MULTI_CHANNEL_ASSOCIATION_GROUPINGS_GET = 0x05;
const MULTI_CHANNEL_ASSOCIATION_GROUPINGS_REPORT = 0x06;

const COMMAND_CLASS_MULTI_CMD = 0x8F;
const MULTI_CMD_ENCAP = 0x01;

const COMMAND_CLASS_NETWORK_MANAGEMENT_BASIC = 0x4D;
const COMMAND_LEARN_MODE_SET = 0x01;
const COMMAND_LEARN_MODE_SET_STATUS = 0x02;
const COMMAND_NETWORK_UPDATE_REQUEST = 0x03;
const COMMAND_NETWORK_UPDATE_REQUEST_STATUS = 0x04;
const COMMAND_NODE_INFORMATION_SEND = 0x05;
const COMMAND_DEFAULT_SET = 0x06;
const COMMAND_DEFAULT_SET_COMPLETE = 0x07;
const COMMAND_DSK_GET = 0x08;
const COMMAND_DSK_REPORT = 0x09;

const COMMAND_CLASS_NETWORK_MANAGEMENT_INCLUSION = 0x34;
const COMMAND_NODE_ADD = 0x01;
const COMMAND_NODE_ADD_STATUS = 0x02;
const COMMAND_NODE_REMOVE = 0x03;
const COMMAND_NODE_REMOVE_STATUS = 0x04;
const COMMAND_FAILED_NODE_REMOVE = 0x07;
const COMMAND_FAILED_NODE_REMOVE_STATUS = 0x08;
const COMMAND_FAILED_NODE_REPLACE = 0x09;
const COMMAND_FAILED_NODE_REPLACE_STATUS = 0x0A;
const COMMAND_NODE_NEIGHBOR_UPDATE_REQUEST = 0x0B;
const COMMAND_NODE_NEIGHBOR_UPDATE_STATUS = 0x0C;
const COMMAND_RETURN_ROUTE_ASSIGN = 0x0D;
const COMMAND_RETURN_ROUTE_ASSIGN_COMPLETE = 0x0E;
const COMMAND_RETURN_ROUTE_DELETE = 0x0F;
const COMMAND_RETURN_ROUTE_DELETE_COMPLETE = 0x10;
const COMMAND_NODE_ADD_KEYS_REPORT = 0x11;
const COMMAND_NODE_ADD_KEYS_SET = 0x12;
const COMMAND_NODE_ADD_DSK_REPORT = 0x13;
const COMMAND_NODE_ADD_DSK_SET = 0x14;
const COMMAND_INCLUDED_NIF_REPORT = 0x19;
const COMMAND_SMART_START_JOIN_STARTED_REPORT = 0x15;
const COMMAND_EXTENDED_NODE_ADD_STATUS = 0x16;

const COMMAND_CLASS_NETWORK_MANAGEMENT_PRIMARY = 0x54;
const COMMAND_CONTROLLER_CHANGE = 0x01;
const COMMAND_CONTROLLER_CHANGE_STATUS = 0x02;

const COMMAND_CLASS_NETWORK_MANAGEMENT_PROXY = 0x52;
const COMMAND_NODE_LIST_GET = 0x01;
const COMMAND_NODE_LIST_REPORT = 0x02;
const COMMAND_NODE_INFO_CACHED_GET = 0x03;
const COMMAND_NODE_INFO_CACHED_REPORT = 0x04;
const NM_MULTI_CHANNEL_END_POINT_GET = 0x05;
const NM_MULTI_CHANNEL_END_POINT_REPORT = 0x06;
const NM_MULTI_CHANNEL_CAPABILITY_GET = 0x07;
const NM_MULTI_CHANNEL_CAPABILITY_REPORT = 0x08;
const NM_MULTI_CHANNEL_AGGREGATED_MEMBERS_GET = 0x09;
const NM_MULTI_CHANNEL_AGGREGATED_MEMBERS_REPORT = 0x0A;
const COMMAND_FAILED_NODE_LIST_GET = 0x0B;
const COMMAND_FAILED_NODE_LIST_REPORT = 0x0C;

const COMMAND_CLASS_NODE_NAMING = 0x77;
const NODE_NAMING_NODE_NAME_SET = 0x01;
const NODE_NAMING_NODE_NAME_GET = 0x02;
const NODE_NAMING_NODE_NAME_REPORT = 0x03;
const NODE_NAMING_NODE_LOCATION_SET = 0x04;
const NODE_NAMING_NODE_LOCATION_GET = 0x05;
const NODE_NAMING_NODE_LOCATION_REPORT = 0x06;

const COMMAND_CLASS_NODE_PROVISIONING = 0x78;
const COMMAND_NODE_PROVISIONING_SET = 0x01;
const COMMAND_NODE_PROVISIONING_DELETE = 0x02;
const COMMAND_NODE_PROVISIONING_GET = 0x05;
const COMMAND_NODE_PROVISIONING_REPORT = 0x06;
const COMMAND_NODE_PROVISIONING_LIST_ITERATION_GET = 0x03;
const COMMAND_NODE_PROVISIONING_LIST_ITERATION_REPORT = 0x04;

const COMMAND_CLASS_NOTIFICATION = 0x71;
const EVENT_SUPPORTED_GET = 0x01;
const EVENT_SUPPORTED_REPORT = 0x02;
const NOTIFICATION_GET = 0x04;
const NOTIFICATION_REPORT = 0x05;
const NOTIFICATION_SET = 0x06;
const NOTIFICATION_SUPPORTED_GET = 0x07;
const NOTIFICATION_SUPPORTED_REPORT = 0x08;

const COMMAND_CLASS_NO_OPERATION = 0x00;

const COMMAND_CLASS_POWERLEVEL = 0x73;
const POWERLEVEL_SET = 0x01;
const POWERLEVEL_GET = 0x02;
const POWERLEVEL_REPORT = 0x03;
const POWERLEVEL_TEST_NODE_SET = 0x04;
const POWERLEVEL_TEST_NODE_GET = 0x05;
const POWERLEVEL_TEST_NODE_REPORT = 0x06;

const COMMAND_CLASS_PREPAYMENT = 0x3F;
const PREPAYMENT_BALANCE_GET = 0x01;
const PREPAYMENT_BALANCE_REPORT = 0x02;
const PREPAYMENT_SUPPORTED_GET = 0x03;
const PREPAYMENT_SUPPORTED_REPORT = 0x04;

const COMMAND_CLASS_PREPAYMENT_ENCAPSULATION = 0x41;
const CMD_ENCAPSULATION = 0x01;

const COMMAND_CLASS_PROPRIETARY = 0x88;
const PROPRIETARY_SET = 0x01;
const PROPRIETARY_GET = 0x02;
const PROPRIETARY_REPORT = 0x03;

const COMMAND_CLASS_PROTECTION = 0x75;
const PROTECTION_SET = 0x01;
const PROTECTION_GET = 0x02;
const PROTECTION_REPORT = 0x03;
const PROTECTION_SUPPORTED_GET = 0x04;
const PROTECTION_SUPPORTED_REPORT = 0x05;
const PROTECTION_EC_SET = 0x06;
const PROTECTION_EC_GET = 0x07;
const PROTECTION_EC_REPORT = 0x08;
const PROTECTION_TIMEOUT_SET = 0x09;
const PROTECTION_TIMEOUT_GET = 0x0A;
const PROTECTION_TIMEOUT_REPORT = 0x0B;

const COMMAND_CLASS_RATE_TBL_CONFIG = 0x48;
const RATE_TBL_SET = 0x01;
const RATE_TBL_REMOVE = 0x02;

const COMMAND_CLASS_RATE_TBL_MONITOR = 0x49;
const RATE_TBL_SUPPORTED_GET = 0x01;
const RATE_TBL_SUPPORTED_REPORT = 0x02;
const RATE_TBL_GET = 0x03;
const RATE_TBL_REPORT = 0x04;
const RATE_TBL_ACTIVE_RATE_GET = 0x05;
const RATE_TBL_ACTIVE_RATE_REPORT = 0x06;
const RATE_TBL_CURRENT_DATA_GET = 0x07;
const RATE_TBL_CURRENT_DATA_REPORT = 0x08;
const RATE_TBL_HISTORICAL_DATA_GET = 0x09;
const RATE_TBL_HISTORICAL_DATA_REPORT = 0x0A;

const COMMAND_CLASS_REMOTE_ASSOCIATION = 0x7D;
const REMOTE_ASSOCIATION_CONFIGURATION_SET = 0x01;
const REMOTE_ASSOCIATION_CONFIGURATION_GET = 0x02;
const REMOTE_ASSOCIATION_CONFIGURATION_REPORT = 0x03;

const COMMAND_CLASS_REMOTE_ASSOCIATION_ACTIVATE = 0x7C;
const REMOTE_ASSOCIATION_ACTIVATE = 0x01;

const COMMAND_CLASS_SCENE_ACTIVATION = 0x2B;
const SCENE_ACTIVATION_SET = 0x01;

const COMMAND_CLASS_SCENE_ACTUATOR_CONF = 0x2C;
const SCENE_ACTUATOR_CONF_SET = 0x01;
const SCENE_ACTUATOR_CONF_GET = 0x02;
const SCENE_ACTUATOR_CONF_REPORT = 0x03;

const COMMAND_CLASS_SCENE_CONTROLLER_CONF = 0x2D;
const SCENE_CONTROLLER_CONF_SET = 0x01;
const SCENE_CONTROLLER_CONF_GET = 0x02;
const SCENE_CONTROLLER_CONF_REPORT = 0x03;

const COMMAND_CLASS_SCHEDULE = 0x53;
const SCHEDULE_SUPPORTED_GET = 0x01;
const SCHEDULE_SUPPORTED_REPORT = 0x02;
const SCHEDULE_SET = 0x03;
const SCHEDULE_GET = 0x04;
const SCHEDULE_REPORT = 0x05;
const SCHEDULE_REMOVE = 0x06;
const SCHEDULE_STATE_SET = 0x07;
const SCHEDULE_STATE_GET = 0x08;
const SCHEDULE_STATE_REPORT = 0x09;
const SCHEDULE_SUPPORTED_COMMANDS_GET = 0x0A;
const SCHEDULE_SUPPORTED_COMMANDS_REPORT = 0x0B;

const COMMAND_CLASS_SCHEDULE_ENTRY_LOCK = 0x4E;
const SCHEDULE_ENTRY_LOCK_ENABLE_SET = 0x01;
const SCHEDULE_ENTRY_LOCK_ENABLE_ALL_SET = 0x02;
const SCHEDULE_ENTRY_LOCK_WEEK_DAY_SET = 0x03;
const SCHEDULE_ENTRY_LOCK_WEEK_DAY_GET = 0x04;
const SCHEDULE_ENTRY_LOCK_WEEK_DAY_REPORT = 0x05;
const SCHEDULE_ENTRY_LOCK_YEAR_DAY_SET = 0x06;
const SCHEDULE_ENTRY_LOCK_YEAR_DAY_GET = 0x07;
const SCHEDULE_ENTRY_LOCK_YEAR_DAY_REPORT = 0x08;
const SCHEDULE_ENTRY_TYPE_SUPPORTED_GET = 0x09;
const SCHEDULE_ENTRY_TYPE_SUPPORTED_REPORT = 0x0A;
const SCHEDULE_ENTRY_LOCK_TIME_OFFSET_GET = 0x0B;
const SCHEDULE_ENTRY_LOCK_TIME_OFFSET_REPORT = 0x0C;
const SCHEDULE_ENTRY_LOCK_TIME_OFFSET_SET = 0x0D;
const SCHEDULE_ENTRY_LOCK_DAILY_REPEATING_GET = 0x0E;
const SCHEDULE_ENTRY_LOCK_DAILY_REPEATING_REPORT = 0x0F;
const SCHEDULE_ENTRY_LOCK_DAILY_REPEATING_SET = 0x10;

const COMMAND_CLASS_SCREEN_ATTRIBUTES = 0x93;
const SCREEN_ATTRIBUTES_GET = 0x01;
const SCREEN_ATTRIBUTES_REPORT = 0x02;

const COMMAND_CLASS_SCREEN_MD = 0x92;
const SCREEN_MD_GET = 0x01;
const SCREEN_MD_REPORT = 0x02;

const COMMAND_CLASS_SECURITY = 0x98;
const SECURITY_COMMANDS_SUPPORTED_GET = 0x02;
const SECURITY_COMMANDS_SUPPORTED_REPORT = 0x03;
const SECURITY_SCHEME_GET = 0x04;
const SECURITY_SCHEME_REPORT = 0x05;
const NETWORK_KEY_SET = 0x06;
const NETWORK_KEY_VERIFY = 0x07;
const SECURITY_SCHEME_INHERIT = 0x08;
const SECURITY_NONCE_GET = 0x40;
const SECURITY_NONCE_REPORT = 0x80;
const SECURITY_MESSAGE_ENCAPSULATION = 0x81;
const SECURITY_MESSAGE_ENCAPSULATION_NONCE_GET = 0xC1;

const COMMAND_CLASS_SECURITY_2 = 0x9F;
const SECURITY_2_NONCE_GET = 0x01;
const SECURITY_2_NONCE_REPORT = 0x02;
const SECURITY_2_MESSAGE_ENCAPSULATION = 0x03;
const KEX_GET = 0x04;
const KEX_REPORT = 0x05;
const KEX_SET = 0x06;
const KEX_FAIL = 0x07;
const PUBLIC_KEY_REPORT = 0x08;
const SECURITY_2_NETWORK_KEY_GET = 0x09;
const SECURITY_2_NETWORK_KEY_REPORT = 0x0A;
const SECURITY_2_NETWORK_KEY_VERIFY = 0x0B;
const SECURITY_2_TRANSFER_END = 0x0C;
const SECURITY_2_COMMANDS_SUPPORTED_GET = 0x0D;
const SECURITY_2_COMMANDS_SUPPORTED_REPORT = 0x0E;

const COMMAND_CLASS_SECURITY_SCHEME0_MARK = 0xF100;

const COMMAND_CLASS_SENSOR_ALARM = 0x9C;
const SENSOR_ALARM_GET = 0x01;
const SENSOR_ALARM_REPORT = 0x02;
const SENSOR_ALARM_SUPPORTED_GET = 0x03;
const SENSOR_ALARM_SUPPORTED_REPORT = 0x04;

const COMMAND_CLASS_SENSOR_BINARY = 0x30;
const SENSOR_BINARY_GET = 0x02;
const SENSOR_BINARY_REPORT = 0x03;
const SENSOR_BINARY_SUPPORTED_GET_SENSOR = 0x01;
const SENSOR_BINARY_SUPPORTED_SENSOR_REPORT = 0x04;

const COMMAND_CLASS_SENSOR_CONFIGURATION = 0x9E;
const SENSOR_TRIGGER_LEVEL_SET = 0x01;
const SENSOR_TRIGGER_LEVEL_GET = 0x02;
const SENSOR_TRIGGER_LEVEL_REPORT = 0x03;

const COMMAND_CLASS_SENSOR_MULTILEVEL = 0x31;
const SENSOR_MULTILEVEL_SUPPORTED_GET_SENSOR = 0x01;
const SENSOR_MULTILEVEL_SUPPORTED_SENSOR_REPORT = 0x02;
const SENSOR_MULTILEVEL_SUPPORTED_GET_SCALE = 0x03;
const SENSOR_MULTILEVEL_GET = 0x04;
const SENSOR_MULTILEVEL_REPORT = 0x05;
const SENSOR_MULTILEVEL_SUPPORTED_SCALE_REPORT = 0x06;

const COMMAND_CLASS_SILENCE_ALARM = 0x9D;
const SENSOR_ALARM_SET = 0x01;

const COMMAND_CLASS_SIMPLE_AV_CONTROL = 0x94;
const SIMPLE_AV_CONTROL_SET = 0x01;
const SIMPLE_AV_CONTROL_GET = 0x02;
const SIMPLE_AV_CONTROL_REPORT = 0x03;
const SIMPLE_AV_CONTROL_SUPPORTED_GET = 0x04;
const SIMPLE_AV_CONTROL_SUPPORTED_REPORT = 0x05;

const COMMAND_CLASS_SOUND_SWITCH = 0x79;
const SOUND_SWITCH_TONES_NUMBER_GET = 0x01;
const SOUND_SWITCH_TONES_NUMBER_REPORT = 0x02;
const SOUND_SWITCH_TONE_INFO_GET = 0x03;
const SOUND_SWITCH_TONE_INFO_REPORT = 0x04;
const SOUND_SWITCH_CONFIGURATION_SET = 0x05;
const SOUND_SWITCH_CONFIGURATION_GET = 0x06;
const SOUND_SWITCH_CONFIGURATION_REPORT = 0x07;
const SOUND_SWITCH_TONE_PLAY_SET = 0x08;
const SOUND_SWITCH_TONE_PLAY_GET = 0x09;
const SOUND_SWITCH_TONE_PLAY_REPORT = 0x0A;

const COMMAND_CLASS_SUPERVISION = 0x6C;
const SUPERVISION_GET = 0x01;
const SUPERVISION_REPORT = 0x02;

const COMMAND_CLASS_SWITCH_ALL = 0x27;
const SWITCH_ALL_SET = 0x01;
const SWITCH_ALL_GET = 0x02;
const SWITCH_ALL_REPORT = 0x03;
const SWITCH_ALL_ON = 0x04;
const SWITCH_ALL_OFF = 0x05;

const COMMAND_CLASS_SWITCH_BINARY = 0x25;
const SWITCH_BINARY_SET = 0x01;
const SWITCH_BINARY_GET = 0x02;
const SWITCH_BINARY_REPORT = 0x03;

const COMMAND_CLASS_SWITCH_COLOR = 0x33;
const SWITCH_COLOR_SUPPORTED_GET = 0x01;
const SWITCH_COLOR_SUPPORTED_REPORT = 0x02;
const SWITCH_COLOR_GET = 0x03;
const SWITCH_COLOR_REPORT = 0x04;
const SWITCH_COLOR_SET = 0x05;
const SWITCH_COLOR_START_LEVEL_CHANGE = 0x06;
const SWITCH_COLOR_STOP_LEVEL_CHANGE = 0x07;

const COMMAND_CLASS_SWITCH_MULTILEVEL = 0x26;
const SWITCH_MULTILEVEL_SET = 0x01;
const SWITCH_MULTILEVEL_GET = 0x02;
const SWITCH_MULTILEVEL_REPORT = 0x03;
const SWITCH_MULTILEVEL_START_LEVEL_CHANGE = 0x04;
const SWITCH_MULTILEVEL_STOP_LEVEL_CHANGE = 0x05;
const SWITCH_MULTILEVEL_SUPPORTED_GET = 0x06;
const SWITCH_MULTILEVEL_SUPPORTED_REPORT = 0x07;

const COMMAND_CLASS_SWITCH_TOGGLE_BINARY = 0x28;
const SWITCH_TOGGLE_BINARY_SET = 0x01;
const SWITCH_TOGGLE_BINARY_GET = 0x02;
const SWITCH_TOGGLE_BINARY_REPORT = 0x03;

const COMMAND_CLASS_SWITCH_TOGGLE_MULTILEVEL = 0x29;
const SWITCH_TOGGLE_MULTILEVEL_SET = 0x01;
const SWITCH_TOGGLE_MULTILEVEL_GET = 0x02;
const SWITCH_TOGGLE_MULTILEVEL_REPORT = 0x03;
const SWITCH_TOGGLE_MULTILEVEL_START_LEVEL_CHANGE = 0x04;
const SWITCH_TOGGLE_MULTILEVEL_STOP_LEVEL_CHANGE = 0x05;

const COMMAND_CLASS_TARIFF_CONFIG = 0x4A;
const TARIFF_TBL_SUPPLIER_SET = 0x01;
const TARIFF_TBL_SET = 0x02;
const TARIFF_TBL_REMOVE = 0x03;

const COMMAND_CLASS_TARIFF_TBL_MONITOR = 0x4B;
const TARIFF_TBL_SUPPLIER_GET = 0x01;
const TARIFF_TBL_SUPPLIER_REPORT = 0x02;
const TARIFF_TBL_GET = 0x03;
const TARIFF_TBL_REPORT = 0x04;
const TARIFF_TBL_COST_GET = 0x05;
const TARIFF_TBL_COST_REPORT = 0x06;

const COMMAND_CLASS_THERMOSTAT_FAN_MODE = 0x44;
const THERMOSTAT_FAN_MODE_SET = 0x01;
const THERMOSTAT_FAN_MODE_GET = 0x02;
const THERMOSTAT_FAN_MODE_REPORT = 0x03;
const THERMOSTAT_FAN_MODE_SUPPORTED_GET = 0x04;
const THERMOSTAT_FAN_MODE_SUPPORTED_REPORT = 0x05;

const COMMAND_CLASS_THERMOSTAT_FAN_STATE = 0x45;
const THERMOSTAT_FAN_STATE_GET = 0x02;
const THERMOSTAT_FAN_STATE_REPORT = 0x03;

const COMMAND_CLASS_THERMOSTAT_MODE = 0x40;
const THERMOSTAT_MODE_SET = 0x01;
const THERMOSTAT_MODE_GET = 0x02;
const THERMOSTAT_MODE_REPORT = 0x03;
const THERMOSTAT_MODE_SUPPORTED_GET = 0x04;
const THERMOSTAT_MODE_SUPPORTED_REPORT = 0x05;

const COMMAND_CLASS_THERMOSTAT_OPERATING_STATE = 0x42;
const THERMOSTAT_OPERATING_STATE_GET = 0x02;
const THERMOSTAT_OPERATING_STATE_REPORT = 0x03;
const THERMOSTAT_OPERATING_STATE_LOGGING_SUPPORTED_GET = 0x01;
const THERMOSTAT_OPERATING_LOGGING_SUPPORTED_REPORT = 0x04;
const THERMOSTAT_OPERATING_STATE_LOGGING_GET = 0x05;
const THERMOSTAT_OPERATING_STATE_LOGGING_REPORT = 0x06;

const COMMAND_CLASS_THERMOSTAT_SETBACK = 0x47;
const THERMOSTAT_SETBACK_SET = 0x01;
const THERMOSTAT_SETBACK_GET = 0x02;
const THERMOSTAT_SETBACK_REPORT = 0x03;

const COMMAND_CLASS_THERMOSTAT_SETPOINT = 0x43;
const THERMOSTAT_SETPOINT_SET = 0x01;
const THERMOSTAT_SETPOINT_GET = 0x02;
const THERMOSTAT_SETPOINT_REPORT = 0x03;
const THERMOSTAT_SETPOINT_SUPPORTED_GET = 0x04;
const THERMOSTAT_SETPOINT_SUPPORTED_REPORT = 0x05;
const THERMOSTAT_SETPOINT_CAPABILITIES_GET = 0x09;
const THERMOSTAT_SETPOINT_CAPABILITIES_REPORT = 0x0A;

const COMMAND_CLASS_TIME = 0x8A;
const TIME_GET = 0x01;
const TIME_REPORT = 0x02;
const DATE_GET = 0x03;
const DATE_REPORT = 0x04;
const TIME_OFFSET_SET = 0x05;
const TIME_OFFSET_GET = 0x06;
const TIME_OFFSET_REPORT = 0x07;

const COMMAND_CLASS_TIME_PARAMETERS = 0x8B;
const TIME_PARAMETERS_SET = 0x01;
const TIME_PARAMETERS_GET = 0x02;
const TIME_PARAMETERS_REPORT = 0x03;

const COMMAND_CLASS_TRANSPORT_SERVICE = 0x55;
const COMMAND_FIRST_FRAGMENT = 0xC0;
const COMMAND_FRAGMENT_COMPLETE = 0xE8;
const COMMAND_FRAGMENT_REQUEST = 0xC8;
const COMMAND_FRAGMENT_WAIT = 0xF0;
const COMMAND_SUBSEQUENT_FRAGMENT = 0xE0;

const COMMAND_CLASS_USER_CODE = 0x63;
const USER_CODE_SET = 0x01;
const USER_CODE_GET = 0x02;
const USER_CODE_REPORT = 0x03;
const USERS_NUMBER_GET = 0x04;
const USERS_NUMBER_REPORT = 0x05;
const USER_CODE_CAPABILITIES_GET = 0x06;
const USER_CODE_CAPABILITIES_REPORT = 0x07;
const USER_CODE_KEYPAD_MODE_SET = 0x08;
const USER_CODE_KEYPAD_MODE_GET = 0x09;
const USER_CODE_KEYPAD_MODE_REPORT = 0x0A;
const EXTENDED_USER_CODE_SET = 0x0B;
const EXTENDED_USER_CODE_GET = 0x0C;
const EXTENDED_USER_CODE_REPORT = 0x0D;
const MASTER_CODE_SET = 0x0E;
const MASTER_CODE_GET = 0x0F;
const MASTER_CODE_REPORT = 0x10;
const USER_CODE_CHECKSUM_GET = 0x11;
const USER_CODE_CHECKSUM_REPORT = 0x12;

const COMMAND_CLASS_VERSION = 0x86;
const VERSION_GET = 0x11;
const VERSION_REPORT = 0x12;
const VERSION_COMMAND_CLASS_GET = 0x13;
const VERSION_COMMAND_CLASS_REPORT = 0x14;
const VERSION_CAPABILITIES_GET = 0x15;
const VERSION_CAPABILITIES_REPORT = 0x16;
const VERSION_ZWAVE_SOFTWARE_GET = 0x17;
const VERSION_ZWAVE_SOFTWARE_REPORT = 0x18;

const COMMAND_CLASS_WAKE_UP = 0x84;
const WAKE_UP_INTERVAL_SET = 0x04;
const WAKE_UP_INTERVAL_GET = 0x05;
const WAKE_UP_INTERVAL_REPORT = 0x06;
const WAKE_UP_NOTIFICATION = 0x07;
const WAKE_UP_NO_MORE_INFORMATION = 0x08;
const WAKE_UP_INTERVAL_CAPABILITIES_GET = 0x09;
const WAKE_UP_INTERVAL_CAPABILITIES_REPORT = 0x0A;

const COMMAND_CLASS_WINDOW_COVERING = 0x6A;
const WINDOW_COVERING_SUPPORTED_GET = 0x01;
const WINDOW_COVERING_SUPPORTED_REPORT = 0x02;
const WINDOW_COVERING_GET = 0x03;
const WINDOW_COVERING_REPORT = 0x04;
const WINDOW_COVERING_SET = 0x05;
const WINDOW_COVERING_START_LEVEL_CHANGE = 0x06;
const WINDOW_COVERING_STOP_LEVEL_CHANGE = 0x07;

const COMMAND_CLASS_ZIP = 0x23;
const COMMAND_ZIP_PACKET = 0x02;
const COMMAND_ZIP_KEEP_ALIVE = 0x03;

const COMMAND_CLASS_ZIP_6LOWPAN = 0x4F;

const COMMAND_CLASS_ZIP_GATEWAY = 0x5F;
const GATEWAY_MODE_SET = 0x01;
const GATEWAY_MODE_GET = 0x02;
const GATEWAY_MODE_REPORT = 0x03;
const GATEWAY_PEER_SET = 0x04;
const GATEWAY_PEER_GET = 0x05;
const GATEWAY_PEER_REPORT = 0x06;
const GATEWAY_LOCK_SET = 0x07;
const UNSOLICITED_DESTINATION_SET = 0x08;
const UNSOLICITED_DESTINATION_GET = 0x09;
const UNSOLICITED_DESTINATION_REPORT = 0x0A;
const COMMAND_APPLICATION_NODE_INFO_SET = 0x0B;
const COMMAND_APPLICATION_NODE_INFO_GET = 0x0C;
const COMMAND_APPLICATION_NODE_INFO_REPORT = 0x0D;

const COMMAND_CLASS_ZIP_NAMING = 0x68;
const ZIP_NAMING_NAME_SET = 0x01;
const ZIP_NAMING_NAME_GET = 0x02;
const ZIP_NAMING_NAME_REPORT = 0x03;
const ZIP_NAMING_LOCATION_SET = 0x04;
const ZIP_NAMING_LOCATION_GET = 0x05;
const ZIP_NAMING_LOCATION_REPORT = 0x06;

const COMMAND_CLASS_ZIP_ND = 0x58;
const ZIP_NODE_ADVERTISEMENT = 0x01;
const ZIP_NODE_SOLICITATION = 0x03;
const ZIP_INV_NODE_SOLICITATION = 0x04;

const COMMAND_CLASS_ZIP_PORTAL = 0x61;
const GATEWAY_CONFIGURATION_SET = 0x01;
const GATEWAY_CONFIGURATION_STATUS = 0x02;
const GATEWAY_CONFIGURATION_GET = 0x03;
const GATEWAY_CONFIGURATION_REPORT = 0x04;

const COMMAND_CLASS_ZWAVEPLUS_INFO = 0x5E;
const ZWAVEPLUS_INFO_GET = 0x01;
const ZWAVEPLUS_INFO_REPORT = 0x02;

const NETWORK_MANAGEMENT_INSTALLATION_MAINTENANCE = 0x67;
const LAST_WORKING_ROUTE_SET = 0x01;
const LAST_WORKING_ROUTE_GET = 0x02;
const LAST_WORKING_ROUTE_REPORT = 0x03;
const STATISTICS_GET = 0x04;
const STATISTICS_REPORT = 0x05;
const STATISTICS_CLEAR = 0x06;
const COMMAND_RSSI_GET = 0x07;
const COMMAND_RSSI_REPORT = 0x08;
const S2_RESYNCHRONIZATION_EVENT = 0x09;
const EXTENDED_STATISTICS_GET = 0x0B;
const EXTENDED_STATISTICS_REPORT = 0x0C;
const ZWAVE_LR_CHANNEL_CONFIGURATION_SET = 0x0A;
const ZWAVE_LR_CHANNEL_CONFIGURATION_GET = 0x0D;
const ZWAVE_LR_CHANNEL_CONFIGURATION_REPORT = 0x0E;
