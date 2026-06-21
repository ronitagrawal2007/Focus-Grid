import 'package:flutter/material.dart';
import 'package:work_helper_app/Pages/HomePage/HPDay.dart';
import 'package:work_helper_app/Pages/HomePage/HPHeader.dart';
import 'package:work_helper_app/Pages/HomePage/HPHeatMap.dart';
import 'package:work_helper_app/Pages/HomePage/HPTaskList.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50),
          HPheader(),
          HPDay(),
          SizedBox(height: 10),
          const HPHeatMap(),
          SizedBox(height: 10),
          HPTaskList(),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
