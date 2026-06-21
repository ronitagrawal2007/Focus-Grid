import 'package:flutter/material.dart';
import 'package:work_helper_app/Data/DailyTask.dart';
import 'package:work_helper_app/Data/HomeTask.dart';
import 'package:work_helper_app/Data/TaskHistory.dart';
import 'package:work_helper_app/Data/WeeklyTask.dart';

class TaskAddedProvider extends ChangeNotifier {
  String _taskName = '';
  String _type = '';
  int _shortTypeInt = 0;
  String _shortType = '';

  String get taskName => _taskName;
  String get type => _type;
  int get shortTypeInt => _shortTypeInt;
  String get shortType => _shortType;

  void addTaskInList(String taskName, String type) {
    _taskName = taskName;
    _type = type;
    final today = DateTime.now();
    final todayName = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun',
    }[today.weekday];

    if (_type == 'Daily') {
      final task = {'checkbox': false, 'taskName': _taskName, 'type': 'daily'};
      persistDailyTask(task);
      saveTaskForDate(today, task);
      AddDailyTask();
    } else if (_type == 'Weekly') {
      _shortTypeInt = DateTime.now().weekday; // 1 (Mon) .. 7 (Sun)
      final map = {
        1: 'Mon',
        2: 'Tue',
        3: 'Wed',
        4: 'Thu',
        5: 'Fri',
        6: 'Sat',
        7: 'Sun',
      };
      _shortType = map[_shortTypeInt] ?? 'Mon';
      final task = {
        'checkbox': false,
        'taskName': _taskName,
        'type': _shortType,
      };
      persistWeeklyTask(task);
      if (todayName == _shortType) {
        saveTaskForDate(today, task);
      }
      AddWeeklyTask();
    }
    notifyListeners();
  }
}
