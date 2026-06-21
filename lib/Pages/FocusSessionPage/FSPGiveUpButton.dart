import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_helper_app/Pages/FocusSessionPage/FocusProvider.dart';

class GiveUpButton extends StatelessWidget {
  const GiveUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    final focusProvider = context.watch<FocusTimerProvider>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.red,
        ),
        height: 40,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            focusProvider.setTimer('00', '00');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              Text(
                'Give Up',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
