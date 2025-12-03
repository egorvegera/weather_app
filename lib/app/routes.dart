import 'package:flutter/material.dart';
import '../features/weather/view/weather_screen.dart';
import '../features/feed/view/feed_screen.dart';
import '../features/profile/view/profile_screen.dart';
import '../features/settings/view/settings_screen.dart';
import '../features/profile/view/other_profile_screen.dart';

class Routes {
  static const String home = '/';
  static const String weather = '/weather';
  static const String feed = '/feed';
  static const String profile = '/profile';
  static const String otherProfile = '/other_profile';
  static const String settings = '/settings';

  static Map<String, Widget Function(BuildContext)> routes = {
    home: (context) => const BottomNavScreen(),
    weather: (context) => const WeatherScreen(),
    feed: (context) => const FeedScreen(),
    profile: (context) => const ProfileScreen(),
    otherProfile: (context) => const OtherProfileScreen(),
    settings: (context) => const SettingsScreen(),
  };
}

/// Экран с нижней навигацией
class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const WeatherScreen(),
    const FeedScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: 'Погода'),
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Лента'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}
