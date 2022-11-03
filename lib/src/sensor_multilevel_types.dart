// Multilevel sensor type constants
// Import zwave/lib/message_consts.dart rather than directly importing this file

import 'package:zwave/src/sensor_multilevel_types.g.dart';
import 'package:zwave/zw_exception.dart';

export 'package:zwave/src/sensor_multilevel_types.g.dart';

/// [SensorMultilevelType] represents the capabilities in a multilevel sensor.
class SensorMultilevelType {
  /// The "sensorType" field value associated with this type
  /// which is also the index of this object in the [sensorMultilevelTypes] list
  final int sensorTypeNum;

  String get sensorTypeNumHex =>
      '0x${sensorTypeNum.toRadixString(16).padLeft(2, '0').toUpperCase()}';

  /// Descriptions for each of the sensor value scale types
  final List<String> scaleTypeDescriptions;

  /// A description of this sensor type
  final String description;

  /// Instantiate a new sensor type constant
  const SensorMultilevelType(
      {required this.sensorTypeNum,
      required this.scaleTypeDescriptions,
      required this.description});

  /// Return the sensor type associated with the given [sensorTypeNum].
  /// Throw a [ZwException] if [sensorTypeNum] is out of bounds.
  factory SensorMultilevelType.forTypeNum(int sensorTypeNum) {
    if (sensorTypeNum < 1 || sensorTypeNum >= sensorMultilevelTypes.length) {
      throw ZwException('Invalid SensorMultilevelType typeNum: $sensorTypeNum');
    }
    return sensorMultilevelTypes[sensorTypeNum]!;
  }

  /// Return a description for the scale type.
  /// Throw a [ZwException] if [scaleTypeNum] is out of bounds.
  String scaleTypeDescriptionFor(int scaleTypeNum) {
    if (scaleTypeNum < 0 || scaleTypeNum >= scaleTypeDescriptions.length) {
      throw ZwException(
          'Invalid SensorMultilevelType $sensorTypeNum scaleTypeNum: $scaleTypeNum');
    }
    return scaleTypeDescriptions[scaleTypeNum];
  }

  int get byteNum => ((sensorTypeNum - 1) / 8).floor() + 1;

  int get bitNum => (sensorTypeNum - 1) % 8;

  int get bitMask => 0x01 << bitNum;

  String get bitMaskHex =>
      '0x${bitMask.toRadixString(16).padLeft(2, '0').toUpperCase()}';
}
