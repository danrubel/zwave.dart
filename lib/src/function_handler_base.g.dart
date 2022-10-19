// Generated code

import 'package:logging/logging.dart';
import 'package:zwave/src/function_ids.g.dart';

/// [FunctionHandlerBase] processes Z-Wave messages received from the controller
/// and dispatches them to the various handle<FunctionName> methods in this
/// class. Subclasses should override these handle methods as necessary.
abstract class FunctionHandlerBase<T> {
  Logger get logger;
  late List<T? Function(List<int>)> handlers;

  T? dispatch(List<int> data) => handlers[data[3]](data);

  void initHandlers() {
    handlers = [
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      /* 0x02 */ handleSerialApiGetInitData,
      /* 0x03 */ handleSerialApiApplNodeInformation,
      /* 0x04 */ handleApplicationCommandHandler,
      /* 0x05 */ handleZwGetControllerCapabilities,
      /* 0x06 */ handleSerialApiSetTimeouts,
      /* 0x07 */ handleSerialApiGetCapabilities,
      /* 0x08 */ handleSerialApiSoftReset,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      /* 0x12 */ handleZwSendNodeInformation,
      /* 0x13 */ handleZwSendData,
      handleUnknownFunctionId,
      /* 0x15 */ handleZwGetVersion,
      handleUnknownFunctionId,
      /* 0x17 */ handleZwRFPowerLevelSet,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      /* 0x1C */ handleZwGetRandom,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      /* 0x20 */ handleZwMemoryGetId,
      /* 0x21 */ handleMemoryGetByte,
      handleUnknownFunctionId,
      /* 0x23 */ handleZwReadMemory,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      /* 0x40 */ handleZwSetLearnNodeState,
      /* 0x41 */ handleZwGetNodeProtocolInfo,
      /* 0x42 */ handleZwSetDefault,
      /* 0x43 */ handleZwNewController,
      /* 0x44 */ handleZwReplicationCommandComplete,
      /* 0x45 */ handleZwReplicationSendData,
      /* 0x46 */ handleZwAssignReturnRoute,
      /* 0x47 */ handleZwDeleteReturnRoute,
      /* 0x48 */ handleZwRequestNodeNeighborUpdate,
      /* 0x49 */ handleZwApplicationUpdate,
      /* 0x4A */ handleZwAddNodeToNetwork,
      /* 0x4B */ handleZwRemoveNodeFromNetwork,
      /* 0x4C */ handleZwCreateNewPrimary,
      /* 0x4D */ handleZwControllerChange,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      /* 0x50 */ handleZwSetLearnMode,
      /* 0x51 */ handleZwAssignSucReturnRoute,
      /* 0x52 */ handleZwEnableSuc,
      /* 0x53 */ handleZwRequestNetworkUpdate,
      /* 0x54 */ handleZwSetSucNodeId,
      /* 0x55 */ handleZwDeleteSucReturnRoute,
      /* 0x56 */ handleZwGetSucNodeId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      /* 0x5A */ handleZwRequestNodeNeighborUpdateOptions,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      /* 0x5E */ handleZwExploreRequestInclusion,
      handleUnknownFunctionId,
      /* 0x60 */ handleZwRequestNodeInfo,
      /* 0x61 */ handleZwRemoveFailedNodeId,
      /* 0x62 */ handleZwIsFailedNodeId,
      /* 0x63 */ handleZwReplaceFailedNode,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      /* 0x80 */ handleZwGetRoutingInfo,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      /* 0xA0 */ handleSerialApiSlaveNodeInfo,
      /* 0xA1 */ handleApplicationSlaveCommandHandler,
      /* 0xA2 */ handleZwSendSlaveNodeInfo,
      /* 0xA3 */ handleZwSendSlaveData,
      /* 0xA4 */ handleZwSetSlaveLearnMode,
      /* 0xA5 */ handleZwGetVirtualNodes,
      /* 0xA6 */ handleZwIsVirtualNode,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      /* 0xD0 */ handleZwSetPromiscuousMode,
      /* 0xD1 */ handlePromiscuousApplicationCommandHandler,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
      handleUnknownFunctionId,
    ];
  }

  /// FUNC_ID_APPLICATION_COMMAND_HANDLER
  T? handleApplicationCommandHandler(List<int> data) {
    return unhandledMessage(FUNC_ID_APPLICATION_COMMAND_HANDLER,
        'FUNC_ID_APPLICATION_COMMAND_HANDLER', data);
  }

  /// FUNC_ID_APPLICATION_SLAVE_COMMAND_HANDLER - Slave command handler
  T? handleApplicationSlaveCommandHandler(List<int> data) {
    return unhandledMessage(FUNC_ID_APPLICATION_SLAVE_COMMAND_HANDLER,
        'FUNC_ID_APPLICATION_SLAVE_COMMAND_HANDLER', data);
  }

  /// FUNC_ID_MEMORY_GET_BYTE
  T? handleMemoryGetByte(List<int> data) {
    return unhandledMessage(
        FUNC_ID_MEMORY_GET_BYTE, 'FUNC_ID_MEMORY_GET_BYTE', data);
  }

  /// FUNC_ID_PROMISCUOUS_APPLICATION_COMMAND_HANDLER
  T? handlePromiscuousApplicationCommandHandler(List<int> data) {
    return unhandledMessage(FUNC_ID_PROMISCUOUS_APPLICATION_COMMAND_HANDLER,
        'FUNC_ID_PROMISCUOUS_APPLICATION_COMMAND_HANDLER', data);
  }

  /// FUNC_ID_SERIAL_API_APPL_NODE_INFORMATION
  T? handleSerialApiApplNodeInformation(List<int> data) {
    return unhandledMessage(FUNC_ID_SERIAL_API_APPL_NODE_INFORMATION,
        'FUNC_ID_SERIAL_API_APPL_NODE_INFORMATION', data);
  }

  /// FUNC_ID_SERIAL_API_GET_CAPABILITIES
  T? handleSerialApiGetCapabilities(List<int> data) {
    return unhandledMessage(FUNC_ID_SERIAL_API_GET_CAPABILITIES,
        'FUNC_ID_SERIAL_API_GET_CAPABILITIES', data);
  }

  /// FUNC_ID_SERIAL_API_GET_INIT_DATA
  T? handleSerialApiGetInitData(List<int> data) {
    return unhandledMessage(FUNC_ID_SERIAL_API_GET_INIT_DATA,
        'FUNC_ID_SERIAL_API_GET_INIT_DATA', data);
  }

  /// FUNC_ID_SERIAL_API_SET_TIMEOUTS
  T? handleSerialApiSetTimeouts(List<int> data) {
    return unhandledMessage(FUNC_ID_SERIAL_API_SET_TIMEOUTS,
        'FUNC_ID_SERIAL_API_SET_TIMEOUTS', data);
  }

  /// FUNC_ID_SERIAL_API_SLAVE_NODE_INFO - Set application virtual slave node information
  T? handleSerialApiSlaveNodeInfo(List<int> data) {
    return unhandledMessage(FUNC_ID_SERIAL_API_SLAVE_NODE_INFO,
        'FUNC_ID_SERIAL_API_SLAVE_NODE_INFO', data);
  }

  /// FUNC_ID_SERIAL_API_SOFT_RESET
  T? handleSerialApiSoftReset(List<int> data) {
    return unhandledMessage(
        FUNC_ID_SERIAL_API_SOFT_RESET, 'FUNC_ID_SERIAL_API_SOFT_RESET', data);
  }

  /// FUNC_ID_ZW_ADD_NODE_TO_NETWORK - Control the addnode (or addcontroller) process...start, stop, etc.
  T? handleZwAddNodeToNetwork(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_ADD_NODE_TO_NETWORK, 'FUNC_ID_ZW_ADD_NODE_TO_NETWORK', data);
  }

  /// FUNC_ID_ZW_APPLICATION_UPDATE - Get a list of supported (and controller) command classes
  T? handleZwApplicationUpdate(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_APPLICATION_UPDATE, 'FUNC_ID_ZW_APPLICATION_UPDATE', data);
  }

  /// FUNC_ID_ZW_ASSIGN_RETURN_ROUTE - Assign a return route from the specified node to the controller
  T? handleZwAssignReturnRoute(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_ASSIGN_RETURN_ROUTE, 'FUNC_ID_ZW_ASSIGN_RETURN_ROUTE', data);
  }

  /// FUNC_ID_ZW_ASSIGN_SUC_RETURN_ROUTE - Assign a return route to the SUC
  T? handleZwAssignSucReturnRoute(List<int> data) {
    return unhandledMessage(FUNC_ID_ZW_ASSIGN_SUC_RETURN_ROUTE,
        'FUNC_ID_ZW_ASSIGN_SUC_RETURN_ROUTE', data);
  }

  /// FUNC_ID_ZW_CONTROLLER_CHANGE - Control the transferprimary process...start, stop, etc.
  T? handleZwControllerChange(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_CONTROLLER_CHANGE, 'FUNC_ID_ZW_CONTROLLER_CHANGE', data);
  }

  /// FUNC_ID_ZW_CREATE_NEW_PRIMARY - Control the createnewprimary process...start, stop, etc.
  T? handleZwCreateNewPrimary(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_CREATE_NEW_PRIMARY, 'FUNC_ID_ZW_CREATE_NEW_PRIMARY', data);
  }

  /// FUNC_ID_ZW_DELETE_RETURN_ROUTE - Delete all return routes from the specified node
  T? handleZwDeleteReturnRoute(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_DELETE_RETURN_ROUTE, 'FUNC_ID_ZW_DELETE_RETURN_ROUTE', data);
  }

  /// FUNC_ID_ZW_DELETE_SUC_RETURN_ROUTE - Remove return routes to the SUC
  T? handleZwDeleteSucReturnRoute(List<int> data) {
    return unhandledMessage(FUNC_ID_ZW_DELETE_SUC_RETURN_ROUTE,
        'FUNC_ID_ZW_DELETE_SUC_RETURN_ROUTE', data);
  }

  /// FUNC_ID_ZW_ENABLE_SUC - Make a controller a Static Update Controller
  T? handleZwEnableSuc(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_ENABLE_SUC, 'FUNC_ID_ZW_ENABLE_SUC', data);
  }

  /// FUNC_ID_ZW_EXPLORE_REQUEST_INCLUSION - supports NWI
  T? handleZwExploreRequestInclusion(List<int> data) {
    return unhandledMessage(FUNC_ID_ZW_EXPLORE_REQUEST_INCLUSION,
        'FUNC_ID_ZW_EXPLORE_REQUEST_INCLUSION', data);
  }

  /// FUNC_ID_ZW_GET_CONTROLLER_CAPABILITIES
  T? handleZwGetControllerCapabilities(List<int> data) {
    return unhandledMessage(FUNC_ID_ZW_GET_CONTROLLER_CAPABILITIES,
        'FUNC_ID_ZW_GET_CONTROLLER_CAPABILITIES', data);
  }

  /// FUNC_ID_ZW_GET_NODE_PROTOCOL_INFO - Get protocol info (baud rate, listening, etc.) for a given node
  T? handleZwGetNodeProtocolInfo(List<int> data) {
    return unhandledMessage(FUNC_ID_ZW_GET_NODE_PROTOCOL_INFO,
        'FUNC_ID_ZW_GET_NODE_PROTOCOL_INFO', data);
  }

  /// FUNC_ID_ZW_GET_RANDOM
  T? handleZwGetRandom(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_GET_RANDOM, 'FUNC_ID_ZW_GET_RANDOM', data);
  }

  /// FUNC_ID_ZW_GET_ROUTING_INFO - Get a specified node's neighbor information from the controller
  T? handleZwGetRoutingInfo(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_GET_ROUTING_INFO, 'FUNC_ID_ZW_GET_ROUTING_INFO', data);
  }

  /// FUNC_ID_ZW_GET_SUC_NODE_ID - Try to retrieve a Static Update Controller node id (zero if no SUC present)
  T? handleZwGetSucNodeId(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_GET_SUC_NODE_ID, 'FUNC_ID_ZW_GET_SUC_NODE_ID', data);
  }

  /// FUNC_ID_ZW_GET_VERSION
  T? handleZwGetVersion(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_GET_VERSION, 'FUNC_ID_ZW_GET_VERSION', data);
  }

  /// FUNC_ID_ZW_GET_VIRTUAL_NODES - Return all virtual nodes
  T? handleZwGetVirtualNodes(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_GET_VIRTUAL_NODES, 'FUNC_ID_ZW_GET_VIRTUAL_NODES', data);
  }

  /// FUNC_ID_ZW_IS_FAILED_NODE_ID - Check to see if a specified node has failed
  T? handleZwIsFailedNodeId(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_IS_FAILED_NODE_ID, 'FUNC_ID_ZW_IS_FAILED_NODE_ID', data);
  }

  /// FUNC_ID_ZW_IS_VIRTUAL_NODE - Virtual node test
  T? handleZwIsVirtualNode(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_IS_VIRTUAL_NODE, 'FUNC_ID_ZW_IS_VIRTUAL_NODE', data);
  }

  /// FUNC_ID_ZW_MEMORY_GET_ID
  T? handleZwMemoryGetId(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_MEMORY_GET_ID, 'FUNC_ID_ZW_MEMORY_GET_ID', data);
  }

  /// FUNC_ID_ZW_NEW_CONTROLLER
  T? handleZwNewController(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_NEW_CONTROLLER, 'FUNC_ID_ZW_NEW_CONTROLLER', data);
  }

  /// FUNC_ID_ZW_READ_MEMORY
  T? handleZwReadMemory(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_READ_MEMORY, 'FUNC_ID_ZW_READ_MEMORY', data);
  }

  /// FUNC_ID_ZW_REMOVE_FAILED_NODE_ID - Mark a specified node id as failed
  T? handleZwRemoveFailedNodeId(List<int> data) {
    return unhandledMessage(FUNC_ID_ZW_REMOVE_FAILED_NODE_ID,
        'FUNC_ID_ZW_REMOVE_FAILED_NODE_ID', data);
  }

  /// FUNC_ID_ZW_REMOVE_NODE_FROM_NETWORK - Control the removenode (or removecontroller) process...start, stop, etc.
  T? handleZwRemoveNodeFromNetwork(List<int> data) {
    return unhandledMessage(FUNC_ID_ZW_REMOVE_NODE_FROM_NETWORK,
        'FUNC_ID_ZW_REMOVE_NODE_FROM_NETWORK', data);
  }

  /// FUNC_ID_ZW_REPLACE_FAILED_NODE - Remove a failed node from the controller's list (?)
  T? handleZwReplaceFailedNode(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_REPLACE_FAILED_NODE, 'FUNC_ID_ZW_REPLACE_FAILED_NODE', data);
  }

  /// FUNC_ID_ZW_REPLICATION_COMMAND_COMPLETE - Replication send data complete
  T? handleZwReplicationCommandComplete(List<int> data) {
    return unhandledMessage(FUNC_ID_ZW_REPLICATION_COMMAND_COMPLETE,
        'FUNC_ID_ZW_REPLICATION_COMMAND_COMPLETE', data);
  }

  /// FUNC_ID_ZW_REPLICATION_SEND_DATA - Replication send data
  T? handleZwReplicationSendData(List<int> data) {
    return unhandledMessage(FUNC_ID_ZW_REPLICATION_SEND_DATA,
        'FUNC_ID_ZW_REPLICATION_SEND_DATA', data);
  }

  /// FUNC_ID_ZW_REQUEST_NETWORK_UPDATE - Network update for a SUC(?)
  T? handleZwRequestNetworkUpdate(List<int> data) {
    return unhandledMessage(FUNC_ID_ZW_REQUEST_NETWORK_UPDATE,
        'FUNC_ID_ZW_REQUEST_NETWORK_UPDATE', data);
  }

  /// FUNC_ID_ZW_REQUEST_NODE_INFO - Get info (supported command classes) for the specified node
  T? handleZwRequestNodeInfo(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_REQUEST_NODE_INFO, 'FUNC_ID_ZW_REQUEST_NODE_INFO', data);
  }

  /// FUNC_ID_ZW_REQUEST_NODE_NEIGHBOR_UPDATE - Ask the specified node to update its neighbors (then read them from the controller)
  T? handleZwRequestNodeNeighborUpdate(List<int> data) {
    return unhandledMessage(FUNC_ID_ZW_REQUEST_NODE_NEIGHBOR_UPDATE,
        'FUNC_ID_ZW_REQUEST_NODE_NEIGHBOR_UPDATE', data);
  }

  /// FUNC_ID_ZW_REQUEST_NODE_NEIGHBOR_UPDATE_OPTIONS - Allow options for request node neighbor update
  T? handleZwRequestNodeNeighborUpdateOptions(List<int> data) {
    return unhandledMessage(FUNC_ID_ZW_REQUEST_NODE_NEIGHBOR_UPDATE_OPTIONS,
        'FUNC_ID_ZW_REQUEST_NODE_NEIGHBOR_UPDATE_OPTIONS', data);
  }

  /// FUNC_ID_ZW_R_F_POWER_LEVEL_SET
  T? handleZwRFPowerLevelSet(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_R_F_POWER_LEVEL_SET, 'FUNC_ID_ZW_R_F_POWER_LEVEL_SET', data);
  }

  /// FUNC_ID_ZW_SEND_DATA
  T? handleZwSendData(List<int> data) {
    return unhandledMessage(FUNC_ID_ZW_SEND_DATA, 'FUNC_ID_ZW_SEND_DATA', data);
  }

  /// FUNC_ID_ZW_SEND_NODE_INFORMATION
  T? handleZwSendNodeInformation(List<int> data) {
    return unhandledMessage(FUNC_ID_ZW_SEND_NODE_INFORMATION,
        'FUNC_ID_ZW_SEND_NODE_INFORMATION', data);
  }

  /// FUNC_ID_ZW_SEND_SLAVE_DATA - Send data from slave
  T? handleZwSendSlaveData(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_SEND_SLAVE_DATA, 'FUNC_ID_ZW_SEND_SLAVE_DATA', data);
  }

  /// FUNC_ID_ZW_SEND_SLAVE_NODE_INFO - Send a slave node information frame
  T? handleZwSendSlaveNodeInfo(List<int> data) {
    return unhandledMessage(FUNC_ID_ZW_SEND_SLAVE_NODE_INFO,
        'FUNC_ID_ZW_SEND_SLAVE_NODE_INFO', data);
  }

  /// FUNC_ID_ZW_SET_DEFAULT - Reset controller and node info to default (original) values
  T? handleZwSetDefault(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_SET_DEFAULT, 'FUNC_ID_ZW_SET_DEFAULT', data);
  }

  /// FUNC_ID_ZW_SET_LEARN_MODE - Put a controller into learn mode for replication/ receipt of configuration info
  T? handleZwSetLearnMode(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_SET_LEARN_MODE, 'FUNC_ID_ZW_SET_LEARN_MODE', data);
  }

  /// FUNC_ID_ZW_SET_LEARN_NODE_STATE
  T? handleZwSetLearnNodeState(List<int> data) {
    return unhandledMessage(FUNC_ID_ZW_SET_LEARN_NODE_STATE,
        'FUNC_ID_ZW_SET_LEARN_NODE_STATE', data);
  }

  /// FUNC_ID_ZW_SET_PROMISCUOUS_MODE - Set controller into promiscuous mode to listen to all frames
  T? handleZwSetPromiscuousMode(List<int> data) {
    return unhandledMessage(FUNC_ID_ZW_SET_PROMISCUOUS_MODE,
        'FUNC_ID_ZW_SET_PROMISCUOUS_MODE', data);
  }

  /// FUNC_ID_ZW_SET_SLAVE_LEARN_MODE - Enter slave learn mode
  T? handleZwSetSlaveLearnMode(List<int> data) {
    return unhandledMessage(FUNC_ID_ZW_SET_SLAVE_LEARN_MODE,
        'FUNC_ID_ZW_SET_SLAVE_LEARN_MODE', data);
  }

  /// FUNC_ID_ZW_SET_SUC_NODE_ID - Identify a Static Update Controller node id
  T? handleZwSetSucNodeId(List<int> data) {
    return unhandledMessage(
        FUNC_ID_ZW_SET_SUC_NODE_ID, 'FUNC_ID_ZW_SET_SUC_NODE_ID', data);
  }

  T? handleUnknownFunctionId(List<int> data) {
    final functId = data[3];
    logger.warning('Unknown function id: $functId $data');
    return null;
  }

  T? unhandledMessage(int functId, String functName, List<int> data) {
    logger.warning('Unhandled message: $functId $functName $data');
    return null;
  }
}
