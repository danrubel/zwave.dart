import 'package:zwave/command/zw_send_data.dart';
import 'package:test/test.dart';

main() {
  test('setBinarySwitch', () {
    final cmd = new TestSendData(9, [37, 1, 0]);
    expect(cmd.data, equals(<int>[1, 9, 0, 19, 9, 3, 37, 1, 0, 37, 238]));
  });
}

class TestSendData extends ZwSendData<List<int>> {
  @override
  final List<int> cmdData;

  final List<int> expectedResponse;

  TestSendData(int nodeId, this.cmdData, {this.expectedResponse})
      : super(nodeId);

  @override
  Duration get responseTimeout => const Duration(milliseconds: 20);

  @override
  processResponse(List<int> response) {
    if (expectedResponse != null)
      expect(response, orderedEquals(expectedResponse));
    return response;
  }
}
