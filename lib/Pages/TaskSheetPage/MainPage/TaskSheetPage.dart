import 'package:flutter/material.dart';
import 'package:work_helper_app/Pages/TaskSheetPage/TSPDaily.dart';
import 'package:work_helper_app/Pages/TaskSheetPage/TSPHeader.dart';
import 'package:work_helper_app/Pages/TaskSheetPage/TSPWeekly.dart';

class TaskSheetPage extends StatefulWidget {
  const TaskSheetPage({super.key});

  @override
  State<TaskSheetPage> createState() => _TaskSheetPageState();
}

class _TaskSheetPageState extends State<TaskSheetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50),
          TSPheader(),
          Expanded(
            child: Column(
              children: [
                Expanded(child: TSPDaily()),
                Expanded(child: TSPWeekly()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
