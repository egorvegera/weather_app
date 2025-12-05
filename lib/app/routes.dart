import 'package:flutter/material.dart';
import '../features/profile/view/profile_screen.dart';
import '../features/settings/view/settings_screen.dart';
import '../core/models/user_model.dart';

class AppRoutes {
  static const profile = '/profile';
  static const settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name;
    final args = settings.arguments as User?;

    if (name == '/profile') {
      return MaterialPageRoute(
        builder: (_) => ProfileScreen(currentUser: args),
      );
    } else if (name == '/settings') {
      return MaterialPageRoute(
        builder: (_) => SettingsScreen(currentUser: args),
      );
    } else {
      return MaterialPageRoute(
        builder: (_) =>
            const Scaffold(body: Center(child: Text('Страница не найдена'))),
      );
    }
  }
}
