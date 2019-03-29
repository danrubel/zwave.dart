abstract class ZwMessage {
  List<int> get data;

  @override
  String toString() {
    try {
      return '$runtimeType($data)';
    } catch (e) {
      return '$runtimeType(...)';
    }
  }
}
