import 'package:flutter/material.dart';
import 'package:work_helper_app/Data/HomeTask.dart'
    as home_data; // Aliased to clean up reference conflicts
import 'package:work_helper_app/Data/TaskHistory.dart';

class HPTaskList extends StatefulWidget {
  const HPTaskList({super.key});

  @override
  State<HPTaskList> createState() => _HPTaskListState();
}

class _HPTaskListState extends State<HPTaskList> {
  List<Map<String, dynamic>> _todayTasks = [];
  late final String _todayKey;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _todayKey = _getDateKey(today);
    _loadTodayTasks(today);
  }

  void _loadTodayTasks(DateTime today) {
    final tasks = getTasksForDate(today);
    if (tasks.isEmpty) {
      home_data.initializeTodayTasks();
    }
    setState(() {
      _todayTasks = getTasksForDate(today);
    });
  }

  String _getDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(15),
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Today: $_todayKey',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _todayTasks.length,
                    itemBuilder: (context, index) {
                      final task = _todayTasks[index];

                      // Pull the unique database ID assigned during initialization
                      final String taskId =
                          task['id'] ?? '${task['taskName']}_$index';

                      return Dismissible(
                        // FIX: Keyed explicitly against our backend string token
                        key: ValueKey(taskId),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          final removedTask = task;

                          setState(() {
                            // 1. Remove from database box storage
                            removeTaskForDate(DateTime.now(), removedTask);

                            // 2. Clear out from the global runtime list array inside HomeTask.dart
                            home_data.Task.removeWhere(
                              (t) => t['id'] == removedTask['id'],
                            );

                            // 3. Clear out from the local array state to update the UI correctly
                            _todayTasks.removeWhere(
                              (t) => t['id'] == removedTask['id'],
                            );
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${removedTask['taskName']} deleted',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: 65,
                            child: Row(
                              children: [
                                const SizedBox(width: 5),
                                Checkbox(
                                  value: task['checkbox'] ?? false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      task['checkbox'] = value ?? false;
                                      updateTaskCompletionStatus(
                                        DateTime.now(),
                                        task,
                                        value ?? false,
                                      );
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task['taskName'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(task['type'] ?? ''),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
