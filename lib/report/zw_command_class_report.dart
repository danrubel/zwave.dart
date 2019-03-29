import 'package:zwave/zw_message.dart';

class ZwCommandClassReport extends ZwMessage {
  final List<int> data;

  ZwCommandClassReport(this.data);

  int get sourceNode => data[5];

  int get commandClass => data[7];

  int get command => data[8];
}

int bytesToInt(List<int> byteValues) {
  int value = byteValues[0];
  for (int i = 1; i < byteValues.length; ++i) {
    value = value * 256 + byteValues[i];
  }
  return value;
}

num bytesToNum(List<int> byteValues, int precision2) {
  // TODO 2's complement byteValues for proper interpretation
  // Uint8List, ByteData.view(...).getInt32
  // https://api.dartlang.org/stable/2.1.0/dart-typed_data/ByteData-class.html
  num result = bytesToInt(byteValues);
  for (int count = precision2; count > 0; --count) {
    result /= 10;
  }
  return result;
}
