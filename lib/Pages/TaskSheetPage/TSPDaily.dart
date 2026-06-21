import 'package:flutter/material.dart';
import 'package:work_helper_app/Data/DailyTask.dart';

class TSPDaily extends StatefulWidget {
  const TSPDaily({super.key});

  @override
  State<TSPDaily> createState() => _TSPDailyState();
}

class _TSPDailyState extends State<TSPDaily> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              'Daily Task',
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: DailyTask.length,
                  itemBuilder: (context, index) {
                    final task = DailyTask[index];
                    return Dismissible(
                      key: Key('${task['taskName']}_${task['type']}_$index'),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        final removedTask = task;
                        setState(() {
                          removeDailyTask(removedTask);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${removedTask['taskName']} deleted'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete, color: Colors.white),
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
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  Expanded(child: SizedBox()),
                                  Text(
                                    DailyTask[index]['taskName'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(child: SizedBox()),
                                ],
                              ),
                              Expanded(child: SizedBox()),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
