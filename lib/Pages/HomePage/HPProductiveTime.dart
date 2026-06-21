import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_helper_app/Pages/FocusSessionPage/FocusProvider.dart';

class HPProductiveTime extends StatelessWidget {
  const HPProductiveTime({super.key});

  @override
  Widget build(BuildContext context) {
    final focus = context.watch<FocusTimerProvider>();
    return Column(
      children: [
        Center(
          child: Text(
            focus.productiveFormatted,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Text(
            "Productivity Time",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
