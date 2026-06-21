import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:work_helper_app/Pages/FocusSessionPage/FocusProvider.dart';

class FSPTimeSetter extends StatefulWidget {
  const FSPTimeSetter({super.key});

  @override
  State<FSPTimeSetter> createState() => _FSPTimeSetterState();
}

class _FSPTimeSetterState extends State<FSPTimeSetter> {
  final TextEditingController _hrcontroller = TextEditingController();
  final TextEditingController _mincontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final focusProvider = context.watch<FocusTimerProvider>();
    return Column(
      mainAxisSize: MainAxisSize.min, // Takes only space it needs
      children: [
        Row(
          children: [
            // TextFields MUST be wrapped in Expanded inside a Row
            Expanded(
              child: TextField(
                maxLength: 2,
                controller: _hrcontroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "HH",
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                maxLength: 2,
                controller: _mincontroller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                  _MinuteRangeTextInputFormatter(),
                ],
                decoration: InputDecoration(
                  hintText: "MM",
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    focusProvider.setTimer(
                      _hrcontroller.text.isEmpty ? "01" : _hrcontroller.text,
                      _mincontroller.text.isEmpty ? "00" : _mincontroller.text,
                    );
                    _hrcontroller.clear();
                    _mincontroller.clear();
                  },
                  child: SizedBox(
                    height: 40,
                    child: Center(
                      child: Text(
                        "Start Timer",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MinuteRangeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final intValue = int.tryParse(newValue.text);
    if (intValue == null) {
      return oldValue;
    }

    if (intValue > 60) {
      return oldValue;
    }

    return newValue;
  }
}
