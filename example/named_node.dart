import 'package:logging/logging.dart';
import 'package:zwave/capability/node_naming.dart';
import 'package:zwave/node/zw_node.dart';

/// A Z-Wave node that has the [NodeNaming] capability.
/// The name and location can be queried via the [NodeNaming] api
/// or set via the constructor as is the case here.
class NamedNode extends ZwNode with NodeNaming {
  NamedNode(int id, String location, String name) : super(id) {
    this.location = location;
    this.name = name;
    logger = Logger(description!);
  }
}
