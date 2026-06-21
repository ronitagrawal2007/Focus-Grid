import 'package:work_helper_app/Data/DailyTask.dart';
import 'package:work_helper_app/Data/DateDay.dart';
import 'package:work_helper_app/Data/TaskHistory.dart';
import 'package:work_helper_app/Data/WeeklyTask.dart';

List<Map<String, dynamic>> Task = [];

void toggleCheckBox(int index, bool? value) {
  // Update the actual value inside the list
  // Using ?? false protects against null values
  Task[index]['checkbox'] = value ?? false;
}

bool _isSameTask(Map<String, dynamic> a, Map<String, dynamic> b) {
  return a['taskName'] == b['taskName'] && a['type'] == b['type'];
}

/// Add all daily tasks and weekly tasks for today
void AddDailyTask() {
  for (var task in DailyTask) {
    if (!Task.any((existing) => _isSameTask(existing, task))) {
      Task.add({
        ...task,
        'checkbox': task['checkbox'] ?? false,
        'dateAdded': DateTime.now(),
      });
    }
  }
}

void AddWeeklyTask() {
  for (var task in WeeklyTask) {
    if (day_date[DateTime.now().day - 1]['day'] == task['type']) {
      if (!Task.any((existing) => _isSameTask(existing, task))) {
        Task.add({
          ...task,
          'checkbox': task['checkbox'] ?? false,
          'dateAdded': DateTime.now(),
        });
      }
    }
  }
}

/// Load tasks for a specific date (for task history view)
List<Map<String, dynamic>> getTasksForSpecificDate(DateTime date) {
  List<Map<String, dynamic>> tasksForDate = [];

  // Add all daily tasks
  for (var task in DailyTask) {
    tasksForDate.add({
      ...task,
      'checkbox': task['checkbox'] ?? false,
      'dateAdded': date,
    });
  }

  // Add weekly tasks if the day matches
  final dayOfWeek = date.weekday; // 1 = Mon, 7 = Sun
  const List<String> weekdayNames = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  final currentDayName = weekdayNames[dayOfWeek - 1];

  for (var task in WeeklyTask) {
    if (task['type'] == currentDayName) {
      if (!tasksForDate.any((existing) => _isSameTask(existing, task))) {
        tasksForDate.add({
          ...task,
          'checkbox': task['checkbox'] ?? false,
          'dateAdded': date,
        });
      }
    }
  }

  // Load saved completion status from task history
  final savedTasks = getTasksForDate(date);
  for (int i = 0; i < tasksForDate.length; i++) {
    final savedTask = savedTasks.firstWhere(
      (t) =>
          t['taskName'] == tasksForDate[i]['taskName'] &&
          t['type'] == tasksForDate[i]['type'],
      orElse: () => {},
    );
    if (savedTask.isNotEmpty) {
      tasksForDate[i]['checkbox'] = savedTask['checkbox'] ?? false;
    }
  }

  return tasksForDate;
}

/// Check if a date has any task history
bool hasTaskHistory(DateTime date) {
  return getTasksForSpecificDate(date).isNotEmpty;
}
