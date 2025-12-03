import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Здесь можно реализовать выход из аккаунта
          },
          child: const Text('Выйти из аккаунта'),
        ),
      ),
    );
  }
}
