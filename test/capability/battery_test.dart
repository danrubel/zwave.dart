import 'dart:async';

import 'package:test/test.dart';
import 'package:zwave/capability/battery.dart';
import 'package:zwave/node/zw_node.dart';
import 'package:zwave/zw_exception.dart';

import '../zw_request_test.dart';

main() {
  new BatteryTest().init();
}

class BatteryTest extends ZwRequestTest {
  TestBatteryNode node;

  @override
  void defineTests() {
    setUp(() {
      node = new TestBatteryNode(7);
      manager.add(node);
    });

    test('init', () {
      expect(node.battery, isNull);
    });

    test('request', () async {
      expectingRequestResponse(batteryGetRequest, batteryReport1);

      final result = await node.requestBattery();

      expect(result.percent, 58);
      expect(result.lowBatteryWarning, isFalse);
      expect(node.battery, result);
    });

    test('delayed reponse', () async {
      node.battery = null;
      expectingRequestSimpleResponse(batteryGetRequest);
      final future = node.requestBattery();

      // Assert no report
      try {
        await future.timeout(const Duration(milliseconds: 2));
        fail('expected TimeoutException');
      } on TimeoutException catch (_) {
        // expected
      }
      expect(node.battery, isNull);

      // Send delayed response as unsolicited request
      manager.dispatch(batteryReport2);
      BatteryReport result;
      try {
        result = await future;
      } on ZwException catch (e) {
        print('>>> $e');
      }
      expectComplete();
      expect(node.battery, isNotNull);
      expect(result.percent, 47);
      expect(node.battery, result);
    });

    group('report', () {
      test('30 %', () {
        final data = [1, 9, 0, 4, 0, 16, 3, 128, 3, 30, 124];
        final report = new BatteryReport(data);
        expect(report.lowBatteryWarning, isFalse);
        expect(report.percent, 30);
      });

      test('low', () {
        final data = [1, 9, 0, 4, 0, 16, 3, 128, 3, 0xFF, 124];
        final report = new BatteryReport(data);
        expect(report.lowBatteryWarning, isTrue);
        expect(report.percent, 0);
      });
    });
  }
}

const batteryGetRequest = const <int>[
  0x01, // SOF
  0x08, // length excluding SOF and checksum
  0x00, // request
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x07, // source node 7
  0x02, // command length
  0x80, // COMMAND_CLASS_BATTERY
  0x02, // BATTERY_GET
  0x25, // transmit options
  0x46, // checksum
];
const batteryReport1 = const <int>[
  0x01, // SOF
  0x09, // length excluding SOF and checksum
  0x01, // response
  0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
  0x00, // rxStatus
  0x07, // source node 7
  0x03, // command length
  0x80, // COMMAND_CLASS_BATTERY
  0x03, // BATTERY_REPORT
  0x3A, // battery 58 %
  0x7C, // checksum
];
const batteryReport2 = const <int>[
  0x01, // SOF
  0x09, // length excluding SOF and checksum
  0x00, // request
  0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
  0x00, // rxStatus
  0x07, // source node 7
  0x03, // command length
  0x80, // COMMAND_CLASS_BATTERY
  0x03, // BATTERY_REPORT
  0x2F, // battery 47 %
  0x7C, // checksum
];

class TestBatteryNode extends ZwNode with Battery {
  TestBatteryNode(int id) : super(id);
}
