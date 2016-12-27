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
  Device device(int nodeId, {int networkId, String name, Map configuration}) =>
      null;

  @override
  List<Device> get devices => [];

  @override
  String get version => 'mock-v1';

  @override
  Future connect(String port) async {
    throw 'not implemented';
  }

  @override
  void heal({int networkId}) {
    throw 'not implemented';
  }

  @override
  Future update() async {
    throw 'not implemented';
  }

  @override
  Future allUpdated() async {
    throw 'not implemented';
  }

  @override
  int get pollInterval => null;

  @override
  Future dispose() async {
    throw 'not implemented';
  }

  @override
  void writeConfig() {
    throw 'not implemented';
  }

  @override
  String summary({bool allValues: false}) => 'mock';

  @override
  Future<int> removeDevice({int networkId}) {
    throw 'not implemented';
  }

  @override
  Future<Device> addDevice({int networkId}) {
    throw 'not implemented';
  }
}
