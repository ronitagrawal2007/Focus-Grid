import 'package:hive/hive.dart';

late Box<dynamic> weeklyTask;

List<Map<String, dynamic>> WeeklyTask = [];

bool _isSameWeeklyTask(Map<String, dynamic> a, Map<String, dynamic> b) {
  return a['taskName'] == b['taskName'] && a['type'] == b['type'];
}

Map<String, dynamic> _toTaskMap(dynamic raw) {
  if (raw is Map) {
    return Map<String, dynamic>.from(raw.cast<String, dynamic>());
  }
  return {};
}

void initWeeklyTaskBox(Box<dynamic> box) {
  weeklyTask = box;
}

void WeeklyTaskTransfer() {
  for (var rawTask in weeklyTask.values) {
    final task = _toTaskMap(rawTask);
    if (task.isEmpty) continue;
    if (!WeeklyTask.any((existing) => _isSameWeeklyTask(existing, task))) {
      WeeklyTask.add(task);
    }
  }

  for (var task in WeeklyTask) {
    if (!weeklyTask.values.any((raw) {
      final existing = _toTaskMap(raw);
      return existing.isNotEmpty && _isSameWeeklyTask(existing, task);
    })) {
      weeklyTask.add(task);
    }
  }
}

void persistWeeklyTask(Map<String, dynamic> task) {
  if (!WeeklyTask.any((existing) => _isSameWeeklyTask(existing, task))) {
    WeeklyTask.add(task);
  }
  if (!weeklyTask.values.any((raw) {
    final existing = _toTaskMap(raw);
    return existing.isNotEmpty && _isSameWeeklyTask(existing, task);
  })) {
    weeklyTask.add(task);
  }
}

void removeWeeklyTask(Map<String, dynamic> task) {
  WeeklyTask.removeWhere((existing) => _isSameWeeklyTask(existing, task));
  
  int indexToRemove = -1;
  for (int i = 0; i < weeklyTask.length; i++) {
    final existing = _toTaskMap(weeklyTask.getAt(i));
    if (existing.isNotEmpty && _isSameWeeklyTask(existing, task)) {
      indexToRemove = i;
      break;
    }
  }
  if (indexToRemove != -1) {
    weeklyTask.deleteAt(indexToRemove);
  }
}
