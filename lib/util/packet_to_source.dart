import 'package:logging/logging.dart';
import 'package:zwave/handler/application_command_handler.dart';
import 'package:zwave/handler/message_dispatcher.dart';
import 'package:zwave/message_consts.dart';
import 'package:zwave/report/security_message_encapsulation.dart';
import 'package:zwave/report/security_nonce_report.dart';
import 'package:zwave/report/sensor_multilevel_report.dart';
import 'package:zwave/src/command_class_names.g.dart';

/// Return a string with the packet's data in source form with comments
String packetToSource(List<int> data) {
  if (data == null) return '';
  final writer = _Writer(data);
  if (writer.writePacketHeader()) {
    _FuncIdProcessor(writer).dispatch(data);
    writer.writeRemainingBytes();
  }
  return writer.toString();
}

class _FuncIdProcessor extends MessageDispatcher<void> {
  final _Writer writer;

  _FuncIdProcessor(this.writer) {
    initHandlers();
  }

  @override
  Logger get logger => writer.logger;

  void handleApplicationCommandHandler(List<int> data) {
    if (writer.writeFuncIdApplicationCommandHeader()) {
      if (writer.bytesLeft > 1) {
        _ApplicationCommandProcessor(writer).dispatchApplicationCommand(data);
      }
    }
  }

  void handleZwSendData(List<int> data) {
    if (writer.writeFunctIdZwSendData()) {
      if (writer.bytesLeft > 2) {
        writer.comment('raw class command data - not decoded');
      }
      writer.writeTransmitOptions();
    }
  }

  void unhandledMessage(int functId, String functName, List<int> data) {
    writer.comment(functName);
  }

  void handleUnknownFunctionId(List<int> data) {
    writer.comment('FUNC_ID_???');
  }
}

class _ApplicationCommandProcessor extends ApplicationCommandHandler {
  final _Writer writer;

  _ApplicationCommandProcessor(this.writer);

  @override
  Logger get logger => writer.logger;

  void handleSensorMultilevelReport(SensorMultilevelReport report) {
    switch (writer.currentValue) {
      case SENSOR_MULTILEVEL_REPORT:
        if (!writer.writeByte()) return;
        switch (writer.currentValue) {
          case SENSOR_MULTILEVEL_AIR_TEMPERATURE:
            writer.comment('SENSOR_MULTILEVEL_AIR_TEMPERATURE');
            break;
          case SENSOR_MULTILEVEL_POWER:
            writer.comment('SENSOR_MULTILEVEL_POWER');
            break;
          case SENSOR_MULTILEVEL_HUMIDITY:
            writer.comment('SENSOR_MULTILEVEL_HUMIDITY');
            break;
          default:
            writer.comment(null);
            return;
        }
        if (!writer.writeByte()) return;
        writer.comment('precision ${report.precision}'
            ', scale ${report.scale}, size ${report.valueSize}');
        if (!writer.writeByte()) return;
        writer.comment(report.valueWithUnits);
        break;
    }
  }

  void handleSecurityMessageEncapsulation(SecurityMessageEncapsulation message) {
    if (!writer.writeBytes(8, 'init vector')) return;
    writer.comment('begin encrypted payload');

    if (!writer.writeByte()) return;
    writer.comment('bit fields');
    while (writer.bytesLeft > 10) {
      writer.writeByte();
      writer.comment(null);
    }
    writer.comment('end payload');

    if (!writer.writeByte()) return;
    writer.comment('receiver nonce key');
    writer.writeBytes(8, 'auth code');
  }

  @override
  void handleSecurityMessageEncapsulationNonceGet(SecurityMessageEncapsulation message) {
    handleSecurityMessageEncapsulation(message);
  }

  @override
  void handleSecurityNonceReport(SecurityNonceReport report) {
    writer.writeBytes(8, 'nonce');
  }

  void handleUnknownCommandClassId(int cmdId, List<int> data) {
    writer.comment('unknown command class id');
  }

  void unhandledCommandClass(int cmdId, String cmdName, List<int> data) {
    writer.comment('raw command class data');
  }
}

class _Writer {
  final Logger logger = Logger('ZwPacketPrinter');
  final List<int> orig;
  final buf = StringBuffer();
  int index = -1;
  int currentValue;

  _Writer(this.orig);

  int get bytesLeft => orig.length - index - 1;

  /// Write package header bytes. Return true if more bytes to be processed.
  bool writePacketHeader() {
    if (!writeByte()) return false;
    comment(currentValue == 1 ? 'SOF' : '??? expected SOF 0x01');
    if (!writeByte()) return false;
    comment('length ${currentValue} excluding SOF and checksum');
    int expLen = currentValue + 2;
    if (expLen != orig.length) comment('expected $expLen bytes in packet');
    if (!writeByte()) return false;
    commentAt(['request', 'response'], currentValue, '???');
    return writeByte();
  }

  /// Write command header bytes. Return true if more bytes to be processed.
  bool writeFuncIdApplicationCommandHeader() {
    comment('FUNC_ID_APPLICATION_COMMAND_HANDLER');
    if (!writeByte()) return false;
    comment('rxStatus');
    if (!writeByte()) return false;
    comment('source node $currentValue');
    if (!writeByte()) return false;
    comment('command length $currentValue');
    int cmdLen = currentValue;
    var expLen = cmdLen + 1;
    if (expLen != bytesLeft) {
      comment('expected $expLen more bytes');
    }
    if (!writeByte()) return false;
    var cmdClassId = currentValue;
    commentKey(COMMAND_CLASS_NAMES, cmdClassId, 'COMMAND_CLASS_???');
    if (!writeByte()) return false;
    commentKey(COMMAND_NAMES[cmdClassId], currentValue);
    return true;
  }

  /// Write command header bytes. Return true if more bytes to be processed.
  bool writeFunctIdZwSendData() {
    bool isNoOp = orig.length == 9 && orig[6] == COMMAND_CLASS_NO_OPERATION;
    comment('FUNC_ID_ZW_SEND_DATA');
    if (!writeByte()) return false;
    comment('source node $currentValue');
    if (!writeByte()) return false;
    comment('command length $currentValue');
    int cmdLen = currentValue;
    if (!isNoOp) {
      var expLen = cmdLen + 2;
      if (expLen != bytesLeft) {
        comment('expected $expLen more bytes');
      }
    }
    if (!writeByte()) return false;
    var cmdClassId = currentValue;
    commentKey(COMMAND_CLASS_NAMES, cmdClassId, 'COMMAND_CLASS_???');
    if (isNoOp) return true;
    if (!writeByte()) return false;
    commentKey(COMMAND_NAMES[cmdClassId], currentValue);
    return true;
  }

  void writeTransmitOptions() {
    // Write remaining bytes before transmit options
    while (bytesLeft > 2) {
      writeByte();
      comment(null);
    }
    if (!writeByte()) return;

    var options = StringBuffer();
    addOption(int bitMask, String name) {
      if (currentValue & bitMask == 0) return;
      if (options.isNotEmpty) options.write(', ');
      options.write(name);
    }

    // transmit options
    const TRANSMIT_OPTION_ACK = 0x01;
    const TRANSMIT_OPTION_LOW_POWER = 0x02;
    const TRANSMIT_OPTION_AUTO_ROUTE = 0x04;
    const TRANSMIT_OPTION_NO_ROUTE = 0x10;
    const TRANSMIT_OPTION_EXPLORE = 0x20;

    addOption(TRANSMIT_OPTION_EXPLORE, 'explore');
    addOption(TRANSMIT_OPTION_NO_ROUTE, 'no route');
    addOption(TRANSMIT_OPTION_AUTO_ROUTE, 'auto route');
    addOption(TRANSMIT_OPTION_LOW_POWER, 'low power');
    addOption(TRANSMIT_OPTION_ACK, 'ack');

    comment('transmit options: '
        '${options.isNotEmpty ? options.toString() : 'unknown'}');
  }

  bool writeByte() {
    if (bytesLeft <= 0) return false;
    ++index;
    currentValue = orig[index];
    buf.write(' 0x');
    buf.write(currentValue.toRadixString(16).toUpperCase().padLeft(2, '0'));
    buf.write(',');
    return true;
  }

  void comment(String text) {
    buf.writeln(text != null ? ' // $text' : '');
  }

  void commentAt(List<String> textList, int index, [String defaultText]) {
    comment(textList != null && index < textList.length
        ? textList[index]
        : defaultText);
  }

  void commentKey(Map<int, String> textMap, int index, [String defaultText]) {
    comment(textMap != null && textMap.containsKey(index)
        ? textMap[index]
        : defaultText);
  }

  bool writeBytes(int numBytes, String name) {
    for (int count = 1; count <= numBytes; ++count) {
      if (!writeByte()) {
        comment('expected $count $name bytes');
        return false;
      }
      comment('$name byte #$count');
    }
    return true;
  }

  void writeRemainingBytes() {
    while (bytesLeft > 1) {
      writeByte();
      comment(null);
    }
    if (writeByte()) {
      comment('checksum');
      int expectedCrc = 0xFF;
      for (int index = 1; index < orig.length - 1; ++index) {
        expectedCrc ^= orig[index];
      }
      if (orig[orig.length - 1] != expectedCrc) {
        comment('invalid checksum - expected $expectedCrc');
      }
    } else {
      buf.writeln(' // missing checksum');
    }
  }

  @override
  String toString() => buf.toString();
}
