#include <cstring>
#include <errno.h>
#include <fcntl.h>
#include <poll.h>
#include <sstream>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/file.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>
#include <termios.h>
#include <time.h>
#include <unistd.h>

#include "include/dart_api.h"
#include "include/dart_native_api.h"

Dart_Handle HandleError(Dart_Handle handle) {
  if (Dart_IsError(handle)) {
    Dart_PropagateError(handle);
  }
  return handle;
}

// The serial port file descriptor
// or -1 if the serial port has been closed.
static volatile int tty_fd = -1;

// The port to which data from the network is posted
// or -1 if openPort has not yet been called.
static Dart_Port notificationPort = -1;

// The errno from the last zwave call
static volatile int64_t lastErrno = 0;

// The id of the read thread so that it can be stopped
// if necessary by the close function.
pthread_t readThreadId;

// The current state of the read thread:
static const int readState_notStarted = 0;
static const int readState_running = 1;
static const int readState_requestStop = 2;
static const int readState_stopped = 3;
static volatile int readState = readState_notStarted;

// Background thread for reading the serial port.
void *readSerialPort(void *vargp) {

  // Detach this thread from the main thread
  pthread_detach(pthread_self());

  readState = readState_running;

  uint8_t values[256];
  int numRead;

  // Read and forward any messages from the port
  while (readState != readState_requestStop) {
    numRead = read(tty_fd, &values, sizeof(values));
    Dart_CObject message;
    if (numRead > 1) {
      message.type = Dart_CObject_kTypedData;
      message.value.as_typed_data.type = Dart_TypedData_kUint8;
      message.value.as_typed_data.length = numRead;
      message.value.as_typed_data.values = values;
      Dart_PostCObject(notificationPort, &message);
    } else if (numRead == 1) {
      message.type = Dart_CObject_kInt32;
      message.value.as_int32 = values[0];
      Dart_PostCObject(notificationPort, &message);
    } else {
      if (numRead < 0) {
        message.type = Dart_CObject_kInt32;
        message.value.as_int32 = numRead;
        Dart_PostCObject(notificationPort, &message);
        message.value.as_int32 = errno;
        Dart_PostCObject(notificationPort, &message);
      }

      pollfd fds = { .fd = tty_fd, .events = POLLIN | POLLPRI | POLLRDHUP };
      poll(&fds, 1, 100); // 100 ms timeout
    }
  }

  // Signal that the read thread is exiting
  readState = readState_stopped;

  pthread_exit(NULL);
}

// Open the zwave port and return zero if successful.
// Negative return values indicate an error.
// int _openPort(String portPath, SendPort sendPort) native "openPort";
void openPort(Dart_NativeArguments arguments) {
  Dart_EnterScope();

  if (notificationPort != -1) {
    HandleError(Dart_NewApiError("port already open"));
  }

  const char* portPath;
  Dart_Handle dartString = HandleError(Dart_GetNativeArgument(arguments, 1));
  HandleError(Dart_StringToCString(dartString, &portPath));

  Dart_Handle notificationObj = HandleError(Dart_GetNativeArgument(arguments, 2));
  HandleError(Dart_SendPortGetId(notificationObj, &notificationPort));

  int64_t result = 0;

  //tty_fd = open(portPath, O_RDWR | O_NOCTTY | O_NONBLOCK); // NetBSD ??
  tty_fd = open(portPath, O_RDWR | O_NOCTTY, 0);
  if (tty_fd <= 0) {
    result = tty_fd;
  }

  if (result == 0) {
    if (flock(tty_fd, LOCK_EX | LOCK_NB) == -1) {
      result = -33;
    }
  }

  if (result == 0) {
    int bits;
    bits = 0;
    ioctl(tty_fd, TIOCMSET, &bits);

    struct termios tio;
    memset(&tio, 0, sizeof(tio));

    // Retrieve the current terminal settings
    tcgetattr(tty_fd, &tio);

    // AeoTec Z-Stick = 115200 baud, 8 bits, 1 stop bit, no parity

    // -- baud

    //    cfsetspeed(&tio, B9600);        // 9600 baud
    //    cfsetspeed(&tio, B76800);       // 76800 baud
    cfsetspeed(&tio, B115200);      // 115200 baud

    // -- bits

    tio.c_cflag |= CS8; // 8 bits

    // -- stop bits

    // the default - one stop bit

    // OR alternately - two stop bits
    //    tio.c_cflag |= CSTOPB;

    // -- parity

    tio.c_iflag = IGNPAR; // no parity

    // OR alternately - odd parity
    //    tio.c_iflag = INPCK;
    //    tio.c_cflag = PARENB | PARODD;

    tio.c_cflag |= CREAD;             // Enable receiver
    tio.c_cflag |= CLOCAL;            // Ignore modem control lines

    tio.c_iflag |= IGNBRK;            // Ignore BREAK condition on input
    tio.c_oflag = 0;
    tio.c_lflag = 0;
    for( int i = 0; i < NCCS; i++ ) tio.c_cc[i] = 0;
    tio.c_cc[VMIN] = 0;
    tio.c_cc[VTIME] = 1;

    if (tcsetattr(tty_fd, TCSANOW, &tio) == -1) {
      result = -34;
    }
  }

  if (result == 0) {
    tcflush(tty_fd, TCIOFLUSH);

    // Start a background thread for reading from the serial port
    result = pthread_create(&readThreadId, NULL, readSerialPort, NULL);
  }

  if (result == 0) {
    lastErrno = 0;
  } else {
    // Record the error if a step failed
    lastErrno = errno;
    if (tty_fd > 0) {
      // On fail, close the port if it was opened
      close(tty_fd);
      // TODO change so that tty_fd == 0 indicates closed
      tty_fd = -1;
    }
  }

  Dart_SetIntegerReturnValue(arguments, result);
  Dart_ExitScope();
}

// Send the specified message bytes.
// Return the number of bytes sent, or a
// negative return value indicating an error.
// int _write(List<int> bytes) native "write";
void write(Dart_NativeArguments arguments) {
  Dart_EnterScope();

  intptr_t bytesLen;
  Dart_Handle bytesObj = HandleError(Dart_GetNativeArgument(arguments, 1));
  HandleError(Dart_ListLength(bytesObj, &bytesLen));

  int64_t result = 0;
  lastErrno = 0;

  if (bytesLen <= 0) {
    result == -36;
  } else if (bytesLen > 255) {
    result == -37;
  } else if (notificationPort == -1) {
    result = -38;
  } else {
    const int bufferLen = 5;
    uint8_t buffer[bufferLen];
    int bufferIndex = 0;
    result = 0;
    for (intptr_t bytesIndex = 0; bytesIndex < bytesLen; ++bytesIndex) {
      uint64_t value;
      Dart_Handle dartValue = HandleError(Dart_ListGetAt(bytesObj, bytesIndex));
      HandleError(Dart_IntegerToUint64(dartValue, &value));
      buffer[bufferIndex] = value & 0xFF;
      ++bufferIndex;
      if (bufferIndex == bufferLen) {
        int count = write(tty_fd, buffer, bufferIndex);
        bufferIndex = 0;
        if (count == bufferLen) {
          result += count;
        } else {
          result = count;
          break;
        }
      }
    }
    if (bufferIndex > 0) {
      int count = write(tty_fd, buffer, bufferIndex);
      if (count == bufferIndex) {
        result += count;
      } else {
        result = count;
      }
    }
    if (result <= bufferLen) {
      lastErrno = errno;
    }
  }

  Dart_SetIntegerReturnValue(arguments, result);
  Dart_ExitScope();
}

// Close the zwave port and return zero if successful.
// Negative return values indicate an error.
// int _closePort() native "closePort";
void closePort(Dart_NativeArguments arguments) {
  Dart_EnterScope();

  int64_t result = 0;
  lastErrno = 0;

  // Signal the read thread to stop
  readState = readState_requestStop;

  // Wait for the read thread to stop
  int waitCount = 1000;
  while (readState != readState_stopped && waitCount > 0) {
    timespec ts = { .tv_sec = 0, .tv_nsec = 1000000 }; // 1 ms
    nanosleep(&ts, NULL);
    --waitCount;
  }
  if (waitCount == 0) {
    // If not stopped, kill the thread
    // TODO kill the read thread
    result = -19;
  }

  flock(tty_fd, LOCK_UN);
  int value = close(tty_fd);
  if (value < 0) {
    result = value;
    lastErrno = errno;
  }
  tty_fd = -1;
  notificationPort = -1;

  Dart_SetIntegerReturnValue(arguments, result);
  Dart_ExitScope();
}

// Return the errno from the last I2C command
// int _lastError() native "lastError";
void lastError(Dart_NativeArguments arguments) {
  Dart_EnterScope();

  Dart_SetIntegerReturnValue(arguments, lastErrno);
  Dart_ExitScope();
}

// ===== Infrastructure methods ===============================================

struct FunctionLookup {
  const char* name;
  Dart_NativeFunction function;
};

FunctionLookup function_list[] = {
  {"closePort", closePort},
  {"lastError", lastError},
  {"openPort", openPort},
  {"write", write},
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
DART_EXPORT Dart_Handle rpi_zw_port_ext_Init(Dart_Handle parent_library) {
  if (Dart_IsError(parent_library)) {
    return parent_library;
  }
  Dart_Handle result_code =
      Dart_SetNativeResolver(parent_library, ResolveName, NULL);
  if (Dart_IsError(result_code)) {
    return result_code;
  }
  return Dart_Null();
}
