import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';

class RegModal extends StatelessWidget {
  final AuthService _authService = AuthService();

  /// Callback вызывается после успешной регистрации
  final VoidCallback? onUserRegistered;

  RegModal({super.key, this.onUserRegistered});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController nameController = TextEditingController();

    return AlertDialog(
      title: const Text('Регистрация'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Имя'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () async {
            final email = emailController.text.trim();
            final password = passwordController.text.trim();
            final name = nameController.text.trim();

            if (email.isEmpty || password.isEmpty || name.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Заполните все поля')),
              );
              return;
            }

            final user = await _authService.registerWithEmail(
              email,
              password,
              name,
            );

            if (user != null && context.mounted) {
              Navigator.pop(context); // Закрываем модалку регистрации
              if (onUserRegistered != null) onUserRegistered!();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Регистрация успешна')),
              );
            } else if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ошибка регистрации')),
              );
            }
          },
          child: const Text('Зарегистрироваться'),
        ),
      ],
    );
  }
}
