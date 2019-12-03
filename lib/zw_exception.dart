class ZwException {
  final String message;

  static const sendCanceled = ZwException('send canceled');
  static const sendCorrupted = ZwException('send corrupted');
  static const sendFailed = ZwException('send failed');
  static const sendTimeout = ZwException('send timeout');
  static const responseTimeout = ZwException('response timeout');
  static const resultTimeout = ZwException('result timeout');

  const ZwException(this.message);

  bool get isSendCanceledCorruptedOrTimeout =>
      this == sendCanceled || this == sendCorrupted || this == sendTimeout;

  @override
  String toString() {
    return 'ZwException($message)';
  }
}
