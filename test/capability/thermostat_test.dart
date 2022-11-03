import 'package:test/test.dart';
import 'package:zwave/capability/thermostat.dart';
import 'package:zwave/node/zw_node.dart';

import '../zw_request_test.dart';

main() {
  ThermostatTest().init();
}

class ThermostatTest extends ZwRequestTest {
  late ThermostatNode node;

  @override
  void defineTests() {
    setUp(() {
      node = ThermostatNode(13);
      manager.add(node);
    });

    test('init', () {
      expect(node.fanMode, isNull);
      expect(node.fanState, isNull);
      expect(node.mode, isNull);
      expect(node.operatingState, isNull);
    });

    group('fan mode', () {
      test('request', () async {
        expectingRequestResult(fanModeRequest, fanModeResult);
        ThermostatFanModeReport result = await node.requestFanMode();
        expect(result.isOff, isFalse);
        expect(result.isOn, isTrue);
        expect(result.mode, 0x01);
        expect(node.fanMode, result);
      });
      test('supported', () async {
        expectingRequestResult(
            fanModesSupportedRequest, fanModesSupportedResult);
        ThermostatFanModeSupportedReport result =
            await node.requestFanModeSupported();
        expect(result, isNotNull);
      });
    });

    group('fan state', () {
      test('request', () async {
        expectingRequestResult(fanStateRequest, fanStateReport);
        ThermostatFanStateReport result = await node.requestFanState();
        expect(result.state, 0x01);
        expect(node.fanState, result);
      });
    });

    group('mode', () {
      test('request', () async {
        expectingRequestResult(modeRequest, modeResult);
        ThermostatModeReport result = await node.requestMode();
        expect(result.mode, ThermostatMode.heat);
        expect(node.mode, result);
      });
    });

    group('operating state', () {
      test('request', () async {
        expectingRequestResult(operatingStateRequest, operatingStateReport);
        ThermostatOperatingStateReport result =
            await node.requestOperatingState();
        expect(result.state, ThermostatOperatingState.idle);
        expect(node.operatingState, result);
      });
    });

    group('set point', () {
      test('request', () async {
        expectingRequestResult(setPointRequest, setPointReport);
        ThermostatSetPointReport result =
            await node.requestSetPoint(ThermostatSetPointType.heating);
        expect(result.setPointType, 1);
        expect(result.precision, 0);
        expect(result.scale, ThermostatSetPointScale.fahrenheit);
        expect(result.valueSize, 1);
        expect(result.value, 70); // fahrenheit
        expect((result.temperature * 10).round() / 10, 21.1); // celsius
        expect(node.heatingSetPoint, result);
      });
    });
  }
}

class ThermostatNode extends ZwNode with Thermostat {
  ThermostatNode(int id) : super(id);
}

const fanModeRequest = [
  0x01, // SOF
  0x08, // length excluding SOF and checksum
  0x00, // request
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x0D, // source node 13
  0x02, // command length
  0x44, // COMMAND_CLASS_THERMOSTAT_FAN_MODE
  0x02, // THERMOSTAT_FAN_MODE_GET
  0x25, //
  0x88, // checksum
];
const fanModeResult = [
  0x01, // SOF
  0x09, // length excluding SOF and checksum
  0x00, // request
  0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
  0x00, // rxStatus
  0x0D, // source node 13
  0x03, // command length
  0x44, // COMMAND_CLASS_THERMOSTAT_FAN_MODE
  0x03, // THERMOSTAT_FAN_MODE_REPORT
  0x01, // fan low auto
  0xBA, // checksum
];
const fanModesSupportedRequest = [
  0x01, // SOF
  0x08, // length excluding SOF and checksum
  0x00, // request
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x0D, // source node 13
  0x02, // command length
  0x44, // COMMAND_CLASS_THERMOSTAT_FAN_MODE
  0x04, // THERMOSTAT_FAN_MODE_SUPPORTED_GET
  0x25, // transmit options
  0x8E, // checksum
];
const fanModesSupportedResult = [
  0x01, // SOF
  0x09, // length excluding SOF and checksum
  0x00, // request
  0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
  0x00, // rxStatus
  0x0D, // source node 13
  0x03, // command length
  0x44, // COMMAND_CLASS_THERMOSTAT_FAN_MODE
  0x05, // THERMOSTAT_FAN_MODE_SUPPORTED_REPORT
  0x03, // 0000 0011 - idle, heat
  0xBE, // checksum
];
const fanStateRequest = [
  0x01, // SOF
  0x08, // length excluding SOF and checksum
  0x00, // request
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x0D, // source node 13
  0x02, // command length
  0x45, //
  0x02, //
  0x25, //
  0x89, // checksum
];
const fanStateReport = [
  0x01, // SOF
  0x09, // length excluding SOF and checksum
  0x00, // request
  0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
  0x00, // rxStatus
  0x0D, // source node 13
  0x03, // command length
  0x45, //
  0x03, //
  0x01, //
  0xBB, // checksum
];
const modeRequest = [
  0x01, // SOF
  0x08, // length excluding SOF and checksum
  0x00, // request
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x0D, // source node 13
  0x02, // command length
  0x40, // COMMAND_CLASS_THERMOSTAT_MODE
  0x02, // THERMOSTAT_MODE_GET
  0x25, // transmit options
  0x8C, // checksum
];
const modeResult = [
  0x01, // SOF
  0x09, // length excluding SOF and checksum
  0x00, // request
  0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
  0x00, // rxStatus
  0x0D, // source node 13
  0x03, // command length
  0x40, // COMMAND_CLASS_THERMOSTAT_MODE
  0x03, // THERMOSTAT_MODE_REPORT
  0x01, // heat
  0xBE, // checksum
];
const operatingStateRequest = [
  0x01, // SOF
  0x08, // length excluding SOF and checksum
  0x00, // request
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x0D, // source node 13
  0x02, // command length
  0x42, // COMMAND_CLASS_THERMOSTAT_OPERATING_STATE
  0x02, // THERMOSTAT_OPERATING_STATE_GET
  0x25, // transmit options
  0x8E, // checksum
];
const operatingStateReport = [
  0x01, // SOF
  0x09, // length excluding SOF and checksum
  0x00, // request
  0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
  0x00, // rxStatus
  0x0D, // source node 13
  0x03, // command length
  0x42, // COMMAND_CLASS_THERMOSTAT_OPERATING_STATE
  0x03, // THERMOSTAT_OPERATING_STATE_REPORT
  0x00, // idle
  0xBD, // checksum
];
const setPointRequest = [
  0x01, // SOF
  0x09, // length 9 excluding SOF and checksum
  0x00, // request
  0x13, // FUNC_ID_ZW_SEND_DATA
  0x0D, // source node 13
  0x03, // command length 3
  0x43, // COMMAND_CLASS_THERMOSTAT_SETPOINT
  0x02, // THERMOSTAT_SETPOINT_GET
  0x01, // Heating set point
  0x25, // transmit options: explore, auto route, ack
  0x8E, // checksum
];
const setPointReport = [
  0x01, // SOF
  0x0B, // length 11 excluding SOF and checksum
  0x00, // request
  0x04, // FUNC_ID_APPLICATION_COMMAND_HANDLER
  0x08, // rxStatus
  0x0D, // source node 13
  0x05, // command length 5
  0x43, // COMMAND_CLASS_THERMOSTAT_SETPOINT
  0x03, // THERMOSTAT_SETPOINT_REPORT
  0x01, // set point type - 0x01 = heating, 0x02 = cooling, ...
  0x09, // precision = 0, scale = 1 (fahrenheit), size = 1
  0x46, // value = 70 degrees fahrenheit
  0xFE, // checksum
];
