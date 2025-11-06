import 'dart:async';

typedef AsyncOperation = Future<void> Function();

class RetryService {
  RetryService._privateConstructor();
  static final RetryService instance = RetryService._privateConstructor();

  final List<AsyncOperation> _queue = [];
  bool _processing = false;

  void enqueue(AsyncOperation op) {
    _queue.add(op);
  }

  Future<void> processQueue() async {
    if (_processing) return;
    _processing = true;
    try {
      while (_queue.isNotEmpty) {
        final op = _queue.removeAt(0);
        try {
          await op();
        } catch (_) {
          _queue.add(op);
          await Future.delayed(const Duration(seconds: 3));
          break;
        }
      }
    } finally {
      _processing = false;
    }
  }
}
