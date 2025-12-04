import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';

class AuthModal extends StatelessWidget {
  final AuthService _authService = AuthService();

  AuthModal({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Вход в приложение'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.login),
            label: const Text('Войти через Google'),
            onPressed: () async {
              final user = await _authService.signInWithGoogle();
              if (user != null && context.mounted) Navigator.pop(context);
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.person_outline),
            label: const Text('Войти анонимно'),
            onPressed: () async {
              final user = await _authService.signInAnonymously();
              if (user != null && context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
