import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:work_helper_app/Pages/FocusSessionPage/FSPHeader.dart';
import 'package:work_helper_app/Pages/FocusSessionPage/FSPGiveUpButton.dart';
import 'package:work_helper_app/Pages/FocusSessionPage/FSPTimeRing.dart';
import 'package:work_helper_app/Pages/FocusSessionPage/FSPTimeSetter.dart';
import 'package:work_helper_app/Pages/FocusSessionPage/FocusBG.dart';
import 'package:work_helper_app/Pages/FocusSessionPage/FocusBGImage.dart';
import 'package:work_helper_app/Pages/FocusSessionPage/MusicSystem.dart';

class FocusSessionPage extends StatefulWidget {
  const FocusSessionPage({super.key});

  @override
  State<FocusSessionPage> createState() => _FocusSessionPageState();
}

class _FocusSessionPageState extends State<FocusSessionPage> {
  String _selectedImage = 'Image 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          FocusBGImage(selectedType: _selectedImage),
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 50),
                FSPheader(),
                TimeRing(),
                SizedBox(height: 5),
                FSPTimeSetter(),
                SizedBox(height: 5),
                Padding(padding: const EdgeInsets.all(8.0), child: MusicSystem()),
                SizedBox(height: 5),
                FocusBG(
                  selectedType: _selectedImage,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedImage = value;
                      });
                    }
                  },
                ),
                GiveUpButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
