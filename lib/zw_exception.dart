class ZwException {
  final String message;

  static const sendCanceled = const ZwException('send canceled');
  static const sendCorrupted = const ZwException('send corrupted');
  static const sendFailed = const ZwException('send failed');
  static const sendTimeout = const ZwException('send timeout');
  static const responseTimeout = const ZwException('response timeout');
  static const resultTimeout = const ZwException('result timeout');

  const ZwException(this.message);

  bool get isSendCanceledCorruptedOrTimeout =>
      this == sendCanceled || this == sendCorrupted || this == sendTimeout;

  @override
  String toString() {
    return 'ZwException($message)';
  }
}
