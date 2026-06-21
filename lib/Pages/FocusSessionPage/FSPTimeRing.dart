import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_helper_app/Pages/FocusSessionPage/FocusProvider.dart';

class TimeRing extends StatefulWidget {
  const TimeRing({super.key});

  @override
  State<TimeRing> createState() => _TimeRingState();
}

class _TimeRingState extends State<TimeRing> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: Provider.of<FocusTimerProvider>(context).ratio,
                backgroundColor: Theme.of(context).colorScheme.primary,
                color: Colors.red,
              ),
            ),
            Text(
              '${Provider.of<FocusTimerProvider>(context).hours}h : ${Provider.of<FocusTimerProvider>(context).minutes}m',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
