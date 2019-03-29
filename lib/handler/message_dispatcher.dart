import 'package:zwave/src/function_handler_base.g.dart';

/// [MessageDispatcher] processes Z-Wave messages received from the controller
/// and dispatches them to the various handle<FunctionName> methods in this
/// class. Subclasses should override these handle methods as necessary.
abstract class MessageDispatcher<T> extends FunctionHandlerBase<T> {
  // TODO extract methods from ZwManager
}