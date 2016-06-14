part of zwave;

// Generated code

class NotificationType {
  final int index;
  final String name;

  NotificationType._(this.index, this.name);

  /// All nodes have been queried, so client application can expected complete
  /// data.
  static NotificationType AllNodesQueried =
      new NotificationType._(25, "AllNodesQueried");

  /// All nodes have been queried but some dead nodes found.
  static NotificationType AllNodesQueriedSomeDead =
      new NotificationType._(24, "AllNodesQueriedSomeDead");

  /// All awake nodes have been queried, so client application can expected
  /// complete data for these nodes.
  static NotificationType AwakeNodesQueried =
      new NotificationType._(23, "AwakeNodesQueried");

  /// Handheld controller button off pressed event
  static NotificationType ButtonOff =
      new NotificationType._(17, "ButtonOff");

  /// Handheld controller button on pressed event
  static NotificationType ButtonOn =
      new NotificationType._(16, "ButtonOn");

  /// When Controller Commands are executed, Notifications of Success/Failure
  /// etc are communicated via this Notification Notification::GetEvent returns
  /// Driver::ControllerState and Notification::GetNotification returns
  /// Driver::ControllerError if there was a error
  static NotificationType ControllerCommand =
      new NotificationType._(28, "ControllerCommand");

  /// Handheld controller button event created
  static NotificationType CreateButton =
      new NotificationType._(14, "CreateButton");

  /// Handheld controller button event deleted
  static NotificationType DeleteButton =
      new NotificationType._(15, "DeleteButton");

  /// Driver failed to load
  static NotificationType DriverFailed =
      new NotificationType._(19, "DriverFailed");

  /// A driver for a PC Z-Wave controller has been added and is ready to use.
  /// The notification will contain the controller's Home ID, which is needed to
  /// call most of the Manager methods.
  static NotificationType DriverReady =
      new NotificationType._(18, "DriverReady");

  /// The Driver is being removed. (either due to Error or by request) Do Not
  /// Call Any Driver Related Methods after receiving this call
  static NotificationType DriverRemoved =
      new NotificationType._(27, "DriverRemoved");

  /// All nodes and values for this driver have been removed.  This is sent
  /// instead of potentially hundreds of individual node and value
  /// notifications.
  static NotificationType DriverReset =
      new NotificationType._(20, "DriverReset");

  /// The queries on a node that are essential to its operation have been
  /// completed. The node can now handle incoming messages.
  static NotificationType EssentialNodeQueriesComplete =
      new NotificationType._(21, "EssentialNodeQueriesComplete");

  /// The associations for the node have changed. The application should rebuild
  /// any group information it holds about the node.
  static NotificationType Group =
      new NotificationType._(4, "Group");

  /// A new node has been added to OpenZWave's list.  This may be due to a
  /// device being added to the Z-Wave network, or because the application is
  /// initializing itself.
  static NotificationType NodeAdded =
      new NotificationType._(6, "NodeAdded");

  /// A node has triggered an event.  This is commonly caused when a node sends
  /// a Basic_Set command to the controller.  The event value is stored in the
  /// notification.
  static NotificationType NodeEvent =
      new NotificationType._(10, "NodeEvent");

  /// One of the node names has changed (name, manufacturer, product).
  static NotificationType NodeNaming =
      new NotificationType._(9, "NodeNaming");

  /// A new node has been found (not already stored in zwcfg*.xml file)
  static NotificationType NodeNew =
      new NotificationType._(5, "NodeNew");

  /// Basic node information has been received, such as whether the node is a
  /// listening device, a routing device and its baud rate and basic, generic
  /// and specific types. It is after this notification that you can call
  /// Manager::GetNodeType to obtain a label containing the device description.
  static NotificationType NodeProtocolInfo =
      new NotificationType._(8, "NodeProtocolInfo");

  /// All the initialization queries on a node have been completed.
  static NotificationType NodeQueriesComplete =
      new NotificationType._(22, "NodeQueriesComplete");

  /// A node has been removed from OpenZWave's list.  This may be due to a
  /// device being removed from the Z-Wave network, or because the application
  /// is closing.
  static NotificationType NodeRemoved =
      new NotificationType._(7, "NodeRemoved");

  /// The Device has been reset and thus removed from the NodeList in OZW
  static NotificationType NodeReset =
      new NotificationType._(29, "NodeReset");

  /// An error has occurred that we need to report.
  static NotificationType Notification =
      new NotificationType._(26, "Notification");

  /// Polling of a node has been successfully turned off by a call to
  /// Manager::DisablePoll
  static NotificationType PollingDisabled =
      new NotificationType._(11, "PollingDisabled");

  /// Polling of a node has been successfully turned on by a call to
  /// Manager::EnablePoll
  static NotificationType PollingEnabled =
      new NotificationType._(12, "PollingEnabled");

  /// Scene Activation Set received
  static NotificationType SceneEvent =
      new NotificationType._(13, "SceneEvent");

  /// A new node value has been added to OpenZWave's list. These notifications
  /// occur after a node has been discovered, and details of its command classes
  /// have been received.  Each command class may generate one or more values
  /// depending on the complexity of the item being represented.
  static NotificationType ValueAdded =
      new NotificationType._(0, "ValueAdded");

  /// A node value has been updated from the Z-Wave network and it is different
  /// from the previous value.
  static NotificationType ValueChanged =
      new NotificationType._(2, "ValueChanged");

  /// A node value has been updated from the Z-Wave network.
  static NotificationType ValueRefreshed =
      new NotificationType._(3, "ValueRefreshed");

  /// A node value has been removed from OpenZWave's list.  This only occurs
  /// when a node is removed.
  static NotificationType ValueRemoved =
      new NotificationType._(1, "ValueRemoved");

  /// A list of notification types sorted by index.
  static List<NotificationType> list = <NotificationType>[
    ValueAdded,                    // 0
    ValueRemoved,                  // 1
    ValueChanged,                  // 2
    ValueRefreshed,                // 3
    Group,                         // 4
    NodeNew,                       // 5
    NodeAdded,                     // 6
    NodeRemoved,                   // 7
    NodeProtocolInfo,              // 8
    NodeNaming,                    // 9
    NodeEvent,                     // 10
    PollingDisabled,               // 11
    PollingEnabled,                // 12
    SceneEvent,                    // 13
    CreateButton,                  // 14
    DeleteButton,                  // 15
    ButtonOn,                      // 16
    ButtonOff,                     // 17
    DriverReady,                   // 18
    DriverFailed,                  // 19
    DriverReset,                   // 20
    EssentialNodeQueriesComplete,  // 21
    NodeQueriesComplete,           // 22
    AwakeNodesQueried,             // 23
    AllNodesQueriedSomeDead,       // 24
    AllNodesQueried,               // 25
    Notification,                  // 26
    DriverRemoved,                 // 27
    ControllerCommand,             // 28
    NodeReset,                     // 29
  ];
}

const int NotificationIndex_AllNodesQueried = 25;
const int NotificationIndex_AllNodesQueriedSomeDead = 24;
const int NotificationIndex_AwakeNodesQueried = 23;
const int NotificationIndex_ButtonOff = 17;
const int NotificationIndex_ButtonOn = 16;
const int NotificationIndex_ControllerCommand = 28;
const int NotificationIndex_CreateButton = 14;
const int NotificationIndex_DeleteButton = 15;
const int NotificationIndex_DriverFailed = 19;
const int NotificationIndex_DriverReady = 18;
const int NotificationIndex_DriverRemoved = 27;
const int NotificationIndex_DriverReset = 20;
const int NotificationIndex_EssentialNodeQueriesComplete = 21;
const int NotificationIndex_Group = 4;
const int NotificationIndex_NodeAdded = 6;
const int NotificationIndex_NodeEvent = 10;
const int NotificationIndex_NodeNaming = 9;
const int NotificationIndex_NodeNew = 5;
const int NotificationIndex_NodeProtocolInfo = 8;
const int NotificationIndex_NodeQueriesComplete = 22;
const int NotificationIndex_NodeRemoved = 7;
const int NotificationIndex_NodeReset = 29;
const int NotificationIndex_Notification = 26;
const int NotificationIndex_PollingDisabled = 11;
const int NotificationIndex_PollingEnabled = 12;
const int NotificationIndex_SceneEvent = 13;
const int NotificationIndex_ValueAdded = 0;
const int NotificationIndex_ValueChanged = 2;
const int NotificationIndex_ValueRefreshed = 3;
const int NotificationIndex_ValueRemoved = 1;

const int ValueTypeIndex_Bool = 0;
const int ValueTypeIndex_Button = 8;
const int ValueTypeIndex_Byte = 1;
const int ValueTypeIndex_Decimal = 2;
const int ValueTypeIndex_Int = 3;
const int ValueTypeIndex_List = 4;
const int ValueTypeIndex_Raw = 9;
const int ValueTypeIndex_Schedule = 5;
const int ValueTypeIndex_Short = 6;
const int ValueTypeIndex_String = 7;

const int ValueGenreIndex_Basic = 0;
const int ValueGenreIndex_Config = 2;
const int ValueGenreIndex_System = 3;
const int ValueGenreIndex_User = 1;
