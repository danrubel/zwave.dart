import 'package:test/test.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/report/api_library_version.dart';

main() {
  const response = const <int>[
    1, // SOF
    16, // message length excluding SOF and checksum
    1, // response
    FUNC_ID_ZW_GET_VERSION,

    // version string 'Z-Wave 3.95'
    90, 45, 87, 97, 118, 101, 32, 51, 46, 57, 53, 0,
    1, // library type

    153 // checksum
  ];

  test('valid', () {
    final version = new ApiLibraryVersion(response);
    expect(version.version, 'Z-Wave 3.95');
    expect(version.libraryType, 1);
  });
}
