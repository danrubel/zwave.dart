import 'package:test/test.dart';
import 'package:zwave/capability/thermostat.dart';
import 'package:zwave/node/zw_node.dart';

import '../zw_request_test.dart';

main() {
  new ThermostatTest().init();
}

class ThermostatTest extends ZwRequestTest {
  ThermostatNode node;

  @override
  void defineTests() {
    setUp(() {
      node = new ThermostatNode(13);
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
        expect(result.mode, 0x01);
        expect(node.mode, result);
      });
    });

    group('operating state', () {
      test('request', () async {
        expectingRequestResult(operatingStateRequest, operatingStateReport);
        ThermostatOperatingStateReport result =
            await node.requestOperatingState();
        expect(result.state, 0x00);
        expect(node.operatingState, result);
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
