part of zwave;

// Generated code

class NotificationType {
  /// All nodes have been queried, so client application can expected complete
  /// data.
  static const int AllNodesQueried = 25;

  /// All nodes have been queried but some dead nodes found.
  static const int AllNodesQueriedSomeDead = 24;

  /// All awake nodes have been queried, so client application can expected
  /// complete data for these nodes.
  static const int AwakeNodesQueried = 23;

  /// Handheld controller button off pressed event
  static const int ButtonOff = 17;

  /// Handheld controller button on pressed event
  static const int ButtonOn = 16;

  /// When Controller Commands are executed, Notifications of Success/Failure
  /// etc are communicated via this Notification Notification::GetEvent returns
  /// Driver::ControllerState and Notification::GetNotification returns
  /// Driver::ControllerError if there was a error
  static const int ControllerCommand = 28;

  /// Handheld controller button event created
  static const int CreateButton = 14;

  /// Handheld controller button event deleted
  static const int DeleteButton = 15;

  /// Driver failed to load
  static const int DriverFailed = 19;

  /// A driver for a PC Z-Wave controller has been added and is ready to use.
  /// The notification will contain the controller's Home ID, which is needed to
  /// call most of the Manager methods.
  static const int DriverReady = 18;

  /// The Driver is being removed. (either due to Error or by request) Do Not
  /// Call Any Driver Related Methods after receiving this call
  static const int DriverRemoved = 27;

  /// All nodes and values for this driver have been removed.  This is sent
  /// instead of potentially hundreds of individual node and value
  /// notifications.
  static const int DriverReset = 20;

  /// The queries on a node that are essential to its operation have been
  /// completed. The node can now handle incoming messages.
  static const int EssentialNodeQueriesComplete = 21;

  /// The associations for the node have changed. The application should rebuild
  /// any group information it holds about the node.
  static const int Group = 4;

  /// A new node has been added to OpenZWave's list.  This may be due to a
  /// device being added to the Z-Wave network, or because the application is
  /// initializing itself.
  static const int NodeAdded = 6;

  /// A node has triggered an event.  This is commonly caused when a node sends
  /// a Basic_Set command to the controller.  The event value is stored in the
  /// notification.
  static const int NodeEvent = 10;

  /// One of the node names has changed (name, manufacturer, product).
  static const int NodeNaming = 9;

  /// A new node has been found (not already stored in zwcfg*.xml file)
  static const int NodeNew = 5;

  /// Basic node information has been received, such as whether the node is a
  /// listening device, a routing device and its baud rate and basic, generic
  /// and specific types. It is after this notification that you can call
  /// Manager::GetNodeType to obtain a label containing the device description.
  static const int NodeProtocolInfo = 8;

  /// All the initialization queries on a node have been completed.
  static const int NodeQueriesComplete = 22;

  /// A node has been removed from OpenZWave's list.  This may be due to a
  /// device being removed from the Z-Wave network, or because the application
  /// is closing.
  static const int NodeRemoved = 7;

  /// The Device has been reset and thus removed from the NodeList in OZW
  static const int NodeReset = 29;

  /// An error has occurred that we need to report.
  static const int Notification = 26;

  /// Polling of a node has been successfully turned off by a call to
  /// Manager::DisablePoll
  static const int PollingDisabled = 11;

  /// Polling of a node has been successfully turned on by a call to
  /// Manager::EnablePoll
  static const int PollingEnabled = 12;

  /// Scene Activation Set received
  static const int SceneEvent = 13;

  /// A new node value has been added to OpenZWave's list. These notifications
  /// occur after a node has been discovered, and details of its command classes
  /// have been received.  Each command class may generate one or more values
  /// depending on the complexity of the item being represented.
  static const int ValueAdded = 0;

  /// A node value has been updated from the Z-Wave network and it is different
  /// from the previous value.
  static const int ValueChanged = 2;

  /// A node value has been updated from the Z-Wave network.
  static const int ValueRefreshed = 3;

  /// A node value has been removed from OpenZWave's list.  This only occurs
  /// when a node is removed.
  static const int ValueRemoved = 1;

  static core.List<core.String> names = <core.String>[
    "ValueAdded", // 0
    "ValueRemoved", // 1
    "ValueChanged", // 2
    "ValueRefreshed", // 3
    "Group", // 4
    "NodeNew", // 5
    "NodeAdded", // 6
    "NodeRemoved", // 7
    "NodeProtocolInfo", // 8
    "NodeNaming", // 9
    "NodeEvent", // 10
    "PollingDisabled", // 11
    "PollingEnabled", // 12
    "SceneEvent", // 13
    "CreateButton", // 14
    "DeleteButton", // 15
    "ButtonOn", // 16
    "ButtonOff", // 17
    "DriverReady", // 18
    "DriverFailed", // 19
    "DriverReset", // 20
    "EssentialNodeQueriesComplete", // 21
    "NodeQueriesComplete", // 22
    "AwakeNodesQueried", // 23
    "AllNodesQueriedSomeDead", // 24
    "AllNodesQueried", // 25
    "Notification", // 26
    "DriverRemoved", // 27
    "ControllerCommand", // 28
    "NodeReset", // 29
  ];

  static core.String name(int index) {
    if (index != null && index >= 0 && index < names.length)
      return names[index];
    return 'UnknownNotificationType';
  }
}

class ValueType {
  /// Boolean, true or false
  static const int Bool = 0;

  /// A write-only value that is the equivalent of pressing a button to send a
  /// command to a device
  static const int Button = 8;

  /// 8-bit unsigned value
  static const int Byte = 1;

  /// Represents a non-integer value as a string, to avoid floating point
  /// accuracy issues.
  static const int Decimal = 2;

  /// 32-bit signed value
  static const int Int = 3;

  /// List from which one item can be selected
  static const int List = 4;

  /// A collection of bytes
  static const int Raw = 9;

  /// Complex type used with the Climate Control Schedule command class
  static const int Schedule = 5;

  /// 16-bit signed value
  static const int Short = 6;

  /// Text string
  static const int String = 7;

  static core.List<core.String> names = <core.String>[
    "Bool", // 0
    "Byte", // 1
    "Decimal", // 2
    "Int", // 3
    "List", // 4
    "Schedule", // 5
    "Short", // 6
    "String", // 7
    "Button", // 8
    "Raw", // 9
  ];

  static core.String name(int index) {
    if (index != null && index >= 0 && index < names.length)
      return names[index];
    return 'UnknownValueType';
  }
}

class ValueGenre {
  /// The 'level' as controlled by basic commands.  Usually duplicated by
  /// another command class.
  static const int Basic = 0;

  /// Device-specific configuration parameters.  These cannot be automatically
  /// discovered via Z-Wave, and are usually described in the user manual
  /// instead.
  static const int Config = 2;

  /// Values of significance only to users who understand the Z-Wave protocol
  static const int System = 3;

  /// Basic values an ordinary user would be interested in.
  static const int User = 1;

  static core.List<core.String> names = <core.String>[
    "Basic", // 0
    "User", // 1
    "Config", // 2
    "System", // 3
  ];

  static core.String name(int index) {
    if (index != null && index >= 0 && index < names.length)
      return names[index];
    return 'UnknownValueGenre';
  }
}
