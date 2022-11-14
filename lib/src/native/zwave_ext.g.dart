//
// Generated from native/zwave_ext.cc
//
import 'dart:ffi' as ffi;

const nativePkgName = 'zwave';

class NativePgkLib {
  final ClosePort closePortMth;
  final LastError lastErrorMth;
  final OpenPort openPortMth;
  final ReadBytes readBytesMth;
  final WriteBytes writeBytesMth;

  NativePgkLib(ffi.DynamicLibrary dylib)
      : closePortMth = dylib
            .lookup<ffi.NativeFunction<ClosePortFfi>>('closePort')
            .asFunction<ClosePort>(),
        lastErrorMth = dylib
            .lookup<ffi.NativeFunction<LastErrorFfi>>('lastError')
            .asFunction<LastError>(),
        openPortMth = dylib
            .lookup<ffi.NativeFunction<OpenPortFfi>>('openPort')
            .asFunction<OpenPort>(),
        readBytesMth = dylib
            .lookup<ffi.NativeFunction<ReadBytesFfi>>('readBytes')
            .asFunction<ReadBytes>(),
        writeBytesMth = dylib
            .lookup<ffi.NativeFunction<WriteBytesFfi>>('writeBytes')
            .asFunction<WriteBytes>();
}

typedef ClosePort = int Function(int tty_fd);
typedef ClosePortFfi = ffi.Int64 Function(ffi.Int64 tty_fd);

typedef LastError = int Function();
typedef LastErrorFfi = ffi.Int64 Function();

typedef OpenPort = int Function(ffi.Pointer<ffi.Uint8> portPath);
typedef OpenPortFfi = ffi.Int64 Function(ffi.Pointer<ffi.Uint8> portPath);

typedef ReadBytes = int Function(
    int tty_fd, int maxNumBytesToRead, ffi.Pointer<ffi.Uint8> listPtr);
typedef ReadBytesFfi = ffi.Int64 Function(ffi.Int64 tty_fd,
    ffi.Int64 maxNumBytesToRead, ffi.Pointer<ffi.Uint8> listPtr);

typedef WriteBytes = int Function(
    int tty_fd, int numBytesToWrite, ffi.Pointer<ffi.Uint8> listPtr);
typedef WriteBytesFfi = ffi.Int64 Function(ffi.Int64 tty_fd,
    ffi.Int64 numBytesToWrite, ffi.Pointer<ffi.Uint8> listPtr);
