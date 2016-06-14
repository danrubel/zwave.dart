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

int64_t HandleToInt(Dart_Handle handle) {
  int64_t value;
  HandleError(Dart_IntegerToInt64(HandleError(handle), &value));
  return value;
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

  switch( notificationType ) {
  //
  //   case Notification::Type_Group:
  //   {
  //     // One of the node's association groups has changed
  //     if( NodeInfo* nodeInfo = GetNodeInfo( _notification ) )
  //     {
  //       nodeInfo = nodeInfo;    // placeholder for real action
  //     }
  //     break;
  //   }
  //   case Notification::Type_NodeRemoved:
  //   {
  //     // Remove the node from our list
  //     uint32 const homeId = _notification->GetHomeId();
  //     uint8 const nodeId = _notification->GetNodeId();
  //     for( list<NodeInfo*>::iterator it = g_nodes.begin(); it != g_nodes.end(); ++it )
  //     {
  //       NodeInfo* nodeInfo = *it;
  //       if( ( nodeInfo->m_homeId == homeId ) && ( nodeInfo->m_nodeId == nodeId ) )
  //       {
  //         g_nodes.erase( it );
  //         delete nodeInfo;
  //         break;
  //       }
  //     }
  //     break;
  //   }
  //
  //   case Notification::Type_NodeEvent:
  //   {
  //     // We have received an event from the node, caused by a
  //     // basic_set or hail message.
  //     if( NodeInfo* nodeInfo = GetNodeInfo( _notification ) )
  //     {
  //       nodeInfo = nodeInfo;    // placeholder for real action
  //     }
  //     break;
  //   }
  //
  //   case Notification::Type_PollingDisabled:
  //   {
  //     if( NodeInfo* nodeInfo = GetNodeInfo( _notification ) )
  //     {
  //       nodeInfo->m_polled = false;
  //     }
  //     break;
  //   }
  //
  //   case Notification::Type_PollingEnabled:
  //   {
  //     if( NodeInfo* nodeInfo = GetNodeInfo( _notification ) )
  //     {
  //       nodeInfo->m_polled = true;
  //     }
  //     break;
  //   }
  //
  //   case Notification::Type_DriverReady:
  //   {
  //     g_homeId = _notification->GetHomeId();
  //     break;
  //   }
  //
  //   case Notification::Type_DriverFailed:
  //   {
  //     g_initFailed = true;
  //     pthread_cond_broadcast(&initCond);
  //     break;
  //   }
  //
  //   case Notification::Type_AwakeNodesQueried:
  //   case Notification::Type_AllNodesQueried:
  //   case Notification::Type_AllNodesQueriedSomeDead:
  //   {
  //     pthread_cond_broadcast(&initCond);
  //     break;
  //   }
  //
  //   case Notification::Type_DriverReset:
  //   case Notification::Type_Notification:
  //   case Notification::Type_NodeNaming:
  //   case Notification::Type_NodeProtocolInfo:
  //   case Notification::Type_NodeQueriesComplete:

    case Notification::Type_NodeAdded:
    case Notification::Type_NodeRemoved: {
      Dart_CObject notificationTypeValue = {
        Dart_CObject_kInt32, { .as_int32 = notificationType }
      };
      Dart_CObject homeId = {
        Dart_CObject_kInt64, { .as_int64 = _notification->GetHomeId() }
      };
      Dart_CObject nodeId = {
        Dart_CObject_kInt32, { .as_int32 = _notification->GetNodeId() }
      };
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

    case Notification::Type_ValueAdded:
    case Notification::Type_ValueChanged:
    case Notification::Type_ValueRefreshed:
    case Notification::Type_ValueRemoved: {
      ValueID vid = _notification->GetValueID();
      Dart_CObject notificationTypeValue = {
        Dart_CObject_kInt32, { .as_int32 = notificationType }
      };
      Dart_CObject homeId = {
        Dart_CObject_kInt64, { .as_int64 = _notification->GetHomeId() }
      };
      Dart_CObject nodeId = {
        Dart_CObject_kInt32, { .as_int32 = _notification->GetNodeId() }
      };
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
  Dart_Handle port_obj = HandleError(Dart_GetNativeArgument(arguments, 2));
  HandleError(Dart_SendPortGetId(port_obj, &notificationPort));

  LogLevel logLevel = LogLevel_Alert;
  Dart_Handle logLevel_obj = HandleError(Dart_GetNativeArgument(arguments, 3));
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

  // Create the OpenZWave Manager.
  // The first argument is the path to the config files (where the manufacturer_specific.xml file is located
  // The second argument is the path for saved Z-Wave network state and the log file.  If you leave it NULL
  // the log file will appear in the program's working directory.
  Options::Create(configPath, "", "" );
  Options::Get()->AddOptionInt( "SaveLogLevel", logLevel );
  Options::Get()->AddOptionInt( "QueueLogLevel", LogLevel_Debug );
  Options::Get()->AddOptionInt( "DumpTrigger", LogLevel_Error );
  Options::Get()->AddOptionInt( "PollInterval", 500 );
  Options::Get()->AddOptionBool( "IntervalBetweenPolls", true );
  Options::Get()->AddOptionBool("ValidateValueChanges", true);
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

// Gets a value as a string.
// _getValueAsString(int networkId, int id) native "getValueAsString";
void getValueAsString(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  ValueID* vid = ArgsToNewValueID(arguments);
  string stringValue;
  Manager::Get()->GetValueAsString(*vid, &stringValue);
  delete vid;
  Dart_SetReturnValue(arguments, HandleError(Dart_NewStringFromCString(stringValue.c_str())));
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
    HandleError(Dart_ListSetAt(list, index, HandleError(Dart_NewStringFromCString(item.c_str()))));
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
  Dart_SetReturnValue(arguments, HandleError(Dart_NewStringFromCString(stringValue.c_str())));
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

// Return the OpenZWave Version
// String version() native "version";
void version(Dart_NativeArguments arguments) {
  Dart_EnterScope();
  string version = Manager::getVersionAsString();
  Dart_SetReturnValue(arguments, StringToHandle(version));
  Dart_ExitScope();
}

// ===== Infrastructure methods ===============================================

struct FunctionLookup {
  const char* name;
  Dart_NativeFunction function;
};

FunctionLookup function_list[] = {
  {"connect", connect},
  {"getNodeBasic", getNodeBasic},
  {"getNodeGeneric", getNodeGeneric},
  {"getNodeSpecific", getNodeSpecific},
  {"getNodeType", getNodeType},
  {"getValueAsBool", getValueAsBool},
  {"getValueAsByte", getValueAsByte},
  {"getValueAsInt", getValueAsInt},
  {"getValueAsShort", getValueAsShort},
  {"getValueAsString", getValueAsString},
  {"getValueListItems", getValueListItems},
  {"getValueListSelection", getValueListSelection},
  {"getValueListSelectionIndex", getValueListSelectionIndex},
  {"getValueMin", getValueMin},
  {"getValueMax", getValueMax},
  {"initialize", initialize},
  {"version", version},
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
