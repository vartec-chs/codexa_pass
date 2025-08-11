import 'dart:collection';
import '../models/snack_bar_data.dart';

abstract class SnackBarQueueManager {
  void enqueue(SnackBarData data);
  SnackBarData? dequeue();
  bool get isEmpty;
  bool get isNotEmpty;
  int get length;
  void clear();
}

class DefaultSnackBarQueueManager implements SnackBarQueueManager {
  final Queue<SnackBarData> _queue = Queue<SnackBarData>();

  @override
  void enqueue(SnackBarData data) {
    _queue.addLast(data);
  }

  @override
  SnackBarData? dequeue() {
    if (_queue.isEmpty) return null;
    return _queue.removeFirst();
  }

  @override
  bool get isEmpty => _queue.isEmpty;

  @override
  bool get isNotEmpty => _queue.isNotEmpty;

  @override
  int get length => _queue.length;

  @override
  void clear() {
    _queue.clear();
  }
}
