import 'package:flutter/material.dart';
import 'package:work_helper_app/Data/WeeklyTask.dart';

class TSPWeekly extends StatefulWidget {
  const TSPWeekly({super.key});

  @override
  State<TSPWeekly> createState() => _TSPWeeklyState();
}

class _TSPWeeklyState extends State<TSPWeekly> {
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
              'Weekly Task',
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: WeeklyTask.length,
                  itemBuilder: (context, index) {
                    final task = WeeklyTask[index];
                    return Dismissible(
                      key: Key('${task['taskName']}_${task['type']}_$index'),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        final removedTask = task;
                        setState(() {
                          removeWeeklyTask(removedTask);
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
                                    WeeklyTask[index]['taskName'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(child: SizedBox()),
                                ],
                              ),
                              Expanded(child: SizedBox()),
                              Text(
                                WeeklyTask[index]['type'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10),
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
