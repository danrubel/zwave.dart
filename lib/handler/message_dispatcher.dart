import 'package:zwave/src/function_handler_base.g.dart';
import 'package:zwave/src/zw_decoder.dart' show SOF;

/// [MessageDispatcher] processes Z-Wave messages received from the controller
/// and dispatches them to the various handle<FunctionName> methods in this
/// class. Subclasses should override these handle methods as necessary.
abstract class MessageDispatcher<T> extends FunctionHandlerBase<T> {
  @override
  T dispatch(List<int> data) {
    if (data == null || data.length < 5) {
      logger.warning('packet too small: $data');
      return null;
    }
    if (data[0] != SOF) {
      logger.warning('expected SOF (1st byte) to be $SOF in $data');
      return null;
    }
    var expectedLen = data.length - 2;
    if (data[1] != expectedLen) {
      logger.warning('expected length (2nd byte) to be $expectedLen in $data');
      return null;
    }
    int expectedCrc = 0xFF;
    for (int index = 1; index < data.length - 1; ++index) {
      expectedCrc ^= data[index];
    }
    if (data[data.length - 1] != expectedCrc) {
      logger.warning('expected CRC (last byte) to be $expectedCrc in $data');
      return null;
    }
    return super.dispatch(data);
  }
}
