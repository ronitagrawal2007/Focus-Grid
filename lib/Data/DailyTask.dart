import 'package:hive/hive.dart';

late Box<dynamic> dailyTask;

List<Map<String, dynamic>> DailyTask = [];

bool _isSameDailyTask(Map<String, dynamic> a, Map<String, dynamic> b) {
  return a['taskName'] == b['taskName'] && a['type'] == b['type'];
}

Map<String, dynamic> _toTaskMap(dynamic raw) {
  if (raw is Map) {
    return Map<String, dynamic>.from(raw.cast<String, dynamic>());
  }
  return {};
}

void initDailyTaskBox(Box<dynamic> box) {
  dailyTask = box;
}

void DailyTaskTransfer() {
  for (var rawTask in dailyTask.values) {
    final task = _toTaskMap(rawTask);
    if (task.isEmpty) continue;
    if (!DailyTask.any((existing) => _isSameDailyTask(existing, task))) {
      DailyTask.add(task);
    }
  }

  for (var task in DailyTask) {
    if (!dailyTask.values.any((raw) {
      final existing = _toTaskMap(raw);
      return existing.isNotEmpty && _isSameDailyTask(existing, task);
    })) {
      dailyTask.add(task);
    }
  }
}

void persistDailyTask(Map<String, dynamic> task) {
  if (!DailyTask.any((existing) => _isSameDailyTask(existing, task))) {
    DailyTask.add(task);
  }
  if (!dailyTask.values.any((raw) {
    final existing = _toTaskMap(raw);
    return existing.isNotEmpty && _isSameDailyTask(existing, task);
  })) {
    dailyTask.add(task);
  }
}

void removeDailyTask(Map<String, dynamic> task) {
  DailyTask.removeWhere((existing) => _isSameDailyTask(existing, task));
  
  int indexToRemove = -1;
  for (int i = 0; i < dailyTask.length; i++) {
    final existing = _toTaskMap(dailyTask.getAt(i));
    if (existing.isNotEmpty && _isSameDailyTask(existing, task)) {
      indexToRemove = i;
      break;
    }
  }
  if (indexToRemove != -1) {
    dailyTask.deleteAt(indexToRemove);
  }
}
