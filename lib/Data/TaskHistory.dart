import 'package:hive/hive.dart';

late Box<dynamic> taskHistoryBox;

// Store task history: key = "YYYY-MM-DD", value = list of task maps with completion status
Map<String, List<Map<String, dynamic>>> taskHistory = {};

void initTaskHistoryBox(Box<dynamic> box) {
  taskHistoryBox = box;
}

void loadTaskHistory() {
  taskHistory.clear();
  for (var entry in taskHistoryBox.keys) {
    final dateKey = entry.toString();
    // Skip reading our initialization flag keys into the UI task data map
    if (dateKey.startsWith('init_')) continue;

    final historyData = taskHistoryBox.get(entry);
    if (historyData is List) {
      taskHistory[dateKey] = List<Map<String, dynamic>>.from(
        historyData.map((item) => Map<String, dynamic>.from(item as Map)),
      );
    }
  }
}

String _getDateKey(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

// FIX: Tasks are now compared using a unique 'id' instead of just name and type
bool _isSameTask(Map<String, dynamic> a, Map<String, dynamic> b) {
  if (a['id'] != null && b['id'] != null) {
    return a['id'] == b['id'];
  }
  // Fallback if older data doesn't have an ID yet
  return a['taskName'] == b['taskName'] && a['type'] == b['type'];
}

List<Map<String, dynamic>> getTasksForDate(DateTime date) {
  final dateKey = _getDateKey(date);
  return taskHistory[dateKey] ?? [];
}

bool hasTaskForDate(DateTime date, Map<String, dynamic> task) {
  final dateKey = _getDateKey(date);
  if (!taskHistory.containsKey(dateKey)) {
    return false;
  }
  return taskHistory[dateKey]!.any((t) => _isSameTask(t, task));
}

void saveTaskForDate(DateTime date, Map<String, dynamic> task) {
  final dateKey = _getDateKey(date);
  if (!taskHistory.containsKey(dateKey)) {
    taskHistory[dateKey] = [];
  }

  // Ensure the task has a unique ID if it doesn't already
  if (task['id'] == null) {
    task['id'] = DateTime.now().microsecondsSinceEpoch.toString();
  }

  final existingIndex = taskHistory[dateKey]!.indexWhere(
    (t) => _isSameTask(t, task),
  );

  if (existingIndex >= 0) {
    taskHistory[dateKey]![existingIndex] = task;
  } else {
    taskHistory[dateKey]!.add(task);
  }

  taskHistoryBox.put(dateKey, taskHistory[dateKey]);
}

// FIX: Updated to accept the task object or ID to uniquely change completion status
void updateTaskCompletionStatus(
  DateTime date,
  Map<String, dynamic> task,
  bool isCompleted,
) {
  final dateKey = _getDateKey(date);
  if (!taskHistory.containsKey(dateKey)) {
    taskHistory[dateKey] = [];
  }

  final index = taskHistory[dateKey]!.indexWhere((t) => _isSameTask(t, task));

  if (index >= 0) {
    taskHistory[dateKey]![index]['checkbox'] = isCompleted;
  } else {
    // If it doesn't exist, generate an ID and add it
    if (task['id'] == null) {
      task['id'] = DateTime.now().microsecondsSinceEpoch.toString();
    }
    task['checkbox'] = isCompleted;
    taskHistory[dateKey]!.add(task);
  }

  taskHistoryBox.put(dateKey, taskHistory[dateKey]);
}

void clearDateHistory(DateTime date) {
  final dateKey = _getDateKey(date);
  taskHistory.remove(dateKey);
  taskHistoryBox.delete(dateKey);
  taskHistoryBox.delete(
    'init_$dateKey',
  ); // Also clear init flag if date wiped entirely
}

void removeTaskForDate(DateTime date, Map<String, dynamic> task) {
  final dateKey = _getDateKey(date);
  if (!taskHistory.containsKey(dateKey)) {
    return;
  }

  // Will now safely remove only the item matching the unique ID
  taskHistory[dateKey]!.removeWhere((t) => _isSameTask(t, task));

  taskHistoryBox.put(dateKey, taskHistory[dateKey]);
}

// ====================================================================
// NEW: Added Hive Day-Initialization tracking functions
// ====================================================================

/// Checks if a date string key has already executed its first-launch blueprint builds
bool isDayAlreadyInitialized(String dateKey) {
  return taskHistoryBox.get('init_$dateKey', defaultValue: false) as bool;
}

/// Permanently records that a date string key has run its blueprint injection
void markDayAsInitialized(String dateKey) {
  taskHistoryBox.put('init_$dateKey', true);
}
