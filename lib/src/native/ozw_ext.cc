#include <errno.h>
#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

#include "Options.h"
#include "Manager.h"
#include "Driver.h"
#include "Node.h"
#include "Group.h"
#include "Notification.h"
#include "value_classes/Value.h"
#include "value_classes/ValueBool.h"
#include "value_classes/ValueID.h"
#include "value_classes/ValueStore.h"
#include "platform/Log.h"
#include "Defs.h"

#include "include/dart_api.h"
#include "include/dart_native_api.h"

using std::string;
using std::vector;

using OpenZWave::Driver;
using OpenZWave::LogLevel;
using OpenZWave::LogLevel_Alert;
using OpenZWave::LogLevel_Always;
using OpenZWave::LogLevel_Debug;
using OpenZWave::LogLevel_Detail;
using OpenZWave::LogLevel_Error;
using OpenZWave::LogLevel_Fatal;
using OpenZWave::LogLevel_Info;
using OpenZWave::LogLevel_Internal;
using OpenZWave::LogLevel_Invalid;
using OpenZWave::LogLevel_None;
using OpenZWave::LogLevel_StreamDetail;
using OpenZWave::LogLevel_Warning;
using OpenZWave::Manager;
using OpenZWave::Notification;
using OpenZWave::Options;
using OpenZWave::ValueID;

Dart_Handle HandleError(Dart_Handle handle) {
  if (Dart_IsError(handle)) {
    Dart_PropagateError(handle);
  }
  return handle;
}

bool HandleToBool(Dart_Handle handle) {
  bool value;
  HandleError(Dart_BooleanValue(HandleError(handle), &value));
  return value;
}

int64_t HandleToInt(Dart_Handle handle) {
  int64_t value;
  HandleError(Dart_IntegerToInt64(HandleError(handle), &value));
  return value;
}

Dart_Handle IntToHandle(int64_t value) {
  return HandleError(Dart_NewInteger(value));
}

string HandleToString(Dart_Handle handle) {
  HandleError(handle);
  const char* cstr;
  HandleError(Dart_StringToCString(handle, &cstr));
  string result (cstr);
  return result;
}

Dart_Handle StringToHandle(string str) {
  return HandleError(Dart_NewStringFromCString(str.c_str()));
}

// Native library connecting zwave.dart to the Open Z-Wave library
// See https://github.com/OpenZWave/open-zwave
//
// This code is heavily based on the article
// Native Extensions for the Standalone Dart VM
// https://www.dartlang.org/articles/native-extensions-for-standalone-dart-vm/#appendix-compiling-and-linking-extensions
// and the example code
// http://dart.googlecode.com/svn/trunk/dart/samples/sample_extension/

// ===== Native methods ===============================================
// Each native method must have an entry in either function_list or no_scope_function_list

// The port to which interrupt events are posted
// or null if initInterrupts has not yet been called.
static Dart_Port notificationPort = -1;

// static uint32 g_homeId = 0;
// static bool   g_initFailed = false;
//
// typedef struct
// {
//   uint32      m_homeId;
//   uint8      m_nodeId;
//   bool      m_polled;
//   list<ValueID>  m_values;
// }NodeInfo;
//
// static list<NodeInfo*> g_nodes;
static pthread_mutex_t g_criticalSection;
// static pthread_cond_t  initCond  = PTHREAD_COND_INITIALIZER;
static pthread_mutex_t initMutex = PTHREAD_MUTEX_INITIALIZER;

// Initialize the native library.
// This is called once by the zwave_ext_Init method in the Infrastructure section below.
Dart_Handle open_zwave_init() {

  pthread_mutexattr_t mutexattr;

  pthread_mutexattr_init ( &mutexattr );
  pthread_mutexattr_settype( &mutexattr, PTHREAD_MUTEX_RECURSIVE );
  pthread_mutex_init( &g_criticalSection, &mutexattr );
  pthread_mutexattr_destroy( &mutexattr );

  pthread_mutex_lock( &initMutex );

  return Dart_Null();
}

// // Return the NodeInfo object associated with this notification
// NodeInfo* GetNodeInfo(Notification const* _notification) {
//   uint32 const homeId = _notification->GetHomeId();
//   uint8 const nodeId = _notification->GetNodeId();
//   for( list<NodeInfo*>::iterator it = g_nodes.begin(); it != g_nodes.end(); ++it )
//   {
//     NodeInfo* nodeInfo = *it;
//     if( ( nodeInfo->m_homeId == homeId ) && ( nodeInfo->m_nodeId == nodeId ) )
//     {
//       return nodeInfo;
//     }
//   }
//
//   return NULL;
// }
//
// // Callback that is triggered when a value, group or node changes
void OnNotification(Notification const* _notification, void* _context) {
  if (notificationPort == -1) return;

  // Must do this inside a critical section to avoid conflicts with the main thread
  pthread_mutex_lock( &g_criticalSection );

  int64_t notificationType = _notification->GetType();
  Dart_CObject message;

  Dart_CObject notificationTypeValue = {
    Dart_CObject_kInt32, { .as_int32 = notificationType }
  };
  Dart_CObject homeId = {
    Dart_CObject_kInt64, { .as_int64 = _notification->GetHomeId() }
  };
  Dart_CObject nodeId = {
    Dart_CObject_kInt32, { .as_int32 = _notification->GetNodeId() }
  };

  switch( notificationType ) {
  //   case Notification::Type_DriverReset:

    case Notification::Type_CreateButton:
    case Notification::Type_ButtonOn:
    case Notification::Type_ButtonOff:
    case Notification::Type_DeleteButton: {
      uint32 bid = _notification->GetButtonId();
      Dart_CObject buttonId = {
        Dart_CObject_kInt32, { .as_int32 = bid }
      };
      Dart_CObject* messageParts[4] = {
        &notificationTypeValue,
        &homeId,
        &nodeId,
        &buttonId,
      };
      message.type = Dart_CObject_kArray;
      message.value.as_array.length = 4;
      message.value.as_array.values = messageParts;
      break;
    }

    case Notification::Type_SceneEvent: {
      uint8 sid = _notification->GetSceneId();
      Dart_CObject sceneId = {
        Dart_CObject_kInt32, { .as_int32 = sid }
      };
      Dart_CObject* messageParts[4] = {
        &notificationTypeValue,
        &homeId,
        &nodeId,
        &sceneId,
      };
      message.type = Dart_CObject_kArray;
      message.value.as_array.length = 4;
      message.value.as_array.values = messageParts;
      break;
    }

    case Notification::Type_Group: {
      uint8 gIndex = _notification->GetGroupIdx();
      Dart_CObject groupIndex = {
        Dart_CObject_kInt32, { .as_int32 = gIndex }
      };
      Dart_CObject* messageParts[4] = {
        &notificationTypeValue,
        &homeId,
        &nodeId,
        &groupIndex,
      };
      message.type = Dart_CObject_kArray;
      message.value.as_array.length = 4;
      message.value.as_array.values = messageParts;
      break;
    }

    case Notification::Type_Notification: {
      uint8 note = _notification->GetNotification();
      Dart_CObject notification = {
        Dart_CObject_kInt32, { .as_int32 = note }
      };
      Dart_CObject* messageParts[4] = {
        &notificationTypeValue,
        &homeId,
        &nodeId,
        &notification,
      };
      message.type = Dart_CObject_kArray;
      message.value.as_array.length = 4;
      message.value.as_array.values = messageParts;
      break;
    }

    case Notification::Type_DriverReady:
    case Notification::Type_DriverFailed:
    case Notification::Type_AwakeNodesQueried: // nodeId = 0xFF
    case Notification::Type_AllNodesQueried: // nodeId = 0xFF
    case Notification::Type_AllNodesQueriedSomeDead: // nodeId = 0xFF
    case Notification::Type_NodeNew:
    case Notification::Type_NodeAdded:
    case Notification::Type_NodeProtocolInfo:
    case Notification::Type_NodeNaming:
    case Notification::Type_NodeRemoved:
    case Notification::Type_NodeReset:
    case Notification::Type_EssentialNodeQueriesComplete:
    case Notification::Type_NodeQueriesComplete:
    case Notification::Type_PollingEnabled:
    case Notification::Type_PollingDisabled: {
      Dart_CObject* messageParts[3] = {
        &notificationTypeValue,
        &homeId,
        &nodeId,
      };
      message.type = Dart_CObject_kArray;
      message.value.as_array.length = 3;
      message.value.as_array.values = messageParts;
      break;
    }

    case Notification::Type_NodeEvent: {
      uint8 eventInt = _notification->GetEvent();
      Dart_CObject event = {
        Dart_CObject_kInt32, { .as_int32 = eventInt }
      };
      Dart_CObject* messageParts[4] = {
        &notificationTypeValue,
        &homeId,
        &nodeId,
        &event,
      };
      message.type = Dart_CObject_kArray;
      message.value.as_array.length = 4;
      message.value.as_array.values = messageParts;
      break;
    }

    case Notification::Type_ValueAdded:
    case Notification::Type_ValueChanged:
    case Notification::Type_ValueRefreshed:
    case Notification::Type_ValueRemoved: {
      ValueID vid = _notification->GetValueID();
      Dart_CObject valueId = {
        Dart_CObject_kInt64, { .as_int64 = vid.GetId() }
      };

      if (notificationType == Notification::Type_ValueAdded) {
        Dart_CObject valueType = {
          Dart_CObject_kInt32, { .as_int32 = vid.GetType() }
        };
        Dart_CObject* messageParts[5] = {
          &notificationTypeValue,
          &homeId,
          &nodeId,
          &valueId,
          &valueType,
        };
        message.type = Dart_CObject_kArray;
        message.value.as_array.length = 5;
        message.value.as_array.values = messageParts;

      } else {
        Dart_CObject* messageParts[4] = {
          &notificationTypeValue,
          &homeId,
          &nodeId,
          &valueId,
        };
        message.type = Dart_CObject_kArray;
        message.value.as_array.length = 4;
        message.value.as_array.values = messageParts;
      }
      break;
    }

    default: {
      message.type = Dart_CObject_kInt32;
      message.value.as_int32 = notificationType;
      break;
    }
  }

  pthread_mutex_unlock( &g_criticalSection );

  Dart_PostCObject(notificationPort, &message);
}

// Initialize the Open Z-Wave library.
// * configPath:
//     path to the config files
//     (where the manufacturer_specific.xml file is located)
//     On Raspberry Pi: /usr/local/etc/openzwave/
// * notificationPort:
//     The port used by the native library to forward notifications
// * logLevel
//     The Logger.Level.value indicating the logging level
// void _initialize(String configPath, SendPort notificationPort, int logLevel) native "initialize";
void initialize(Dart_NativeArguments arguments) {
  Dart_EnterScope();

  if (notificationPort != -1) {
    HandleError(Dart_NewApiError("already initialized"));
  }

  string configPath = HandleToString(Dart_GetNativeArgument(arguments, 1));

  string userPath;
  if (Dart_IsNull(Dart_GetNativeArgument(arguments, 2))) {
    userPath = "";
  } else {
    userPath = HandleToString(Dart_GetNativeArgument(arguments, 2));
  }

  Dart_Handle port_obj = HandleError(Dart_GetNativeArgument(arguments, 3));
  HandleError(Dart_SendPortGetId(port_obj, &notificationPort));

  LogLevel logLevel = LogLevel_Alert;
  Dart_Handle logLevel_obj = HandleError(Dart_GetNativeArgument(arguments, 4));
  if (!Dart_IsNull(logLevel_obj)) {
    int64_t logLevel_int = HandleToInt(logLevel_obj);
    if      (logLevel_int >= 2000) logLevel = LogLevel_None; // OFF
    else if (logLevel_int >= 1900) logLevel = LogLevel_Always;
    else if (logLevel_int >= 1200) logLevel = LogLevel_Fatal; // SHOUT
    else if (logLevel_int >= 1000) logLevel = LogLevel_Error; //SEVERE
    else if (logLevel_int >= 900)  logLevel = LogLevel_Warning; // WARNING
    else if (logLevel_int >= 850)  logLevel = LogLevel_Alert;
    else if (logLevel_int >= 800)  logLevel = LogLevel_Info; //INFO
    else if (logLevel_int >= 700)  logLevel = LogLevel_Info; // CONFIG
    else if (logLevel_int >= 500)  logLevel = LogLevel_Detail; // FINE
    else if (logLevel_int >= 400)  logLevel = LogLevel_Debug; // FINER
    else if (logLevel_int >= 300)  logLevel = LogLevel_StreamDetail; // FINEST
    else                           logLevel = LogLevel_Internal; // ALL
  }

  bool logToConsole = true;
  if (!Dart_IsNull(Dart_GetNativeArgument(arguments, 5))) {
    HandleError(Dart_BooleanValue(Dart_GetNativeArgument(arguments, 5), &logToConsole));
  }

  // Create the OpenZWave Manager.
  // The first argument is the path to the config files (where the manufacturer_specific.xml file is located
  // The second argument is the path for saved Z-Wave network state and the log file.  If you leave it NULL
  // the log file will appear in the program's working directory.
  Options::Create(configPath, userPath, "" );
  Options::Get()->AddOptionBool( "ConsoleOutput", logToConsole );
  Options::Get()->AddOptionInt( "SaveLogLevel", logLevel );
  Options::Get()->AddOptionInt( "QueueLogLevel", LogLevel_Debug );
  Options::Get()->AddOptionInt( "DumpTrigger", LogLevel_Error );
  Options::Get()->AddOptionInt( "PollInterval", 500 );
  Options::Get()->AddOptionBool( "IntervalBetweenPolls", true );
  Options::Get()->AddOptionBool( "ValidateValueChanges", true );
  Options::Get()->Lock();

  Manager::Create();

  // Add a callback handler to the manager.  The second argument is a context that
  // is passed to the OnNotification method.  If the OnNotification is a method of
  // a class, the context would usually be a pointer to that class object, to
  // avoid the need for the notification handler to be a static.
  Manager::Get()->AddWatcher( OnNotification, NULL );

  Dart_ExitScope();
}

// Connect to the Z-Wave controller.
// * port:
//     The port used to access the Z-Wave Controller. For example ...
//     Windows: "\\\\.\\COM6".
//     Mac OSX: "/dev/cu.usbserial"
//     Linux:   "/dev/ttyUSB0" or "/dev/ttyACM0"
// void _connect(String port) native "connect";
void connect(Dart_NativeArguments arguments) {
  Dart_EnterScope();

  string port = HandleToString(Dart_GetNativeArgument(arguments, 1));

  // Must do this inside a critical section to avoid conflicts with the notification thread
  pthread_mutex_lock( &g_criticalSection );

  // Add a Z-Wave Driver
  if( strcasecmp( port.c_str(), "usb" ) == 0 ) {
    Manager::Get()->AddDriver( "HID Controller", Driver::ControllerInterface_Hid );
  } else {
    Manager::Get()->AddDriver( port );
  }

  pthread_mutex_unlock( &g_criticalSection );

  Dart_ExitScope();
}

// Heal network by requesting node's rediscover their neighbors.
// _heal(int networkId, bool updateReturnRouting) native "heal";
void heal(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  uint32 homeId = HandleToInt(Dart_GetNativeArgument(arguments, 1));
  bool updateReturnRouting = HandleToBool(Dart_GetNativeArgument(arguments, 2));
  Manager::Get()->HealNetwork(homeId, updateReturnRouting);
  Dart_ExitScope();
}

// Deletes the Manager and cleans up any associated objects.
void destroy(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  Manager::Destroy();
  Dart_ExitScope();
}

// Start the Inclusion Process to add a Node to the Network.
// Return true if the command was successfully sent to the controller.
// bool _addNode(int networkId) native "addNode";
void addNode(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  uint32 homeId = HandleToInt(Dart_GetNativeArgument(arguments, 1));
  bool result = Manager::Get()->AddNode(homeId);
  Dart_SetReturnValue(arguments, HandleError(Dart_NewBoolean(result)));
  Dart_ExitScope();
}

// Start the process of removing a Device from the Z-Wave Network.
// Return true if the command was successfully sent to the controller.
// bool _removeNode(int networkId) native "removeNode";
void removeNode(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  uint32 homeId = HandleToInt(Dart_GetNativeArgument(arguments, 1));
  bool result = Manager::Get()->RemoveNode(homeId);
  Dart_SetReturnValue(arguments, HandleError(Dart_NewBoolean(result)));
  Dart_ExitScope();
}

// Get the basic type of a node
// _getNodeBasic(int networkId, int nodeId) native "getNodeBasic";
void getNodeBasic(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  uint32 homeId = HandleToInt(Dart_GetNativeArgument(arguments, 1));
  uint8 nodeId = HandleToInt(Dart_GetNativeArgument(arguments, 2));
  uint8 value = Manager::Get()->GetNodeBasic(homeId, nodeId);
  Dart_SetReturnValue(arguments, HandleError(Dart_NewInteger(value)));
  Dart_ExitScope();
}

// Get the generic type of a node
// _getNodeGeneric(int networkId, int nodeId) native "getNodeGeneric";
void getNodeGeneric(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  uint32 homeId = HandleToInt(Dart_GetNativeArgument(arguments, 1));
  uint8 nodeId = HandleToInt(Dart_GetNativeArgument(arguments, 2));
  uint8 value = Manager::Get()->GetNodeGeneric(homeId, nodeId);
  Dart_SetReturnValue(arguments, HandleError(Dart_NewInteger(value)));
  Dart_ExitScope();
}

// Get the specific type of a node
// _getNodeSpecific(int networkId, int nodeId) native "getNodeSpecific";
void getNodeSpecific(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  uint32 homeId = HandleToInt(Dart_GetNativeArgument(arguments, 1));
  uint8 nodeId = HandleToInt(Dart_GetNativeArgument(arguments, 2));
  uint8 value = Manager::Get()->GetNodeSpecific(homeId, nodeId);
  Dart_SetReturnValue(arguments, HandleError(Dart_NewInteger(value)));
  Dart_ExitScope();
}

// Get a human-readable label describing the node
// _getNodeType(int networkId, int nodeId) native "getNodeType";
void getNodeType(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  uint32 homeId = HandleToInt(Dart_GetNativeArgument(arguments, 1));
  uint8 nodeId = HandleToInt(Dart_GetNativeArgument(arguments, 2));
  string text = Manager::Get()->GetNodeType(homeId, nodeId);
  Dart_SetReturnValue(arguments, StringToHandle(text));
  Dart_ExitScope();
}

// Get the user-editable name of a node.
// _getNodeName(int networkId, int nodeId) native "getNodeName";
void getNodeName(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  uint32 homeId = HandleToInt(Dart_GetNativeArgument(arguments, 1));
  uint8 nodeId = HandleToInt(Dart_GetNativeArgument(arguments, 2));
  string text = Manager::Get()->GetNodeName(homeId, nodeId);
  Dart_SetReturnValue(arguments, StringToHandle(text));
  Dart_ExitScope();
}

// Set the name of a node.
// _setNodeName(int networkId, int nodeId, String newName) native "setNodeName";
void setNodeName(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  uint32 homeId = HandleToInt(Dart_GetNativeArgument(arguments, 1));
  uint8 nodeId = HandleToInt(Dart_GetNativeArgument(arguments, 2));
  string name = HandleToString(Dart_GetNativeArgument(arguments, 3));
  Manager::Get()->SetNodeName(homeId, nodeId, name);
  Dart_ExitScope();
}

// Get the manufacturer ID of a device, a four digit hex code.
// _getNodeManufacturerId(int networkId, int nodeId) native "getNodeManufacturerId";
void getNodeManufacturerId(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  uint32 homeId = HandleToInt(Dart_GetNativeArgument(arguments, 1));
  uint8 nodeId = HandleToInt(Dart_GetNativeArgument(arguments, 2));
  string text = Manager::Get()->GetNodeManufacturerId(homeId, nodeId);
  Dart_SetReturnValue(arguments, StringToHandle(text));
  Dart_ExitScope();
}

// Get the manufacturer name of a device.
// _getNodeManufacturerName(int networkId, int nodeId) native "getNodeManufacturerName";
void getNodeManufacturerName(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  uint32 homeId = HandleToInt(Dart_GetNativeArgument(arguments, 1));
  uint8 nodeId = HandleToInt(Dart_GetNativeArgument(arguments, 2));
  string text = Manager::Get()->GetNodeManufacturerName(homeId, nodeId);
  Dart_SetReturnValue(arguments, StringToHandle(text));
  Dart_ExitScope();
}

// Get the product ID of a device, a four digit hex code.
// _getNodeProductId(int networkId, int nodeId) native "getNodeProductId";
void getNodeProductId(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  uint32 homeId = HandleToInt(Dart_GetNativeArgument(arguments, 1));
  uint8 nodeId = HandleToInt(Dart_GetNativeArgument(arguments, 2));
  string text = Manager::Get()->GetNodeProductId(homeId, nodeId);
  Dart_SetReturnValue(arguments, StringToHandle(text));
  Dart_ExitScope();
}

// Get the product name of a device.
// _getNodeProductName(int networkId, int nodeId) native "getNodeProductName";
void getNodeProductName(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  uint32 homeId = HandleToInt(Dart_GetNativeArgument(arguments, 1));
  uint8 nodeId = HandleToInt(Dart_GetNativeArgument(arguments, 2));
  string text = Manager::Get()->GetNodeProductName(homeId, nodeId);
  Dart_SetReturnValue(arguments, StringToHandle(text));
  Dart_ExitScope();
}

// Get the product type of a device, a four digit hex code.
// _getNodeProductType(int networkId, int nodeId) native "getNodeProductType";
void getNodeProductType(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  uint32 homeId = HandleToInt(Dart_GetNativeArgument(arguments, 1));
  uint8 nodeId = HandleToInt(Dart_GetNativeArgument(arguments, 2));
  string text = Manager::Get()->GetNodeProductType(homeId, nodeId);
  Dart_SetReturnValue(arguments, StringToHandle(text));
  Dart_ExitScope();
}

// Get a nodeId list representing the neighboring devices of the specified device.
// _getNodeNeighbors(int networkId, int nodeId) native "getNodeNeighbors";
void getNodeNeighbors(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  uint32 homeId = HandleToInt(Dart_GetNativeArgument(arguments, 1));
  uint8 nodeId = HandleToInt(Dart_GetNativeArgument(arguments, 2));

  uint8* neighbors;
  uint32 numNeighbors = Manager::Get()->GetNodeNeighbors(homeId, nodeId, &neighbors);

  Dart_Handle list = HandleError(Dart_NewList(numNeighbors));
  if (numNeighbors > 0) {
    for (uint32 index = 0; index < numNeighbors; ++index) {
      uint8 neighborId = neighbors[index];
      HandleError(Dart_ListSetAt(list, index, HandleError(Dart_NewInteger(neighborId))));
    }
    delete [] neighbors;
  }

  Dart_SetReturnValue(arguments, list);
  Dart_ExitScope();
}

// Return a ValidID for arguments 1 (homeId) and 2 (valueId).
// The returned object *must* be deleted after use.
ValueID* ArgsToNewValueID(Dart_NativeArguments arguments) {
  uint32 homeId = HandleToInt(Dart_GetNativeArgument(arguments, 1));
  uint64 valueId = HandleToInt(Dart_GetNativeArgument(arguments, 2));
  ValueID* vid = new ValueID(homeId, valueId);
}

// Gets a value as a bool.
// _getValueAsBool(int networkId, int valueId) native "getValueAsBool";
void getValueAsBool(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  bool boolValue;
  Manager::Get()->GetValueAsBool(*vid, &boolValue);
  delete vid;
  Dart_SetReturnValue(arguments, HandleError(Dart_NewBoolean(boolValue)));
  Dart_ExitScope();
}

// Sets the state of a bool.
// _setBoolValue(int networkId, int valueId, bool newValue) native "setBoolValue";
void setBoolValue(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  bool boolValue = HandleToBool(Dart_GetNativeArgument(arguments, 3));
  Manager::Get()->SetValue(*vid, boolValue);
  delete vid;
  Dart_ExitScope();
}

// Gets a value as a byte.
// _getValueAsByte(int networkId, int valueId) native "getValueAsByte";
void getValueAsByte(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  uint8 byteValue;
  Manager::Get()->GetValueAsByte(*vid, &byteValue);
  delete vid;
  Dart_SetReturnValue(arguments, HandleError(Dart_NewInteger(byteValue)));
  Dart_ExitScope();
}

// Sets the value of a byte.
// _setByteValue(int networkId, int valueId, int newValue) native "setByteValue";
void setByteValue(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  uint8 byteValue = HandleToInt(Dart_GetNativeArgument(arguments, 3));
  Manager::Get()->SetValue(*vid, byteValue);
  delete vid;
  Dart_ExitScope();
}

// Gets a value as a float.
// _getValueAsFloat(int networkId, int id) native "getValueAsFloat";
void getValueAsFloat(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  float floatValue;
  Manager::Get()->GetValueAsFloat(*vid, &floatValue);
  delete vid;
  Dart_SetReturnValue(arguments, HandleError(Dart_NewDouble(floatValue)));
  Dart_ExitScope();
}

// Gets a value as an integer.
// _getValueAsInt(int networkId, int id) native "getValueAsInt";
void getValueAsInt(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  int32 intValue;
  Manager::Get()->GetValueAsInt(*vid, &intValue);
  delete vid;
  Dart_SetReturnValue(arguments, HandleError(Dart_NewInteger(intValue)));
  Dart_ExitScope();
}

// Sets the value of a 32-bit signed integer.
// _setIntValue(int networkId, int valueId, int newValue) native "setIntValue";
void setIntValue(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  int32 intValue = HandleToInt(Dart_GetNativeArgument(arguments, 3));
  Manager::Get()->SetValue(*vid, intValue);
  delete vid;
  Dart_ExitScope();
}

// Gets a value as a collection of bytes.
// _getValueAsRaw(int networkId, int id) native "getValueAsRaw";
void getValueAsRaw(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  uint8* o_value;
  uint8 o_length;
  Manager::Get()->GetValueAsRaw(*vid, &o_value, &o_length);
  delete vid;

  Dart_Handle list = HandleError(Dart_NewList(o_length));
  HandleError(Dart_ListSetAsBytes(list, 0, o_value, o_length));

//  intptr_t length = o_length;
//  Dart_Handle list = HandleError(Dart_NewList(length));
//  for (intptr_t index = 0; index < length; ++index) {
//    int64_t byteValue = *o_value;
//    HandleError(Dart_ListSetAt(list, index, IntToHandle(byteValue)));
//    ++o_value;
//  }
  Dart_SetReturnValue(arguments, list);
  Dart_ExitScope();
}

// Sets the value of a collection of bytes.
// _setRawValue(int networkId, int id, List<int> newValue) native "setRawValue";
void setRawValue(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  // TODO
  delete vid;
  Dart_ExitScope();
}

// Gets a value as a short.
// _getValueAsShort(int networkId, int id) native "getValueAsShort";
void getValueAsShort(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  int16 shortValue;
  Manager::Get()->GetValueAsShort(*vid, &shortValue);
  delete vid;
  Dart_SetReturnValue(arguments, HandleError(Dart_NewInteger(shortValue)));
  Dart_ExitScope();
}

// Sets the value of a 16-bit signed integer.
// _setShortValue(int networkId, int id, int newValue) native "setShortValue";
void setShortValue(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  int16 shortValue = HandleToInt(Dart_GetNativeArgument(arguments, 3));
  Manager::Get()->SetValue(*vid, shortValue);
  delete vid;
  Dart_ExitScope();
}

// Gets a value as a string.
// _getValueAsString(int networkId, int id) native "getValueAsString";
void getValueAsString(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  string stringValue;
  Manager::Get()->GetValueAsString(*vid, &stringValue);
  delete vid;
  Dart_SetReturnValue(arguments, StringToHandle(stringValue));
  Dart_ExitScope();
}

// Get the genre of the value.
// _getValueGenre(int networkId, int id) native "getValueGenre";
void getValueGenre(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  ValueID::ValueGenre genre = vid->GetGenre();
  delete vid;
  Dart_SetReturnValue(arguments, HandleError(Dart_NewInteger(genre)));
  Dart_ExitScope();
}

// Gets a help string describing the value's purpose and usage.
// _getValueHelp(int networkId, int id) native "getValueHelp";
void getValueHelp(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  string help = Manager::Get()->GetValueHelp(*vid);
  delete vid;
  Dart_SetReturnValue(arguments, StringToHandle(help));
  Dart_ExitScope();
}

// Get the value index.
// _getValueIndex(int networkId, int valueId) native "getValueIndex";
void getValueIndex(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  int index = vid->GetIndex();
  delete vid;
  Dart_SetReturnValue(arguments, IntToHandle(index));
  Dart_ExitScope();
}

// Gets the user-friendly label for the value.
// _getValueLabel(int networkId, int id) native "getValueLabel";
void getValueLabel(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  string label = Manager::Get()->GetValueLabel(*vid);
  delete vid;
  Dart_SetReturnValue(arguments, StringToHandle(label));
  Dart_ExitScope();
}

// Sets the user-friendly label for the value.
// _setValueLabel(int networkId, int valueId, String newLabel) native "setValueLabel";
void setValueLabel(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  string label = HandleToString(Dart_GetNativeArgument(arguments, 3));
  Manager::Get()->SetValueLabel(*vid, label);
  delete vid;
  Dart_ExitScope();
}

// Gets the list of items from a list value.
// _getValueListItems(int networkId, int id) native "getValueListItems";
void getValueListItems(Dart_NativeArguments arguments) {
  Dart_EnterScope();

  ValueID* vid = ArgsToNewValueID(arguments);
  vector<string> listItems;
  Manager::Get()->GetValueListItems(*vid, &listItems);
  delete vid;

  vector<string>::size_type len = listItems.size();
  Dart_Handle list = HandleError(Dart_NewList(len));
  for (unsigned index = 0; index < len; ++index) {
    string item = listItems.at(index);
    HandleError(Dart_ListSetAt(list, index, StringToHandle(item)));
  }

  Dart_SetReturnValue(arguments, list);
  Dart_ExitScope();
}

// Gets the selected item from a list (as a string).
// _getValueListSelection(int networkId, int id) native "getValueListSelection";
void getValueListSelection(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  string stringValue;
  Manager::Get()->GetValueListSelection(*vid, &stringValue);
  delete vid;
  Dart_SetReturnValue(arguments, StringToHandle(stringValue));
  Dart_ExitScope();
}

// Gets the selected item from a list (as a string).
// _getValueListSelectionIndex(int networkId, int id) native "getValueListSelectionIndex";
void getValueListSelectionIndex(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  int32 intValue;
  Manager::Get()->GetValueListSelection(*vid, &intValue);
  delete vid;
  Dart_SetReturnValue(arguments, HandleError(Dart_NewInteger(intValue)));
  Dart_ExitScope();
}

// Sets the selected item in a list.
// _setListSelectionValue(int networkId, int id, String newValue) native "setListSelectionValue";
void setListSelectionValue(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  string stringValue = HandleToString(Dart_GetNativeArgument(arguments, 3));
  Manager::Get()->SetValueListSelection(*vid, stringValue);
  delete vid;
  Dart_ExitScope();
}

// Get the minimum for an integer value.
// _getValueMin(int networkId, int id) native "getValueMin";
void getValueMin(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  int32 minValue = Manager::Get()->GetValueMin(*vid);
  delete vid;
  Dart_SetReturnValue(arguments, HandleError(Dart_NewInteger(minValue)));
  Dart_ExitScope();
}

// Get the maximum for an integer value.
// _getValueMax(int networkId, int id) native "getValueMax";
void getValueMax(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  int32 maxValue = Manager::Get()->GetValueMax(*vid);
  delete vid;
  Dart_SetReturnValue(arguments, HandleError(Dart_NewInteger(maxValue)));
  Dart_ExitScope();
}

// Test whether the value is read-only.
// _isValueReadOnly(int networkId, int id) native "isValueReadOnly";
void isValueReadOnly(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  bool readOnly = Manager::Get()->IsValueReadOnly(*vid);
  delete vid;
  Dart_SetReturnValue(arguments, HandleError(Dart_NewBoolean(readOnly)));
  Dart_ExitScope();
}

// Test whether the value is write-only.
// _isValueWriteOnly(int networkId, int id) native "isValueWriteOnly";
void isValueWriteOnly(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  bool writeOnly = Manager::Get()->IsValueWriteOnly(*vid);
  delete vid;
  Dart_SetReturnValue(arguments, HandleError(Dart_NewBoolean(writeOnly)));
  Dart_ExitScope();
}

// Get the polling intensity of a device's state.
// _pollIntensity(int networkId, int id) native "pollIntensity";
void pollIntensity(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  uint8 intensity = 0;
  if (Manager::Get()->isPolled(*vid)) {
    intensity = Manager::Get()->GetPollIntensity(*vid);
  }
  delete vid;
  Dart_SetReturnValue(arguments, IntToHandle(intensity));
  Dart_ExitScope();
}

// Return the time period between polls of a node's state.
// int get pollInterval native "pollInterval";
void pollInterval(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  int32 interval = Manager::Get()->GetPollInterval();
  Dart_SetReturnValue(arguments, IntToHandle(interval));
  Dart_ExitScope();
}

void refreshNodeInfo(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  uint32 homeId = HandleToInt(Dart_GetNativeArgument(arguments, 1));
  uint8 nodeId = HandleToInt(Dart_GetNativeArgument(arguments, 2));
  bool success = Manager::Get()->RefreshNodeInfo(homeId, nodeId);
  Dart_SetReturnValue(arguments, HandleError(Dart_NewBoolean(success)));
  Dart_ExitScope();
}

// Return the OpenZWave Version
// String version() native "version";
void version(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  string version = Manager::getVersionAsString();
  Dart_SetReturnValue(arguments, StringToHandle(version));
  Dart_ExitScope();
}

// Saves the configuration of a PC Controller's Z-Wave network to the application's user data folder.
// _writeConfig(int networkId) native "writeConfig";
void writeConfig(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  uint32 homeId = HandleToInt(Dart_GetNativeArgument(arguments, 1));
  Manager::Get()->WriteConfig(homeId);
  Dart_ExitScope();
}

// ===== Infrastructure methods ===============================================

struct FunctionLookup {
  const char* name;
  Dart_NativeFunction function;
};

FunctionLookup function_list[] = {
  {"addNode", addNode},
  {"connect", connect},
  {"destroy", destroy},
  {"getNodeBasic", getNodeBasic},
  {"getNodeGeneric", getNodeGeneric},
  {"getNodeSpecific", getNodeSpecific},
  {"getNodeType", getNodeType},
  {"getNodeManufacturerId", getNodeManufacturerId},
  {"getNodeManufacturerName", getNodeManufacturerName},
  {"getNodeName", getNodeName},
  {"getNodeNeighbors", getNodeNeighbors},
  {"getNodeProductId", getNodeProductId},
  {"getNodeProductName", getNodeProductName},
  {"getNodeProductType", getNodeProductType},
  {"getValueAsBool", getValueAsBool},
  {"getValueAsByte", getValueAsByte},
  {"getValueAsFloat", getValueAsFloat},
  {"getValueAsInt", getValueAsInt},
  {"getValueAsRaw", getValueAsRaw},
  {"getValueAsShort", getValueAsShort},
  {"getValueAsString", getValueAsString},
  {"getValueGenre", getValueGenre},
  {"getValueHelp", getValueHelp},
  {"getValueIndex", getValueIndex},
  {"getValueLabel", getValueLabel},
  {"getValueListItems", getValueListItems},
  {"getValueListSelection", getValueListSelection},
  {"getValueListSelectionIndex", getValueListSelectionIndex},
  {"getValueMin", getValueMin},
  {"getValueMax", getValueMax},
  {"heal", heal},
  {"initialize", initialize},
  {"isValueReadOnly", isValueReadOnly},
  {"isValueWriteOnly", isValueWriteOnly},
  {"pollIntensity", pollIntensity},
  {"pollInterval", pollInterval},
  {"refreshNodeInfo", refreshNodeInfo},
  {"removeNode", removeNode},
  {"setBoolValue", setBoolValue},
  {"setByteValue", setByteValue},
  {"setIntValue", setIntValue},
  {"setListSelectionValue", setListSelectionValue},
  {"setNodeName", setNodeName},
  {"setRawValue", setRawValue},
  {"setShortValue", setShortValue},
  {"setValueLabel", setValueLabel},
  {"version", version},
  {"writeConfig", writeConfig},
  {NULL, NULL}
};

FunctionLookup no_scope_function_list[] = {
  {NULL, NULL}
};

// Resolve the Dart name of the native function into a C function pointer.
// This is called once per native method.
Dart_NativeFunction ResolveName(Dart_Handle name,
                                int argc,
                                bool* auto_setup_scope) {
  if (!Dart_IsString(name)) {
    return NULL;
  }
  Dart_NativeFunction result = NULL;
  if (auto_setup_scope == NULL) {
    return NULL;
  }

  Dart_EnterScope();
  const char* cname;
  HandleError(Dart_StringToCString(name, &cname));

  for (int i=0; function_list[i].name != NULL; ++i) {
    if (strcmp(function_list[i].name, cname) == 0) {
      *auto_setup_scope = true;
      result = function_list[i].function;
      break;
    }
  }

  if (result != NULL) {
    Dart_ExitScope();
    return result;
  }

  for (int i=0; no_scope_function_list[i].name != NULL; ++i) {
    if (strcmp(no_scope_function_list[i].name, cname) == 0) {
      *auto_setup_scope = false;
      result = no_scope_function_list[i].function;
      break;
    }
  }

  Dart_ExitScope();
  return result;
}

// Initialize the native library.
// This is called once when the native library is loaded.
DART_EXPORT Dart_Handle ozw_ext_Init(Dart_Handle parent_library) {
  if (Dart_IsError(parent_library)) {
    return parent_library;
  }
  Dart_Handle result_code =
      Dart_SetNativeResolver(parent_library, ResolveName, NULL);
  if (Dart_IsError(result_code)) {
    return result_code;
  }
  result_code = open_zwave_init();
  if (Dart_IsError(result_code)) {
    return result_code;
  }
  return Dart_Null();
}
