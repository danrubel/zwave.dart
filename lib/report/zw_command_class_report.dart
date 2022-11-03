import 'package:zwave/zw_message.dart';

class ZwCommandClassReport extends ZwMessage {
  @override
  final List<int> data;

  ZwCommandClassReport(this.data);

  int get sourceNode => data[5];

  int get commandClass => data[7];

  int get command => data[8];
}

int bytesToInt(List<int> byteValues) {
  var value = byteValues[0];
  for (var i = 1; i < byteValues.length; ++i) {
    value = value * 256 + byteValues[i];
  }
  return value;
}

num bytesToNum(List<int> byteValues, int precision) {
  // TODO 2's complement byteValues for proper interpretation
  // Uint8List, ByteData.view(...).getInt32
  // https://api.dartlang.org/stable/2.1.0/dart-typed_data/ByteData-class.html
  num result = bytesToInt(byteValues);
  for (var count = precision; count > 0; --count) {
    result /= 10;
  }
  return result;
}
