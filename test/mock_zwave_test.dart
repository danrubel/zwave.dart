import 'dart:async';

import 'package:test/test.dart';
import 'package:zwave/zwave.dart';

main() {
  test('zwave mock', () {
    new MockZWave();
  });
}

class MockZWave implements ZWave {
  @override
  List<Device> get devices => [];

  @override
  String get version => 'mock-v1';

  @override
  Future connect(String port) async {
    // TODO: implement connect
  }

  @override
  Future update() async {
    // TODO: implement update
  }

  @override
  Future allUpdated() async {
    // TODO: implement allUpdated
  }

  @override
  Future dispose() async {
    // TODO: implement dispose
  }
}
