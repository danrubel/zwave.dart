import 'package:zwave/capability/zw_node_mixin.dart';
import 'package:zwave/report/basic_report.dart';

/// A node that supports COMMAND_CLASS_BASIC
abstract class Basic implements ZwNodeMixin {
  int? value;

  @override
  void handleBasicReport(BasicReport report) {
    value = report.value;
  }

  @override
  void handleBasicSet(BasicReport report) {
    value = report.value;
  }
}
