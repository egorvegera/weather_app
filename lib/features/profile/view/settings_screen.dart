/*import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  User? _currentUser;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser != null) {
      setState(() {
        _currentUser = User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'Аноним',
          photoUrl: firebaseUser.photoURL,
        );
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = '${_currentUser!.id}_profile.png';
    final savedImage = await File(
      pickedFile.path,
    ).copy('${appDir.path}/$fileName');

    setState(() {
      _imageFile = savedImage;
      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        photoUrl: savedImage.path,
      );
    });
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_currentUser != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : (_currentUser!.photoUrl != null &&
                          _currentUser!.photoUrl!.startsWith('http'))
                    ? NetworkImage(_currentUser!.photoUrl!) as ImageProvider
                    : null,
                child:
                    (_imageFile == null &&
                        (_currentUser!.photoUrl == null ||
                            _currentUser!.photoUrl!.isEmpty))
                    ? Text(
                        _currentUser!.name[0],
                        style: const TextStyle(fontSize: 40),
                      )
                    : null,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Изменить фото профиля'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signOut,
              child: const Text('Выйти из аккаунта'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
