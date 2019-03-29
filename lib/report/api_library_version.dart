import 'dart:convert';

import 'package:zwave/zw_message.dart';

class ApiLibraryVersion extends ZwMessage {
  final List<int> data;

  int get libraryType => data[data.length - 2];

  String get version => utf8.decode(data.sublist(4, data.length - 3));

  ApiLibraryVersion(this.data);

  @override
  String toString() {
    return "ApiLibraryVersion('$version', $libraryType)";
  }
}
