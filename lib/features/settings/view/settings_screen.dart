// lib/features/settings/view/settings_screen.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  final User? currentUser;

  const SettingsScreen({super.key, this.currentUser});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();

  File? _imageFile; // Для мобильных платформ
  String? _webImageBase64; // Для Web

  @override
  void initState() {
    super.initState();
    _loadUserPhoto();
  }

  Future<void> _loadUserPhoto() async {
    if (widget.currentUser == null) return;

    if (kIsWeb) {
      // Web: загружаем Base64 из shared_preferences
      final prefs = await SharedPreferences.getInstance();
      final base64String = prefs.getString('${widget.currentUser!.id}_photo');
      if (base64String != null) {
        setState(() => _webImageBase64 = base64String);
      }
    } else {
      // Мобильные: загружаем файл
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/${widget.currentUser!.id}_profile.png';
      final file = File(filePath);
      if (await file.exists()) {
        setState(() => _imageFile = file);
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    if (kIsWeb) {
      // Web: сохраняем Base64 в SharedPreferences
      final bytes = await picked.readAsBytes();
      final base64String = base64Encode(bytes);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${widget.currentUser!.id}_photo', base64String);
      setState(() => _webImageBase64 = base64String);
    } else {
      // Мобильные: сохраняем в File
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${widget.currentUser!.id}_profile.png';
      final savedFile = await File(
        picked.path,
      ).copy('${appDir.path}/$fileName');
      setState(() => _imageFile = savedFile);
    }
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.currentUser == null
            ? const Center(child: Text('Пользователь не авторизован'))
            : Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: kIsWeb
                        ? (_webImageBase64 != null
                              ? MemoryImage(base64Decode(_webImageBase64!))
                              : null)
                        : (_imageFile != null ? FileImage(_imageFile!) : null),
                    child: (_imageFile == null && _webImageBase64 == null)
                        ? Text(
                            widget.currentUser!.name[0],
                            style: const TextStyle(fontSize: 40),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo),
                    label: const Text('Изменить фото'),
                    onPressed: _pickImage,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Выйти из аккаунта'),
                    onPressed: _signOut,
                  ),
                ],
              ),
      ),
    );
  }
}
