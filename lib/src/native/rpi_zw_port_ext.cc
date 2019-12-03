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

// The errno from the last zwave call
static volatile int64_t lastErrno = 0;

// Open the zwave port on the specified port path.
// Return the file descriptor or a negative value indicating an error.
// int _openPort(String portPath) native "openPort";
void openPort(Dart_NativeArguments arguments) {
  Dart_EnterScope();

  const char* portPath;
  Dart_Handle dartString = HandleError(Dart_GetNativeArgument(arguments, 1));
  HandleError(Dart_StringToCString(dartString, &portPath));

  //tty_fd = open(portPath, O_RDWR | O_NOCTTY | O_NONBLOCK); // NetBSD ??
  int tty_fd = open(portPath, O_RDWR | O_NOCTTY, 0);
  if (tty_fd > 0) {
    if (flock(tty_fd, LOCK_EX | LOCK_NB) == -1) {
      close(tty_fd);
      tty_fd = -33;
    }
  }

  if (tty_fd > 0) {
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
      close(tty_fd);
      tty_fd = -34;
    }
  }

  if (tty_fd > 0) {
    tcflush(tty_fd, TCIOFLUSH);
    lastErrno = 0;
  } else {
    // Record the error if a step failed
    lastErrno = errno;
  }

  Dart_SetIntegerReturnValue(arguments, tty_fd);
  Dart_ExitScope();
}

// Read message bytes from the given tty file descriptor.
// Return an int if a single byte was read,
// a list of bytes if multiple bytes were read,
// null if there were no bytes available to be read,
// or a negative return value indicating an error.
// dynamic _read(int ttyFd) native "read";
void read(Dart_NativeArguments arguments) {
  Dart_EnterScope();

  Dart_Handle arg1 = HandleError(Dart_GetNativeArgument(arguments, 1));
  int64_t arg1Int;
  HandleError(Dart_IntegerToInt64(arg1, &arg1Int));
  int tty_fd = arg1Int;

  uint8_t values[256];
  intptr_t numRead = read(tty_fd, &values, sizeof(values));

  if (numRead > 1) {
    Dart_Handle data = HandleError(Dart_NewListOf(Dart_CoreType_Int, numRead));
    for (int index = 0; index < numRead; ++index) {
      Dart_Handle value = HandleError(Dart_NewInteger(values[index]));
      HandleError(Dart_ListSetAt(data, index, value));
    }
    Dart_SetReturnValue(arguments, data);
  } else if (numRead == 1) {
    Dart_SetIntegerReturnValue(arguments, values[0]);
  } else if (numRead == 0) {
    Dart_SetReturnValue(arguments, Dart_Null());
  } else {
    // return the error code
    lastErrno = errno;
    Dart_SetIntegerReturnValue(arguments, numRead);
  }

  Dart_ExitScope();
}

// Send the specified message bytes to the given tty file descriptor.
// Return the number of bytes sent, or a negative return value indicating an error.
// int _write(int ttyFd, List<int> bytes) native "write";
void write(Dart_NativeArguments arguments) {
  Dart_EnterScope();

  Dart_Handle arg1 = HandleError(Dart_GetNativeArgument(arguments, 1));
  int64_t arg1Int;
  HandleError(Dart_IntegerToInt64(arg1, &arg1Int));
  int tty_fd = arg1Int;

  intptr_t bytesLen;
  Dart_Handle bytesObj = HandleError(Dart_GetNativeArgument(arguments, 2));
  HandleError(Dart_ListLength(bytesObj, &bytesLen));

  int64_t result = 0;
  lastErrno = 0;

  if (bytesLen <= 0) {
    result == -36;
  } else if (bytesLen > 255) {
    result == -37;
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

// Close the zwave port.
// Return zero if successful or a negative value indicating an error.
// int _closePort(int ttyFd) native "closePort";
void closePort(Dart_NativeArguments arguments) {
  Dart_EnterScope();

  Dart_Handle arg1 = HandleError(Dart_GetNativeArgument(arguments, 1));
  int64_t arg1Int;
  HandleError(Dart_IntegerToInt64(arg1, &arg1Int));
  int tty_fd = arg1Int;

  flock(tty_fd, LOCK_UN);
  int64_t result = close(tty_fd);
  lastErrno = result < 0 ? errno : 0;

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
  {"read", read},
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
