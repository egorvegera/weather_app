import 'package:flutter/material.dart';

class OtherProfileScreen extends StatelessWidget {
  const OtherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль другого пользователя')),
      body: const Center(child: Text('Информация о другом пользователе')),
    );
  }
}
