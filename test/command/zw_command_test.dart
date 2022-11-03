import 'package:zwave/command/zw_command.dart';
import 'package:test/test.dart';

main() {
  test('functId', () {
    final command = TestCommand(0x07, null);
    expect(
        command.data,
        equals(const <int>[
          0x01, // start of frame
          0x03, // length
          0x00, // request
          0x07, // functId
          0xFB, // checksum
        ]));
  });

  test('functParam', () {
    final command = TestCommand(0x07, [0x10, 0x20]);
    expect(
        command.data,
        equals(const <int>[
          0x01, // start of frame
          0x05, // length
          0x00, // request
          0x07, // functId
          0x10,
          0x20,
          0xCD, // checksum
        ]));
  });

  test('actual', () {
    final command = TestCommand(21, const <int>[
      // get version response without header or checksum
      90, 45, 87, 97, 118, 101, 32, 51, 46, 57, 53, 0, 1
    ]);
    expect(
        command.data,
        equals(const <int>[
          // get version response as request
          1, 16, 0, 21, 90, 45, 87, 97, 118, 101, 32, 51, 46, 57, 53, 0, 1, 152
        ]));
  });
}

class TestCommand extends ZwCommand<List<int>> {
  @override
  final int functId;

  @override
  final List<int>? functParam;

  final List<int>? expectedResponse;

  TestCommand(this.functId, this.functParam, {this.expectedResponse});

  @override
  Duration get responseTimeout => const Duration(milliseconds: 20);

  @override
  processResponse(List<int> response) {
    if (expectedResponse != null)
      expect(response, orderedEquals(expectedResponse!));
    return response;
  }
}
