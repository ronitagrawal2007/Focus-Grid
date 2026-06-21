import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 1. Add this import
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:work_helper_app/Data/DateDay.dart';
import 'package:work_helper_app/Data/DailyTask.dart';
import 'package:work_helper_app/Data/HomeTask.dart';
import 'package:work_helper_app/Data/TaskHistory.dart';
import 'package:work_helper_app/Data/WeeklyTask.dart';
import 'package:work_helper_app/Pages/FocusSessionPage/MainPage/FocusSessionPage.dart';
import 'package:work_helper_app/Pages/FocusSessionPage/FocusProvider.dart';
import 'package:work_helper_app/Pages/HomePage/MainPage/HomePage.dart';
import 'package:work_helper_app/Pages/TaskSheetPage/MainPage/TaskSheetPage.dart';
import 'package:work_helper_app/Provider/TaskAddedProvider.dart';
import 'package:work_helper_app/Provider/darkModeProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Lock orientation to portrait up and portrait down
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Hive.initFlutter();
  var DailyTaskBox = await Hive.openBox("DailyTaskBox");
  initDailyTaskBox(DailyTaskBox);
  DailyTaskTransfer();

  var WeeklyTaskBox = await Hive.openBox("WeeklyTaskBox");
  initWeeklyTaskBox(WeeklyTaskBox);
  WeeklyTaskTransfer();

  var TaskHistoryBox = await Hive.openBox("TaskHistoryBox");
  initTaskHistoryBox(TaskHistoryBox);
  loadTaskHistory();

  // Populate today’s home task list from saved daily/weekly tasks
  initializeTodayTasks();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DarkModeProvider()),
        ChangeNotifierProvider(create: (context) => FocusTimerProvider()),
        ChangeNotifierProvider(create: (context) => TaskAddedProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> _themeLoadFuture;

  @override
  void initState() {
    super.initState();
    // Load saved theme preference when app starts
    _themeLoadFuture = Provider.of<DarkModeProvider>(
      context,
      listen: false,
    ).loadSavedTheme();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _themeLoadFuture,
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Provider.of<DarkModeProvider>(context).themeData,
          home: MainPage(currentIndex: 1),
        );
      },
    );
  }
}

class MainPage extends StatefulWidget {
  final int
  currentIndex; // Made final as it shouldn't change directly outside setState
  MainPage({super.key, required this.currentIndex});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _currentIndex;

  // 1. Initialize it directly here instead of using 'late' in initState
  // We use widget.currentIndex safely by accessing it via a getter or setting it up directly.
  late final PageController _pageController = PageController(
    initialPage: widget.currentIndex,
  );

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;

    addDate();
    initializeTodayTasks();
  }

  @override
  void dispose() {
    _pageController.dispose(); // Good practice to keep this
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateBottomBar(int index) {
    // Safety check: Make sure the pageview is attached to the controller before animating
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  final List<Widget> _pages = [TaskSheetPage(), HomePage(), FocusSessionPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigateBottomBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "Task Sheet"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: "Focus"),
        ],
      ),
    );
  }
}
