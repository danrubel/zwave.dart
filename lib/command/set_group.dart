import 'package:zwave/command/util.dart';
import 'package:zwave/command/zw_command.dart';
import 'package:zwave/zwave.dart';

/// `SetGroupCommand` changes group members for a particular device
class SetGroupCommand extends ZWCommand {
  SetGroupCommand(ZWave zwave)
      : super(
          zwave,
          'setGroup',
          description: 'Change group memebers for a specific device',
          argumentDescription:
              '[<network id>] <node id> <value id> <0 or more member node ids>',
          aliases: const ['sg'],
        );

  @override
  runWith(StringBuffer buf) {
    String networkArg;
    String nodeArg;
    String groupArg;
    List<String> newValues;
    var rest = argResults.rest;
    if (rest.isEmpty) {
      missingArgument(buf, 'node id');
      return;
    } else if (rest.length == 1) {
      missingArgument(buf, 'group id');
      return;
    } else if (rest.length == 2) {
      if (hasMultipleNetworks) {
        missingArgument(buf, 'network id');
        return;
      }
    }
    if (hasMultipleNetworks) {
      networkArg = rest[0];
      nodeArg = rest[1];
      groupArg = rest[2];
      newValues = rest.sublist(3);
    } else {
      networkArg = null;
      nodeArg = rest[0];
      groupArg = rest[1];
      newValues = rest.sublist(2);
    }

    Device device = findDevice(buf, networkArg, nodeArg);
    if (device == null) return;

    int groupId = parseInt(groupArg);
    if (groupId == -1) {
      invalidArgument(buf, 'group id', groupArg);
      return;
    }
    var memberIds = <int>[];
    for (String newValue in newValues) {
      int memberId = parseInt(newValue);
      if (memberId < 1) {
        invalidArgument(buf, 'member id', newValue);
        return;
      }
      memberIds.add(memberId);
    }

    if (groupId < 1 || groupId > device.groups.length) {
      invalidArgument(buf, 'group id', groupArg);
      return;
    }
    Group group = device.groups[groupId - 1];

    if (memberIds.length > group.maxAssociations) {
      buf.writeln('Can only have a maximum of ${group.maxAssociations} '
          'associations in group $groupId');
      return;
    }
    try {
      var originalMemberIds = new List.from(group.associations);
      for (int memberId in originalMemberIds) {
        if (!memberIds.contains(memberId)) {
          group.removeAssociation(memberId);
        }
      }
      for (int memberId in memberIds) {
        if (!group.associations.contains(memberId)) {
          group.addAssociation(memberId);
        }
      }
    } catch (e) {
      buf.writeln('Failed to update group $groupId members:\n  $e');
      return;
    }
    buf.writeln('Group $groupId set to $memberIds');
  }
}
