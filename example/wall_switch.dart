import 'package:zwave/capability/switch_binary.dart';

import 'named_node.dart';

/// A simple wall switch or switched outlet.
class WallSwitch extends NamedNode with SwitchBinary {
  WallSwitch(int id, String location, String name) : super(id, location, name);
}
