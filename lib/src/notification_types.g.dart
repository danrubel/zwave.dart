// Notification type constants
// Import zwave/lib/message_consts.dart rather than directly importing this file

import 'package:zwave/src/notification_types.dart';

final notificationTypes = [
  null, // Reserved
  /*  1 - 0x01 */ smokeAlarm,
  /*  2 - 0x02 */ coAlarm,
  /*  3 - 0x03 */ co2Alarm,
  /*  4 - 0x04 */ heatAlarm,
  /*  5 - 0x05 */ waterAlarm,
  /*  6 - 0x06 */ accessControl,
  /*  7 - 0x07 */ homeSecurity,
  /*  8 - 0x08 */ powerManagement,
  /*  9 - 0x09 */ system,
  /* 10 - 0x0A */ emergencyAlarm,
  /* 11 - 0x0B */ clock,
  /* 12 - 0x0C */ appliance,
  /* 13 - 0x0D */ homeHealth,
  /* 14 - 0x0E */ siren,
  /* 15 - 0x0F */ waterValve,
  /* 16 - 0x10 */ weatherAlarm,
  /* 17 - 0x11 */ irrigation,
  /* 18 - 0x12 */ gasAlarm,
  /* 19 - 0x13 */ pestControl,
  /* 20 - 0x14 */ lightSensor,
  /* 21 - 0x15 */ waterQualityMonitoring,
  /* 22 - 0x16 */ homeMonitoring,
  /* 255 - 0xFF requestPending */
];

const NOTIFICATION_TYPE_ACCESS_CONTROL = 0x06;
const NOTIFICATION_TYPE_APPLIANCE = 0x0C;
const NOTIFICATION_TYPE_CLOCK = 0x0B;
const NOTIFICATION_TYPE_CO2_ALARM = 0x03;
const NOTIFICATION_TYPE_CO_ALARM = 0x02;
const NOTIFICATION_TYPE_EMERGENCY_ALARM = 0x0A;
const NOTIFICATION_TYPE_GAS_ALARM = 0x12;
const NOTIFICATION_TYPE_HEAT_ALARM = 0x04;
const NOTIFICATION_TYPE_HOME_HEALTH = 0x0D;
const NOTIFICATION_TYPE_HOME_MONITORING = 0x16;
const NOTIFICATION_TYPE_HOME_SECURITY = 0x07;
const NOTIFICATION_TYPE_IRRIGATION = 0x11;
const NOTIFICATION_TYPE_LIGHT_SENSOR = 0x14;
const NOTIFICATION_TYPE_PEST_CONTROL = 0x13;
const NOTIFICATION_TYPE_POWER_MANAGEMENT = 0x08;
const NOTIFICATION_TYPE_REQUEST_PENDING = 0xFF;
const NOTIFICATION_TYPE_SIREN = 0x0E;
const NOTIFICATION_TYPE_SMOKE_ALARM = 0x01;
const NOTIFICATION_TYPE_SYSTEM = 0x09;
const NOTIFICATION_TYPE_WATER_ALARM = 0x05;
const NOTIFICATION_TYPE_WATER_QUALITY_MONITORING = 0x15;
const NOTIFICATION_TYPE_WATER_VALVE = 0x0F;
const NOTIFICATION_TYPE_WEATHER_ALARM = 0x10;

const accessControl = NotificationType(
  /* 0x06 */ NOTIFICATION_TYPE_ACCESS_CONTROL, 'Access Control', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Manual lock operation'),
    NotificationValue(2, 'Manual unlock operation'),
    NotificationValue(3, 'RF lock operation'),
    NotificationValue(4, 'RF unlock operation'),
    NotificationValue(5, 'Keypad lock operation' //
        // User Code Report (User Code Command Class V1)
        ),
    NotificationValue(6, 'Keypad unlock operation' //
        // User Code Report (User Code Command Class V1)
        ),
    NotificationValue(7, 'Manual not fully locked operation'),
    NotificationValue(8, 'RF not fully locked operation'),
    NotificationValue(9, 'Auto lock locked operation'),
    NotificationValue(10, 'Auto lock not fully locked operation'),
    NotificationValue(11, 'Lock jammed'),
    NotificationValue(12, 'All user codes deleted'),
    NotificationValue(13, 'Single user code deleted'),
    NotificationValue(14, 'New user code added'),
    NotificationValue(15, 'New user code not added due to duplicate code'),
    NotificationValue(16, 'Keypad temporary disabled'),
    NotificationValue(17, 'Keypad busy'),
    NotificationValue(
        18, 'New program code entered : unique code for lock configuration'),
    NotificationValue(19, 'Manually enter user access code exceeds code limit'),
    NotificationValue(20, 'Unlock by RF with invalid user code'),
    NotificationValue(21, 'Locked by RF with invalid user code'),
    NotificationValue(22, 'Window/door is open' //
        // Event parameter 1 byte: opening position:
        // - 0x00: Door/Window open in regular position
        // - 0x01: Door/Window open in tilt position
        // - 0x02..0xFF: Reserved
        ),
    NotificationValue(23, 'Window/door is closed'),
    NotificationValue(24, 'Window/door handle is open' //
        // Doors or more particularly windows handles can be in fixed Open/Close position (it does not automatically returns to the "closed" position).
        // This state variable can be used to advertise in which state is a fixed position windows/door handle.
        ),
    NotificationValue(25, 'Window/door handle is closed'),
    null, // 26
    null, // 27
    null, // 28
    null, // 29
    null, // 30
    null, // 31
    NotificationValue(32, 'Messaging User Code entered via keypad' //
        // Event parameter 2 bytes: User Code User Identifier (User Code Command Class, version 2)
        ),
    null, // 33
    null, // 34
    null, // 35
    null, // 36
    null, // 37
    null, // 38
    null, // 39
    null, // 40
    null, // 41
    null, // 42
    null, // 43
    null, // 44
    null, // 45
    null, // 46
    null, // 47
    null, // 48
    null, // 49
    null, // 50
    null, // 51
    null, // 52
    null, // 53
    null, // 54
    null, // 55
    null, // 56
    null, // 57
    null, // 58
    null, // 59
    null, // 60
    null, // 61
    null, // 62
    null, // 63
    NotificationValue(64, 'Barrier performing initialization process' //
        // Event Parameter 1 byte =
        // - 0x00: Process completed
        // - 0xFF: Performing process
        ),
    NotificationValue(
        65, 'Barrier operation (open/close) force has been exceeded'),
    NotificationValue(66,
        'Barrier motor has exceeded manufacturer\'s operational time limit' //
        // Event Parameter 1 byte =
        // - 0x00..0x7F: 0..127 seconds
        // - 0x80..0xFE: 1..127 minutes
        ),
    NotificationValue(
        67, 'Barrier operation has exceeded physical mechanical limits' //
        // For example : The barrier has opened past the opening limit.
        ),
    NotificationValue(68,
        'Barrier unable to perform requested operation due to UL requirements'),
    NotificationValue(69,
        'Barrier unattended operation has been disabled per UL requirements'),
    NotificationValue(70,
        'Barrier failed to perform requested operation, device malfunction'),
    NotificationValue(71, 'Barrier vacation mode' //
        // Event Parameter 1 byte =
        // - 0x00: Mode disabled
        // - 0xFF: Mode enabled
        ),
    NotificationValue(72, 'Barrier safety beam obstacle' //
        // Event Parameter 1 byte =
        // - 0x00: No obstruction
        // - 0xFF: Obstruction
        ),
    NotificationValue(73, 'Barrier sensor not detected / supervisory error' //
        // Event Parameter 1 byte =
        // - 0x00: Sensor not defined
        // - 0x01..0xFF: Sensor ID
        // Note : If the state is cleared, it means that the state is cleared for all issues Sensor IDs in the state change notifications
        ),
    NotificationValue(74, 'Barrier sensor low battery warning' //
        // Event Parameter 1 byte =
        // - 0x00: Sensor not defined
        // - 0x01..0xFF: Sensor ID
        // Note : If the state is cleared, it means that the state is cleared for all issues Sensor IDs in the state change notifications
        ),
    NotificationValue(75, 'Barrier detected short in wall station wires'),
    NotificationValue(76, 'Barrier associated with non Z-Wave remote control'),
    /* NotificationValue(254, Unknown event/state) */
  ],
);

const appliance = NotificationType(
  /* 0x0C */ NOTIFICATION_TYPE_APPLIANCE, 'Appliance', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Program started'),
    NotificationValue(2, 'Program in progress'),
    NotificationValue(3, 'Program completed'),
    NotificationValue(4, 'Replace main filter'),
    NotificationValue(5, 'Failure to set target temperature'),
    NotificationValue(6, 'Supplying water'),
    NotificationValue(7, 'Water supply failure'),
    NotificationValue(8, 'Boiling'),
    NotificationValue(9, 'Boiling failure'),
    NotificationValue(10, 'Washing'),
    NotificationValue(11, 'Washing failure'),
    NotificationValue(12, 'Rinsing'),
    NotificationValue(13, 'Rinsing failure'),
    NotificationValue(14, 'Draining'),
    NotificationValue(15, 'Draining failure'),
    NotificationValue(16, 'Spinning'),
    NotificationValue(17, 'Spinning failure'),
    NotificationValue(18, 'Drying'),
    NotificationValue(19, 'Drying failure'),
    NotificationValue(20, 'Fan failure'),
    NotificationValue(21, 'Compressor failure'),
    /* NotificationValue(254, Unknown event/state) */
  ],
);

const clock = NotificationType(
  /* 0x0B */ NOTIFICATION_TYPE_CLOCK, 'Clock', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Wake up alert'),
    NotificationValue(2, 'Timer ended'),
    NotificationValue(3, 'Time remaining' //
        // Event Parameter 3 bytes =
        // Byte 1 - 0x00..0xFF: 0..255 hours
        // Byte 2 - 0x00..0xFF: 0..255 minutes
        // Byte 3 - 0x00..0xFF: 0..255 seconds
        ),
    /* NotificationValue(254, Unknown event/state) */
  ],
);

const co2Alarm = NotificationType(
  /* 0x03 */ NOTIFICATION_TYPE_CO2_ALARM, 'CO2 Alarm', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Carbon dioxide detected (location provided)' //
        // Node Location Report
        // (Node Naming and Location Command Class)
        ),
    NotificationValue(2, 'Carbon dioxide detected'),
    NotificationValue(3, 'Carbon dioxide test' //
        // 0x01 = Test OK
        // 0x02 = Test Failed
        ),
    NotificationValue(4, 'Replacement required'),
    NotificationValue(5, 'Replacement required, End-of-life'),
    NotificationValue(6, 'Alarm silenced'),
    NotificationValue(7, 'Maintenance required, planned periodic inspection'),
    /* NotificationValue(254, Unknown event/state) */
  ],
);

const coAlarm = NotificationType(
  /* 0x02 */ NOTIFICATION_TYPE_CO_ALARM, 'CO Alarm', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Carbon monoxide detected (location provided)' //
        // Node Location Report
        // (Node Naming and Location Command Class)
        ),
    NotificationValue(2, 'Carbon monoxide detected'),
    NotificationValue(3, 'Carbon monoxide test' //
        // 0x01 = Test OK
        // 0x02 = Test Failed
        // The Carbon monoxide Test event may be issued by an alarm device to advertise that the test mode of the device has been activated.
        // The activation may be manual or via signaling.
        // A receiving application SHOULD NOT activate any alarms in response to this event.
        ),
    NotificationValue(4, 'Replacement required' //
        // This event may be issued by an alarm device to advertise that its physical components are no more reliable, e.g.
        // because of clogged filters.
        ),
    NotificationValue(5, 'Replacement required, End-of-life'),
    NotificationValue(6, 'Alarm silenced'),
    NotificationValue(7, 'Maintenance required, planned periodic inspection'),
    /* NotificationValue(254, Unknown event/state) */
  ],
);

const emergencyAlarm = NotificationType(
  /* 0x0A */ NOTIFICATION_TYPE_EMERGENCY_ALARM, 'Emergency Alarm', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Contact police'),
    NotificationValue(2, 'Contact fire service'),
    NotificationValue(3, 'Contact medical service'),
    NotificationValue(4, 'Panic alert' //
        // This event is used to indicate that a panic/emergency situation occured
        ),
    /* NotificationValue(254, Unknown event/state) */
  ],
);

const gasAlarm = NotificationType(
  /* 0x12 */ NOTIFICATION_TYPE_GAS_ALARM, 'Gas alarm', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Combustible gas detected (location provided)' //
        // Node Location Report (Node Naming and Location Command Class)
        ),
    NotificationValue(2, 'Combustible gas detected'),
    NotificationValue(3, 'Toxic gas detected (location provided)' //
        // Node Location Report
        // (Node Naming and Location Command Class)
        ),
    NotificationValue(4, 'Toxic gas detected'),
    NotificationValue(5, 'Gas alarm test'),
    NotificationValue(6, 'Replacement required'),
    /* NotificationValue(254, Unknown event/state) */
  ],
);

const heatAlarm = NotificationType(
  /* 0x04 */ NOTIFICATION_TYPE_HEAT_ALARM, 'Heat Alarm', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Overheat detected (location provided)' //
        // Node Location Report
        // (Node Naming and Location Command Class)
        ),
    NotificationValue(2, 'Overheat detected'),
    NotificationValue(3, 'Rapid temperature rise (location provided)' //
        // Node Location Report
        // (Node Naming and Location Command Class)
        ),
    NotificationValue(4, 'Rapid temperature rise'),
    NotificationValue(5, 'Under heat detected (location provided)' //
        // Node Location Report
        // (Node Naming and Location Command Class)
        ),
    NotificationValue(6, 'Under heat detected'),
    NotificationValue(7, 'Heat alarm test' //
        // This event may be issued by an alarm device to advertise that the local test function has been activated.
        ),
    NotificationValue(8, 'Replacement required, End-of-life' //
        // This event may be issued by an alarm device to advertise that the device has reached the end of its designed lifetime.
        // The device should no longer be used.
        ),
    NotificationValue(9, 'Alarm silenced' //
        // This event may be issued by an alarm device to advertise that the alarm has been silenced by a local user event.
        ),
    NotificationValue(10, 'Maintenance required, dust in device' //
        // This event may be issued by an alarm device to advertise that the device has detected dust in its sensor.
        // The device is not reliable until it has been serviced.
        ),
    NotificationValue(11, 'Maintenance required, planned periodic inspection' //
        // This event may be issued by an alarm device to advertise that the device has reached the end of a designed maintenance interval.
        // The device is should be serviced in order to stay reliable.
        ),
    NotificationValue(12, 'Rapid temperature fall (location provided)' //
        // Node Location Report
        // (Node Naming and Location Command Class)
        ),
    NotificationValue(13, 'Rapid temperature fall'),
    /* NotificationValue(254, Unknown event/state) */
  ],
);

const homeHealth = NotificationType(
  /* 0x0D */ NOTIFICATION_TYPE_HOME_HEALTH, 'Home Health', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Leaving bed'),
    NotificationValue(2, 'Sitting on bed'),
    NotificationValue(3, 'Lying on bed'),
    NotificationValue(4, 'Posture changed'),
    NotificationValue(5, 'Sitting on bed edge'),
    NotificationValue(6, 'Volatile Organic Compound level' //
        // Event Parameter 1 byte : Pollution level =
        // - 0x01: Clean
        // - 0x02: Slightly polluted
        // - 0x03: Moderately polluted
        // - 0x04: Highly polluted
        ),
    NotificationValue(7, 'Sleep apnea detected' //
        // Event Parameter 1 byte : breath level =
        // - 0x01: Low breath
        // - 0x02: No breath at all
        ),
    NotificationValue(8, 'Sleep stage 0 detected (Dreaming/REM)' //
        // The sensors detects that the person is awake when this state variable returns to idle.
        ),
    NotificationValue(9, 'Sleep stage 1 detected (Light sleep, non-REM 1)' //
        // The sensors detects that the person is awake when this state variable returns to idle.
        ),
    NotificationValue(10, 'Sleep stage 2 detected (Medium sleep, non-REM 2)' //
        // The sensors detects that the person is awake when this state variable returns to idle.
        ),
    NotificationValue(11, 'Sleep stage 3 detected (Deep sleep, non-REM 3)' //
        // The sensors detects that the person is awake when this state variable returns to idle.
        ),
    NotificationValue(12, 'Fall detected ' //
        // This event is used to indicate that a person fall has been detected and medical help may be needed
        ),
    /* NotificationValue(254, Unknown event/state) */
  ],
);

const homeMonitoring = NotificationType(
  /* 0x16 */ NOTIFICATION_TYPE_HOME_MONITORING, 'Home monitoring', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Home occupied (location provided)' //
        // Node Location Report
        // (Node Naming and Location Command Class)
        // This state is used to indicate that a sensor detects that the home is currently occupied
        ),
    NotificationValue(2, 'Home occupied' //
        // This state is used to indicate that a sensor detects that the home is currently occupied
        ),
  ],
);

const homeSecurity = NotificationType(
  /* 0x07 */ NOTIFICATION_TYPE_HOME_SECURITY, 'Home Security', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Intrusion (location provided)' //
        // Node Location Report
        // (Node Naming and Location Command Class)
        ),
    NotificationValue(2, 'Intrusion'),
    NotificationValue(3, 'Tampering, product cover removed'),
    NotificationValue(4, 'Tampering, invalid code'),
    NotificationValue(5, 'Glass breakage (location provided)' //
        // Node Location Report
        // (Node Naming and Location Command Class)
        ),
    NotificationValue(6, 'Glass breakage'),
    NotificationValue(7, 'Motion detection (location provided)' //
        // Node Location Report
        // (Node Naming and Location Command Class)
        ),
    NotificationValue(8, 'Motion detection'),
    NotificationValue(9, 'Tampering, product moved'),
    NotificationValue(10, 'Impact detected' //
        // This event indicates that the node has detected an excessive amount of pressure or that an impact has occurred on the product itself.
        ),
    NotificationValue(11, 'Magnetic field interference detected' //
        // This state is used to indicate that magnetic field disturbance have been detected and the product functionality may not work reliably
        ),
    NotificationValue(12, 'RF Jamming detected' //
        // 1-byte value representing the measured RSSI over a period of time spanning between 10s and 60s
        // The value MUST be encoded using signed representation
        // This event can be issued if the node has detected a raise in the background RSSI level.
        ),
    /* NotificationValue(254, Unknown event/state) */
  ],
);

const irrigation = NotificationType(
  /* 0x11 */ NOTIFICATION_TYPE_IRRIGATION, 'Irrigation', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Schedule started' //
        // Event Parameter 1 = <Schedule ID>
        ),
    NotificationValue(2, 'Schedule finished' //
        // Event Parameter 1 = <Schedule ID>
        ),
    NotificationValue(3, 'Valve table run started' //
        // Event Parameter 1 = <Valve table ID>
        ),
    NotificationValue(4, 'Valve table run finished' //
        // Event Parameter 1 = <Valve table ID>
        ),
    NotificationValue(5, 'Device is not configured'),
    /* NotificationValue(254, Unknown event/state) */
  ],
);

const lightSensor = NotificationType(
  /* 0x14 */ NOTIFICATION_TYPE_LIGHT_SENSOR, 'Light sensor', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Light detected'),
    NotificationValue(2, 'Light color transition detected'),
  ],
);

const pestControl = NotificationType(
  /* 0x13 */ NOTIFICATION_TYPE_PEST_CONTROL, 'Pest Control', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Trap armed (location provided)' //
        // Node Location Report
        // (Node Naming and Location Command Class)
        // The state is used to indicate that the trap is armed and potentially dangerous for humans (e.g.
        // risk of electric shock, finger being caught)
        ),
    NotificationValue(2, 'Trap armed' //
        // The state is used to indicate that the trap is armed and potentially dangerous for humans (e.g.
        // risk of electric shock, finger being caught)
        ),
    NotificationValue(3, 'Trap re-arm required (location provided)' //
        // Node Location Report
        // (Node Naming and Location Command Class)
        // This state is used to indicate that the trap requires to be re-armed or re-engage before being operational again (e.g.
        // remove rodent remains, mechanical re-engagement)
        ),
    NotificationValue(4, 'Trap re-arm required' //
        // This state is used to indicate that the trap requires to be re-armed or re-engage before being operational again (e.g.
        // remove rodent remains, mechanical re-engagement)
        ),
    NotificationValue(5, 'Pest detected (location provided)' //
        // Node Location Report
        // (Node Naming and Location Command Class)
        // This event may be issued by a device to advertise that it detected an undesirable animal, but could not exterminate it
        ),
    NotificationValue(6, 'Pest detected' //
        // This event may be issued by a device to advertise that it detected an undesirable animal, but could not exterminate it
        ),
    NotificationValue(7, 'Pest exterminated (location provided)' //
        // Node Location Report
        // (Node Naming and Location Command Class)
        // This event may be issued by a device to advertise that it exterminated an undesirable animal
        ),
    NotificationValue(8, 'Pest exterminated' //
        // This event may be issued by a device to advertise that it exterminated an undesirable animal
        ),
    /* NotificationValue(254, Unknown event/state) */
  ],
);

const powerManagement = NotificationType(
  /* 0x08 */ NOTIFICATION_TYPE_POWER_MANAGEMENT, 'Power Management', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Power has been applied'),
    NotificationValue(2, 'AC mains disconnected'),
    NotificationValue(3, 'AC mains re-connected'),
    NotificationValue(4, 'Surge detected'),
    NotificationValue(5, 'Voltage drop/drift'),
    NotificationValue(6, 'Over-current detected'),
    NotificationValue(7, 'Over-voltage detected'),
    NotificationValue(8, 'Over-load detected'),
    NotificationValue(9, 'Load error'),
    NotificationValue(10, 'Replace battery soon'),
    NotificationValue(11, 'Replace battery now'),
    NotificationValue(12, 'Battery is charging'),
    NotificationValue(13, 'Battery is fully charged'),
    NotificationValue(14, 'Charge battery soon'),
    NotificationValue(15, 'Charge battery now'),
    NotificationValue(16, 'Back-up battery is low'),
    NotificationValue(17, 'Battery fluid is low'),
    NotificationValue(18, 'Back-up battery disconnected'),
    /* NotificationValue(254, Unknown event/state) */
  ],
);

const requestPending = NotificationType(
  /* 0xFF */ NOTIFICATION_TYPE_REQUEST_PENDING,
  'Request pending notification', //
  [
    NotificationValue(0, ''),
  ],
);

const siren = NotificationType(
  /* 0x0E */ NOTIFICATION_TYPE_SIREN, 'Siren', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Siren active' //
        // This Event indicates that a siren or sound within a device is active.
        // This may be a Siren within a smoke sensor that goes active when smoke is detected.
        // Or a beeping within a power switch to indicate over-current detected.
        // The siren may switch Off automatically or based on user interaction.
        // This can be reported through Notification Type Siren and Event 0x00.
        ),
    /* NotificationValue(254, Unknown event/state) */
  ],
);

const smokeAlarm = NotificationType(
  /* 0x01 */ NOTIFICATION_TYPE_SMOKE_ALARM, 'Smoke Alarm', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Smoke detected (location provided)' //
        // Node Location Report
        // (Node Naming and Location Command Class)
        ),
    NotificationValue(2, 'Smoke detected'),
    NotificationValue(3, 'Smoke alarm test'),
    NotificationValue(4, 'Replacement required' //
        // This event may be issued by an alarm device to advertise that its physical components are no more reliable, e.g.
        // because of clogged filters.
        ),
    NotificationValue(5, 'Replacement required, End-of-life' //
        // This event may be issued by an alarm device to advertise that the device has reached the end of its designed lifetime.
        // The device should no longer be used.
        ),
    NotificationValue(6, 'Alarm silenced' //
        // This event may be issued by an alarm device to advertise that the alarm has been silenced by a local user event.
        ),
    NotificationValue(7, 'Maintenance required, planned periodic inspection' //
        // This event may be issued by an alarm device to advertise that the device has reached the end of a designed maintenance interval.
        // The device is should be serviced in order to stay reliable.
        ),
    NotificationValue(8, 'Maintenance required, dust in device' //
        // This event may be issued by an alarm device to advertise that the device has detected dust in its sensor.
        // The device is not reliable until it has been serviced.
        ),
    /* NotificationValue(254, Unknown event/state) */
  ],
);

const system = NotificationType(
  /* 0x09 */ NOTIFICATION_TYPE_SYSTEM, 'System', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'System hardware failure'),
    NotificationValue(2, 'System software failure'),
    NotificationValue(3,
        'System hardware failure (manufacturer proprietary failure code provided)' //
        // Manufacturer proprietary system failure codes.
        // Cannot be listed in NIF. Codes MUST be described in product manual.
        ),
    NotificationValue(4,
        'System software failure (manufacturer proprietary failure code provided)' //
        // Manufacturer proprietary system failure codes.
        // Cannot be listed in NIF. Codes MUST be described in product manual.
        ),
    NotificationValue(5, 'Heartbeat' //
        // The Heartbeat event may be issued by a device to advertise that the device is still alive or to notify its presence.
        ),
    NotificationValue(6, 'Tampering, product cover removed' //
        // The Product covering removed event may be issued by a device to advertise that its physical enclosure has been compromised.
        // This may, for instance, indicate a security threat or that a user is trying to modify a metering device.
        // Note that a similar event is defined for the Home Security Notification Type.
        // If a device implements other events for the Home Security Notification Type, the device should issue the Tampering event defined for the Home Security Notification Type.
        ),
    NotificationValue(7, 'Emergency shutoff'),
    null, // 8
    NotificationValue(9, 'Digital input high state' //
        // This state represents a generic digital input has voltage applied (high state).
        ),
    NotificationValue(10, 'Digital input low state' //
        // This state represents a generic digital input that is connected to the ground (or zero voltage applied)
        ),
    NotificationValue(11, 'Digital input open' //
        // This state represents a generic digital input that is left open (not connected to anything)
        ),
    /* NotificationValue(254, Unknown event/state) */
  ],
);

const waterAlarm = NotificationType(
  /* 0x05 */ NOTIFICATION_TYPE_WATER_ALARM, 'Water Alarm', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Water leak detected (location provided)' //
        // Node Location Report
        // (Node Naming and Location Command Class)
        ),
    NotificationValue(2, 'Water leak detected'),
    NotificationValue(3, 'Water level dropped (location provided)'),
    NotificationValue(4, 'Water level dropped'),
    NotificationValue(5, 'Replace water filter'),
    NotificationValue(6, 'Water flow alarm' //
        // Event Parameter 1 byte =
        // - 0x01: No data
        // - 0x02: Below low threshold
        // - 0x03: Above high threshold
        // - 0x04: Max
        ),
    NotificationValue(7, 'Water pressure alarm' //
        // Event Parameter 1 byte =
        // - 0x01: No data
        // - 0x02: Below low threshold
        // - 0x03: Above high threshold
        // - 0x04: Max
        ),
    NotificationValue(8, 'Water temperature alarm' //
        // Event Parameter 1 byte =
        // - 0x01: No data
        // - 0x02: Below low threshold
        // - 0x03: Above high threshold
        ),
    NotificationValue(9, 'Water level alarm' //
        // Event Parameter 1 byte =
        // - 0x01: No data
        // - 0x02: Below low threshold
        // - 0x03: Above high threshold
        ),
    NotificationValue(10, 'Sump pump active'),
    NotificationValue(11, 'Sump pump failure' //
        // This state may be used to indicate that the pump does not function as expected or is disconnected
        ),
    /* NotificationValue(254, Unknown event/state) */
  ],
);

const waterQualityMonitoring = NotificationType(
  /* 0x15 */ NOTIFICATION_TYPE_WATER_QUALITY_MONITORING,
  'Water Quality Monitoring', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Chlorine alarm' //
        // Event Parameter 1 byte =
        // - 0x01: Below low threshold
        // - 0x02: Above high threshold
        ),
    NotificationValue(2, 'Acidity (pH) alarm' //
        // Event Parameter 1 byte =
        // - 0x01: Below low threshold
        // - 0x02: Above high threshold
        // - 0x03: Decreasing pH
        // - 0x04: Increasing pH
        ),
    NotificationValue(3, 'Water Oxidation alarm' //
        // Event Parameter 1 byte =
        // - 0x01: Below low threshold
        // - 0x02: Above high threshold
        ),
    NotificationValue(4, 'Chlorine empty '),
    NotificationValue(5, 'Acidity (pH) empty '),
    NotificationValue(6, 'Waterflow measuring station shortage detected'),
    NotificationValue(7, 'Waterflow clear water shortage detected'),
    NotificationValue(8, 'Disinfection system error detected' //
        // Event Parameter 1 byte bitmask=
        // - bits 0..3: represent System 1..4 disorder detected
        // - bits 4..7: represent System 1..4 salt shortage
        // This state is used to inform that the disinfection system is not functioning properly.
        ),
    NotificationValue(9, 'Filter cleaning ongoing' //
        // Event Parameter 1 byte =
        // 0x01..0xFF: Filter 1..255 cleaning
        ),
    NotificationValue(10, 'Heating operation ongoing'),
    NotificationValue(11, 'Filter pump operation ongoing'),
    NotificationValue(12, 'Freshwater operation ongoing'),
    NotificationValue(13, 'Dry protection operation active'),
    NotificationValue(14, 'Water tank is empty'),
    NotificationValue(15, 'Water tank level is unknown'),
    NotificationValue(16, 'Water tank is full'),
    NotificationValue(17, 'Collective disorder'),
  ],
);

const waterValve = NotificationType(
  /* 0x0F */ NOTIFICATION_TYPE_WATER_VALVE, 'Water Valve', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Valve operation' //
        // Event Parameter 1 byte =
        // - 0x00: Off / Closed (valve does not let the water run through)
        // - 0x01: On / Open (valve lets the water run through)
        ),
    NotificationValue(2, 'Master valve operation' //
        // Event Parameter 1 byte =
        // - 0x00: Off / Closed (valve does not let the water run through)
        // - 0x01: On / Open (valve lets the water run through)
        ),
    NotificationValue(3, 'Valve short circuit'),
    NotificationValue(4, 'Master valve short circuit'),
    NotificationValue(5, 'Valve current alarm' //
        // Event Parameter 1 byte =
        // - 0x01: No data
        // - 0x02: Below low threshold
        // - 0x03: Above high threshold
        // - 0x04: Max
        ),
    NotificationValue(6, 'Master valve current alarm' //
        // Event Parameter 1 byte =
        // - 0x01: No data
        // - 0x02: Below low threshold
        // - 0x03: Above high threshold
        // - 0x04: Max
        ),
    /* NotificationValue(254, Unknown event/state) */
  ],
);

const weatherAlarm = NotificationType(
  /* 0x10 */ NOTIFICATION_TYPE_WEATHER_ALARM, 'Weather Alarm', //
  [
    NotificationValue(0, 'State idle' //
        // Notification value for the state variable going to idle. (V5)
        ),
    NotificationValue(1, 'Rain alarm'),
    NotificationValue(2, 'Moisture alarm'),
    NotificationValue(3, 'Freeze alarm' //
        // The Freeze alarm state is used to indicate that the outside temperature is negative and there is an icing risk
        ),
    /* NotificationValue(254, Unknown event/state) */
  ],
);
