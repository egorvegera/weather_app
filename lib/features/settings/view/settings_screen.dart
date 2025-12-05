import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/local_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  final User? currentUser;

  const SettingsScreen({super.key, this.currentUser});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  final LocalStorageService _storageService = LocalStorageService();

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadUserPhoto();
  }

  Future<void> _loadUserPhoto() async {
    if (widget.currentUser == null) return;

    final path = await _storageService.getUserPhotoPath(widget.currentUser!.id);
    if (path != null) {
      setState(() => _imageFile = File(path));
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = '${widget.currentUser!.id}_profile.png';
    final savedFile = await File(picked.path).copy('${appDir.path}/$fileName');

    await _storageService.saveUserPhoto(widget.currentUser!.id, savedFile.path);
    setState(() => _imageFile = savedFile);
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
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : null,
                    child: _imageFile == null
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
