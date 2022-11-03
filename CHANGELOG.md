# Changelog

## 0.11.0
* migrate to null safety
* rename `build_lib` to `build_native`
* update build script to work on Windows
* add Thermostat heating/coolingSetPoint
* add ThermostatSetPointReport
* add ThermostateMode, ThermostatSetPointType, ThermostatSetPointScale consts
* decode zwave packet improvements
* add support for SENSOR_MULTILEVEL_SUPPORTED_SENSOR_REPORT
* deprecate AirTemperature, Humidity, and Power mixins in favor of SensorMultilevel mixin
* add support for COMMAND_CLASS_NOTIFICATION NOTIFICATION_REPORT

## 0.10.0
* remove const COMMAND_CLASS_ALARM because it has been replaced by COMMAND_CLASS_NOTIFICATION
* replace zwave cli with zw_check.dart for checking the connection to the Z-Wave controller
* add app for decoding and printing zwave packets
* move native zwave port operations to separate isolate
* add security S0 nonce management

## 0.9.1
* update minimum Dart SDK version to 2.3.0
* move native code to a separate isolate

## 0.9.0
* Overhaul for Dart2
* Rewrote native to remove dependency on Open ZWave binary
* Restructured to allow composing nodes based on capability

## 0.8.0
* last Dart 1 compatible version
* add node group/association accessor, add node, remove node
* add Device.requestAllConfigParams, Device.get/setConfigParam
* use Device.setConfigParam
    instead of the ZWave.device "configuration" parameter
* track last time that each value changes
* add orElse named argument to Device.valueByIndex
* add zwave command line application 
  for querying and updating the ZWave devices

## 0.7.0
* implement addDevice and removeDevice methods
* implement RawValue
* partially implement ScheduleValue
* add ZWave.heal to update node routing tables
* add Device.neighborIds indicating which other devices a device can directly communicate with

## 0.6.0
* enhance ZWave.device to optionally set device name and configuration
* add ZWave.pollInterval and Value.pollIntensity accessors
* add Value help text and Device.valueByIndex accessors
* new NodeEvent and SceneEvent subclasses of Notification

## 0.5.0
* add Value.index to differentiate between values with the same label
* update Device.value(...) to search userValues first then all values
* enhance toString to include device name and value label
* fix Value.min and max
* add support for setting short and byte values

## 0.3.0
* update generate to include comments in src/zwave_g.dart
* new ZWave deviceSummary convenience method for listing device info
* add device and value lookup convenience methods
* add Device update method for updating all a device's information
* add Device onNotification event stream
* add support for setting int value
* rename ZWave.deviceSummary() --> summary() and add Device.summary()
* add Node.name and Device.label getters and setters

## 0.2.0
* add writeConfig to save network configuration
* add setters to bool and list values
* add onChange notification stream
* add value readOnly and writeOnly accessors
* parameterize the Value class and its methods
* add userPath for specifying user data directory
* add support for DoubleValue

## 0.1.4
* add value label accessor
* add value genre and device userValues accessors
* improve docs

## 0.1.3
* add device accessors for product and manufacturer information
* write network config to file on shutdown
* cleanup generated code and usages

## 0.1.2
* build device value list from notifications

## 0.1.1
* initialize Open Z-Wave library
* connect to Z-Wave controller
* build device list from notifications
