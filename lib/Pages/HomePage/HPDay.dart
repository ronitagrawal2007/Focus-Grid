import 'package:flutter/material.dart';
import 'package:work_helper_app/Data/DateDay.dart';

class HPDay extends StatefulWidget {
  const HPDay({super.key});

  @override
  State<HPDay> createState() => _HPDayState();
}

class _HPDayState extends State<HPDay> {
  // 1. Create a ScrollController to manipulate the position
  final ScrollController _scrollController = ScrollController();

  // 2. Explicitly define item metrics for the mathematical calculation
  // Total item horizontal space = item width + horizontal padding (8 left + 8 right)
  final double baseItemWidth = 55.0;
  final double paddingSpace = 16.0;
  late double totalItemWidth;

  @override
  void initState() {
    super.initState();
    totalItemWidth = baseItemWidth + paddingSpace;
    // 3. PostFrameCallback runs right AFTER the widget gets rendered on screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  void _scrollToToday() {
    int myNumber = DateTime.now().day;

    // Find the zero-based index for the target date
    int targetIndex = day_date.indexWhere(
      (element) => element['date'] == myNumber,
    );

    // If the date is not found in the list (e.g., if it's the 31st), do nothing
    if (targetIndex == -1) return;

    // Get the exact width of the screen dynamically
    double screenWidth = MediaQuery.of(context).size.width;

    // CENTER FORMULA:
    // (targetIndex * totalItemWidth) -> moves viewport to the start of your item
    // - (screenWidth / 2)           -> scrolls further left by half the screen width
    // + (totalItemWidth / 2)        -> shifts back right by half the item width to center it perfectly
    double calculatedOffset =
        (targetIndex * totalItemWidth) -
        (screenWidth / 2) +
        (totalItemWidth / 2);

    // Bound check: Ensure we don't try to scroll into negative space or past the maximum limit
    double maxScroll = _scrollController.position.maxScrollExtent;
    double minScroll = _scrollController.position.minScrollExtent;
    double finalOffset = calculatedOffset.clamp(minScroll, maxScroll);

    // Smooth scroll to the offset
    _scrollController.animateTo(
      finalOffset,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    int myNumber = DateTime.now().day;

    return Container(
      width: double.infinity,
      height: 80,
      child: ListView.builder(
        controller: _scrollController, // 4. Attach the controller here
        itemCount: day_date.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          bool isMatch = day_date[index]['date'] == myNumber;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Container(
              decoration: BoxDecoration(
                color: isMatch
                    ? Colors.blue
                    : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15),
                // Highlight suggestion instead of changing size layout boundaries:
                border: isMatch
                    ? Border.all(color: Colors.white, width: 2)
                    : null,
              ),
              width:
                  baseItemWidth, // Kept completely static for layout predictability
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${day_date[index]['date']}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    day_date[index]['day'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose(); // 5. Clean up your controller
    super.dispose();
  }
}
