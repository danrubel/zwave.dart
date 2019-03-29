import 'package:zwave/report/zw_command_class_report.dart';

/// [MeterReport] decodes the
/// COMMAND_CLASS_SCENE_ACTIVATION, SCENE_ACTIVATION_SET message
class SceneActivationSet extends ZwCommandClassReport {
  SceneActivationSet(List<int> data) : super(data);

  int get sceneId => data[9];

  /// The duration from current state to new state.
  /// 0x00 = immediately
  /// 0x01 - 0x7F = duration of 1 second to 127 seconds
  /// 0x80 - 0xFE = duration of 1 minute to 127 minutes
  /// 0xFF = duration specified elsewhere
  int get dimmingDuration => data[10];
}