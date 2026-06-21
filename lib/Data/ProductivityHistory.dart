import 'package:hive/hive.dart';

late Box<dynamic> productivityBox;

void initProductivityBox(Box<dynamic> box) {
  productivityBox = box;
}

String _getDateKey(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

int getProductivitySecondsForDate(DateTime date) {
  final dateKey = _getDateKey(date);
  return productivityBox.get(dateKey, defaultValue: 0) as int;
}

String getProductivityFormattedForDate(DateTime date) {
  final seconds = getProductivitySecondsForDate(date);
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  return '${hours}h ${minutes}m';
}

void saveProductivitySecondsForDate(DateTime date, int seconds) {
  final dateKey = _getDateKey(date);
  productivityBox.put(dateKey, seconds);
}
