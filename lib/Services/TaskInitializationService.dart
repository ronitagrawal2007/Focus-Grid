import 'package:work_helper_app/Data/DailyTask.dart';
import 'package:work_helper_app/Data/TaskHistory.dart';
import 'package:work_helper_app/Data/WeeklyTask.dart';

/// Initialize today's tasks in the history
void initializeTodaysTasks() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // Initialize daily tasks for today
  for (var task in DailyTask) {
    saveTaskForDate(today, {
      'taskName': task['taskName'],
      'type': task['type'],
      'checkbox': false,
    });
  }

  // Initialize weekly tasks for today if applicable
  final dayOfWeek = today.weekday;
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
      saveTaskForDate(today, {
        'taskName': task['taskName'],
        'type': task['type'],
        'checkbox': false,
      });
    }
  }
}
