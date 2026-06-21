import 'package:flutter/material.dart';
import 'package:work_helper_app/Pages/AddTaskPage/MainPage/AddTaskPage.dart';

class TSPAddTask extends StatelessWidget {
  const TSPAddTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.blue,
      ),
      child: IconButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage()),
          );
        },
        icon: Icon(Icons.add),
        iconSize: 40,
      ),
    );
  }
}
