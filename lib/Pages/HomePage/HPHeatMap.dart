import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:work_helper_app/Data/TaskHistory.dart';

class HPHeatMap extends StatelessWidget {
  const HPHeatMap({super.key});

  Color _heatColor(BuildContext context, double ratio) {
    if (ratio <= 0) {
      return Theme.of(context).colorScheme.surface.withOpacity(0.2);
    }
    if (ratio >= 1) {
      return Colors.green.shade700;
    }
    if (ratio >= 0.6) {
      return Colors.lightGreen.shade600;
    }
    if (ratio >= 0.3) {
      return Colors.orange.shade400;
    }
    return Colors.red.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<dynamic>>(
      valueListenable: taskHistoryBox.listenable(),
      builder: (context, box, _) {
        final now = DateTime.now();
        final todayDate = DateTime(now.year, now.month, now.day);
        final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Task Heatmap',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 110,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 1,
                  ),
                  itemCount: daysInMonth,
                  itemBuilder: (context, index) {
                    final date = DateTime(now.year, now.month, index + 1);
                    final tasks = getTasksForDate(date);
                    final total = tasks.length;
                    final completed = tasks
                        .where((task) => task['checkbox'] == true)
                        .length;
                    final ratio = total == 0 ? 0.0 : completed / total;
                    final isToday =
                        date.year == todayDate.year &&
                        date.month == todayDate.month &&
                        date.day == todayDate.day;
                    return Container(
                      decoration: BoxDecoration(
                        color: _heatColor(context, ratio),
                        borderRadius: BorderRadius.circular(8),
                        border: isToday
                            ? Border.all(color: Colors.blueAccent, width: 2)
                            : Border.all(color: Colors.transparent),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: ratio > 0
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            if (total > 0)
                              Text(
                                '${completed}/${total}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withOpacity(0.85),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _LegendItem(color: Colors.red.shade300, label: 'Low'),
                  _LegendItem(color: Colors.orange.shade400, label: 'Medium'),
                  _LegendItem(color: Colors.green.shade700, label: 'Done'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
