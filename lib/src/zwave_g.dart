part of zwave;

// Generated code

class NotificationType {
  static const int AllNodesQueried = 25;
  static const int AllNodesQueriedSomeDead = 24;
  static const int AwakeNodesQueried = 23;
  static const int ButtonOff = 17;
  static const int ButtonOn = 16;
  static const int ControllerCommand = 28;
  static const int CreateButton = 14;
  static const int DeleteButton = 15;
  static const int DriverFailed = 19;
  static const int DriverReady = 18;
  static const int DriverRemoved = 27;
  static const int DriverReset = 20;
  static const int EssentialNodeQueriesComplete = 21;
  static const int Group = 4;
  static const int NodeAdded = 6;
  static const int NodeEvent = 10;
  static const int NodeNaming = 9;
  static const int NodeNew = 5;
  static const int NodeProtocolInfo = 8;
  static const int NodeQueriesComplete = 22;
  static const int NodeRemoved = 7;
  static const int NodeReset = 29;
  static const int Notification = 26;
  static const int PollingDisabled = 11;
  static const int PollingEnabled = 12;
  static const int SceneEvent = 13;
  static const int ValueAdded = 0;
  static const int ValueChanged = 2;
  static const int ValueRefreshed = 3;
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
  static const int Bool = 0;
  static const int Button = 8;
  static const int Byte = 1;
  static const int Decimal = 2;
  static const int Int = 3;
  static const int List = 4;
  static const int Raw = 9;
  static const int Schedule = 5;
  static const int Short = 6;
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
  static const int Basic = 0;
  static const int Config = 2;
  static const int System = 3;
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
