import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';

class AuthModal extends StatelessWidget {
  final AuthService _authService = AuthService();

  /// Callback вызывается после успешного входа пользователя
  final VoidCallback? onUserChanged;

  AuthModal({super.key, this.onUserChanged});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Вход в приложение'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.login),
            label: const Text('Войти через Email'),
            onPressed: () async {
              // Показываем диалог для ввода email и пароля
              final result = await showDialog<Map<String, String>>(
                context: context,
                builder: (_) {
                  final emailController = TextEditingController();
                  final passwordController = TextEditingController();
                  return AlertDialog(
                    title: const Text('Email вход'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                        ),
                        TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Пароль',
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Отмена'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, {
                            'email': emailController.text,
                            'password': passwordController.text,
                          });
                        },
                        child: const Text('Войти'),
                      ),
                    ],
                  );
                },
              );

              if (result != null) {
                final user = await _authService.signInWithEmail(
                  result['email']!,
                  result['password']!,
                );
                if (user != null && context.mounted) {
                  Navigator.pop(context); // Закрываем модалку входа
                  if (onUserChanged != null) onUserChanged!();
                } else if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Ошибка входа')));
                }
              }
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.person_outline),
            label: const Text('Войти анонимно'),
            onPressed: () async {
              final user = await _authService.signInAnonymously();
              if (user != null && context.mounted) {
                Navigator.pop(context); // Закрываем модалку
                if (onUserChanged != null) onUserChanged!();
              }
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.person_add),
            label: const Text('Регистрация'),
            onPressed: () async {
              // Здесь можно вызывать отдельную модалку регистрации
              if (context.mounted) {
                Navigator.pushNamed(context, '/reg'); // Например, роут /reg
              }
            },
          ),
        ],
      ),
    );
  }
}
