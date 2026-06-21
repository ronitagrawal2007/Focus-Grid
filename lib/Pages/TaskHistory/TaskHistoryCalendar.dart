import 'package:flutter/material.dart';
import 'package:work_helper_app/Data/UpdatedHomeTask.dart';

class TaskHistoryCalendar extends StatefulWidget {
  const TaskHistoryCalendar({super.key});

  @override
  State<TaskHistoryCalendar> createState() => _TaskHistoryCalendarState();
}

class _TaskHistoryCalendarState extends State<TaskHistoryCalendar> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  // Dynamically calculate days in the selected month
  int get _daysInMonth =>
      DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;

  // Calculates which day of the week the month starts on (0 for Mon, 6 for Sun)
  int get _firstDayOffset {
    int weekday = DateTime(_selectedDate.year, _selectedDate.month, 1).weekday;
    return weekday - 1; // Adjusts standard 1-7 (Mon-Sun) to 0-6 index
  }

  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
    });
  }

  void _previousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
    });
  }

  String _getWeekdayName(DateTime date) {
    const List<String> weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    return weekdays[date.weekday - 1];
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final int totalGridItems = _daysInMonth + _firstDayOffset;

    return Scaffold(
      appBar: AppBar(
        title: Text('${_monthName(_selectedDate.month)} ${_selectedDate.year}'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _previousMonth,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextMonth,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Weekday Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Expanded(
                      child: Center(
                        child: Text(
                          'Mon',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Tue',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Wed',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Thu',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Fri',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Sat',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Sun',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Calendar Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: totalGridItems,
                  itemBuilder: (context, index) {
                    // Render empty slots for days before the 1st of the month
                    if (index < _firstDayOffset) {
                      return const SizedBox.shrink();
                    }

                    int day = index - _firstDayOffset + 1;
                    DateTime date = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      day,
                    );

                    bool hasHistory = hasTaskHistory(date);
                    bool isToday =
                        date.year == DateTime.now().year &&
                        date.month == DateTime.now().month &&
                        date.day == DateTime.now().day;

                    return GestureDetector(
                      onTap: () => _showDayTasks(date),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isToday ? Colors.blue : Colors.grey.shade300,
                            width: isToday ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: hasHistory
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.transparent,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$day',
                              style: TextStyle(
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isToday ? Colors.blue : Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            if (hasHistory)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDayTasks(DateTime date) {
    final tasks = getTasksForSpecificDate(date);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '${_getWeekdayName(date)}, ${date.day} ${_monthName(date.month)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(child: Text('No tasks for this day'))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return CheckboxListTile(
                          title: Text(task['taskName'] ?? 'Unknown'),
                          subtitle: Text(task['type'] ?? 'No type'),
                          value: task['checkbox'] ?? false,
                          onChanged: (value) {
                            // Update your data source status here if needed
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
