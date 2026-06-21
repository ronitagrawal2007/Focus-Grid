List<Map<String, dynamic>> day_date = [];
String today_days_Weekdays_Name = "";

void addDate() {
  // Clear the list first to avoid duplicating data if the function runs multiple times
  day_date.clear();

  DateTime currentTime = DateTime.now();
  int year = currentTime.year;
  int month = currentTime.month;

  // Your excellent trick to get total days
  int daysInMonth = DateTime(year, month + 1, 0).day;

  for (int i = 1; i <= daysInMonth; i++) {
    DateTime specificDate = DateTime(year, month, i);

    // Format the weekday (e.g., "Mon", "Tue") without relying on intl
    const List<String> _shortWeekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    String weekdayName = _shortWeekdays[specificDate.weekday - 1];
    day_date.add({
      'day': weekdayName, // e.g., "Fri"
      'date': i, // e.g., 26
      'fullDate':
          specificDate, // Useful if you need to pass it to a calendar picker later
    });
  }
}
