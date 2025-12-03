import 'package:flutter/material.dart';
import '../features/weather/view/weather_screen.dart';
import '../features/profile/view/profile_screen.dart';
import '../features/feed/view/feed_screen.dart';
import '../features/settings/view/settings_screen.dart';
import '../features/profile/view/other_profile_screen.dart';

class AppRoutes {
  static const String weather = '/weather';
  static const String profile = '/profile';
  static const String feed = '/feed';
  static const String settings = '/settings';
  static const String otherProfile = '/other_profile';

  static Map<String, WidgetBuilder> get routes {
    return {
      weather: (context) => const WeatherScreen(),
      profile: (context) => const ProfileScreen(),
      feed: (context) => const FeedScreen(),
      settings: (context) => const SettingsScreen(),
      otherProfile: (context) => const OtherProfileScreen(),
    };
  }
}
