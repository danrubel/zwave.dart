import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:zwave/capability/notification_report_handler.dart';
import 'package:zwave/report/notification_report.dart';
import 'package:zwave/util/packet_to_source.dart';
import 'package:zwave/node/zw_node.dart';

void main([List<String>? args]) {
  var responseData = <int>[1, 15, 0, 4, 0, 32, 9, 113, 5, 0, 0, 0, 255, 7, 0, 0, 81];
  print('Response: $responseData');
  print(packetToSource(responseData));

  responseData = [1, 15, 0, 4, 0, 32, 9, 113, 5, 0, 3, 0, 255, 7, 3, 0, 81];
  print('Response: $responseData');
  print(packetToSource(responseData));

  test('handleNotificationReport', () {
    final node = TestNotificationNode(32);
    node.dispatchApplicationCommand(responseData);
    expect(node.notificationHandled, isTrue);
  });
}

class TestNotificationNode extends ZwNode with NotificationReportHandler {
  bool notificationHandled = false;

  TestNotificationNode(int id) : super(id);

  @override
  void handleHomeSecurityNotification(NotificationReport report) {
    if (report.notification == 3) {
      notificationHandled = true;
      return;
    }
    return super.handleHomeSecurityNotification(report);
  }
}
