import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';

class RegistrationModal extends StatefulWidget {
  const RegistrationModal({super.key});

  @override
  State<RegistrationModal> createState() => _RegistrationModalState();
}

class _RegistrationModalState extends State<RegistrationModal> {
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Регистрация'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Имя'),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Пароль'),
            obscureText: true,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              final user = await _authService.registerWithEmail(
                _emailController.text,
                _passwordController.text,
                _nameController.text,
              );
              if (user != null && context.mounted) Navigator.pop(context);
            },
            child: const Text('Зарегистрироваться'),
          ),
        ],
      ),
    );
  }
}
