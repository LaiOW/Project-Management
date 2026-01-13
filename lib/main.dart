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
       (_chartKey.currentState as dynamic)?.refresh(); 
    }
  }

  void _onLogSaved() {
    // When log is saved, switch to chart page
    setState(() {
      _currentIndex = 1;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      (_chartKey.currentState as dynamic)?.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      LogPage(onSave: _onLogSaved),
      ChartPage(key: _chartKey),
    ];

    // Determine title based on tab
    String title = "Trends";
    if (_currentIndex == 0) {
      // For Log page, the title is now handled by the Tabs inside LogPage? 
      // Or we can just keep a generic title "Log Entry"
      title = "Log Entry";
    }

    return Scaffold(
      // AppBar removed here because LogPage now has its own Tabs that look better without a duplicate AppBar title above it.
      // Or we can keep it simple. Let's keep it but make it minimal.
      appBar: AppBar(
        title: Text(title),
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
