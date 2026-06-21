import 'package:work_helper_app/Data/DailyTask.dart';
import 'package:work_helper_app/Data/TaskHistory.dart';
import 'package:work_helper_app/Data/WeeklyTask.dart';

List<Map<String, dynamic>> Task = [];

void toggleCheckBox(int index, bool? value) {
  Task[index]['checkbox'] = value ?? false;
}

// Helper to match tasks accurately using unique IDs or fallback traits
bool _isSameTask(Map<String, dynamic> a, Map<String, dynamic> b) {
  if (a['id'] != null && b['id'] != null) {
    return a['id'] == b['id'];
  }
  return a['taskName'] == b['taskName'] && a['type'] == b['type'];
}

String _getWeekdayName(DateTime date) {
  const List<String> weekdayNames = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  return weekdayNames[date.weekday - 1];
}

// Helper to generate a standardized string key for dates
String _getDateStringKey(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

Map<String, dynamic> _taskWithSavedStatus(
  Map<String, dynamic> task,
  DateTime date,
) {
  final savedTasks = getTasksForDate(date);
  final savedTask = savedTasks.firstWhere(
    (t) => t['taskName'] == task['taskName'] && t['type'] == task['type'],
    orElse: () => {},
  );

  return {
    ...task,
    'id': savedTask.isNotEmpty
        ? savedTask['id']
        : '${task['taskName']}_${task['type']}_${DateTime.now().microsecondsSinceEpoch}',
    'checkbox': savedTask.isNotEmpty ? (savedTask['checkbox'] ?? false) : false,
  };
}

/// Initializes the daily list.
/// Guaranteed to build missing blueprints only ONCE a day.
void initializeTodayTasks() {
  Task.clear();
  final today = DateTime.now();
  final todayName = _getWeekdayName(today);
  final String dateKey = _getDateStringKey(today);

  // 1. Pull whatever currently exists inside your actual database storage
  final savedTasks = getTasksForDate(today);
  for (var savedTask in savedTasks) {
    Task.add(Map<String, dynamic>.from(savedTask));
  }

  // 2. CHECK: Have we already built the default templates for today?
  // Note: We use a utility method 'isDayAlreadyInitialized(dateKey)' from TaskHistory.
  // If it doesn't exist yet, implement a simple boolean flag database lookup for that key.
  bool alreadyInitialized = isDayAlreadyInitialized(dateKey);

  if (!alreadyInitialized) {
    // 3. This block ONLY triggers the very first time the app is launched on a new day
    for (var task in DailyTask) {
      final taskWithStatus = {
        ...task,
        'id':
            '${task['taskName']}_daily_${DateTime.now().microsecondsSinceEpoch}',
        'checkbox': false,
      };
      Task.add(taskWithStatus);
      saveTaskForDate(today, taskWithStatus);
      _microDelay();
    }

    for (var task in WeeklyTask) {
      if (todayName == task['type']) {
        final taskWithStatus = {
          ...task,
          'id':
              '${task['taskName']}_weekly_${DateTime.now().microsecondsSinceEpoch}',
          'checkbox': false,
        };
        Task.add(taskWithStatus);
        saveTaskForDate(today, taskWithStatus);
        _microDelay();
      }
    }

    // 4. Lock the gate for today so this generation script never executes again
    markDayAsInitialized(dateKey);
  }
}

void AddDailyTask() {
  final today = DateTime.now();

  for (var task in DailyTask) {
    if (!Task.any((existing) => _isSameTask(existing, task))) {
      final taskWithStatus = _taskWithSavedStatus(task, today);
      Task.add(taskWithStatus);
      saveTaskForDate(today, taskWithStatus);
    }
  }
}

void AddWeeklyTask() {
  final today = DateTime.now();
  final todayName = _getWeekdayName(today);

  for (var task in WeeklyTask) {
    if (todayName == task['type']) {
      if (!Task.any((existing) => _isSameTask(existing, task))) {
        final taskWithStatus = _taskWithSavedStatus(task, today);
        Task.add(taskWithStatus);
        saveTaskForDate(today, taskWithStatus);
      }
    }
  }
}

// Helper to step out of CPU cycles for distinct timestamps
void _microDelay() {
  int i = 0;
  while (i < 5000) {
    i++;
  }
}
