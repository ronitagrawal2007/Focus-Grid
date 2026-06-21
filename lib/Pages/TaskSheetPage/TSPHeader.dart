import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_helper_app/Pages/TaskSheetPage/TSPAddTask.dart';
import 'package:work_helper_app/Provider/darkModeProvider.dart';

class TSPheader extends StatelessWidget {
  const TSPheader({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<DarkModeProvider>();
    return Row(
      children: [
        TSPAddTask(),
        Expanded(
          child: Center(
            child: Text(
              "Task Sheet",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        CupertinoSwitch(
          // Logic fix: We MUST listen here so the switch UI moves
          value: themeProvider.isDarkMode,
          onChanged: (value) => themeProvider.toggleTheme(),
        ),
        SizedBox(width: 5),
      ],
    );
  }
}
