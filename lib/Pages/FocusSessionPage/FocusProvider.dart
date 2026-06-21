import 'dart:async';

import 'package:flutter/material.dart';

class FocusTimerProvider extends ChangeNotifier {
  int _totalSeconds = 0;
  int _remainingSeconds = 0;
  int _cumulativeSeconds = 0; // accumulated across sessions (in-memory)
  double _ratio = 0; // elapsed ratio [0..1]
  Timer? _timer;

  String get hours => _formatTwoDigits((_remainingSeconds ~/ 3600));
  String get minutes => _formatTwoDigits(((_remainingSeconds % 3600) ~/ 60));
  double get ratio => _ratio;

  void setTimer(dynamic hours, dynamic minutes) {
    // If there was an active session, accumulate its elapsed seconds before resetting
    if (_timer != null && _totalSeconds > 0) {
      final elapsed = _totalSeconds - _remainingSeconds;
      if (elapsed > 0) {
        _cumulativeSeconds += elapsed;
      }
    }
    _timer?.cancel();

    String hrs = hours?.toString() ?? '0';
    String mins = minutes?.toString() ?? '0';
    double hr = double.tryParse(hrs) ?? 0.0;
    double min = double.tryParse(mins) ?? 0.0;

    _totalSeconds = (hr * 3600 + min * 60).toInt();
    _remainingSeconds = _totalSeconds;
    _ratio = 0;

    if (_totalSeconds > 0) {
      _startTimer();
    } else {
      notifyListeners();
    }
  }

  void _startTimer() {
    notifyListeners();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds > 0) {
        _remainingSeconds -= 1;
        _ratio = (_remainingSeconds / _totalSeconds);
        notifyListeners();
      } else {
        // session finished — add full session length to cumulative
        _cumulativeSeconds += _totalSeconds;
        _ratio = 1;
        _timer?.cancel();
        notifyListeners();
      }
    });
  }

  void stopTimer() {
    // accumulate elapsed time for interrupted session
    if (_timer != null && _totalSeconds > 0) {
      final elapsed = _totalSeconds - _remainingSeconds;
      if (elapsed > 0) {
        _cumulativeSeconds += elapsed;
      }
    }
    _timer?.cancel();
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _remainingSeconds = _totalSeconds;
    _ratio = 0;
    notifyListeners();
  }

  String _formatTwoDigits(int n) => n.toString().padLeft(2, '0');

  // Total productive seconds including accumulated past sessions and current running session
  int get productiveSeconds {
    final currentElapsed = (_totalSeconds > 0)
        ? (_totalSeconds - _remainingSeconds)
        : 0;
    return _cumulativeSeconds + currentElapsed;
  }

  String get productiveFormatted {
    final secs = productiveSeconds;
    final h = secs ~/ 3600;
    final m = (secs % 3600) ~/ 60;
    return '${h}h ${m}m';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
