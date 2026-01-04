import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'chart_page.dart';
import 'log_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diabetes App',
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  // Keys to access state of child widgets if needed (e.g. to refresh chart)
  final GlobalKey<State<ChartPage>> _chartKey = GlobalKey();

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // If switching to chart tab, refresh it
    if (index == 1) {
       // Ideally ChartPage refreshes on initState, but if it stays alive we might need to trigger it.
       // For simple switching, the widget might be rebuilt.
       // If we use IndexedStack, state is preserved.
       // Let's assume re-building is fine or we can trigger refresh.
       (_chartKey.currentState as dynamic)?.refresh(); 
    }
  }

  void _onLogSaved() {
    // When log is saved, switch to chart page
    setState(() {
      _currentIndex = 1;
    });
    // Trigger refresh after a short delay to ensure widget is built/ready if we were not there
    Future.delayed(const Duration(milliseconds: 100), () {
      (_chartKey.currentState as dynamic)?.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    // We use a body that changes based on index
    final List<Widget> pages = [
      LogPage(onSave: _onLogSaved),
      ChartPage(key: _chartKey),
    ];

    return Scaffold(
      // App bar can be simple or hidden. Let's keep it minimal.
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? "Log Glucose" : "Trends"),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: "Log",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: "Trends",
          ),
        ],
      ),
    );
  }
}
