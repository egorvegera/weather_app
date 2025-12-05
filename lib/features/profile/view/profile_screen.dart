import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/post_model.dart';
import '../../../core/models/weather_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/weather_service.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/auth_service.dart';
import '../../auth/view/auth_modal.dart';
import '../../../app/routes.dart';

class ProfileScreen extends StatefulWidget {
  final User? currentUser;

  const ProfileScreen({super.key, this.currentUser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final WeatherService _weatherService = WeatherService();
  final LocalStorageService _storageService = LocalStorageService();
  final AuthService _authService = AuthService();

  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  Weather? _currentWeather;
  List<Post> _posts = [];
  User? _currentUser;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _loadPosts();
  }

  Future<void> _initializeUser() async {
    _currentUser = widget.currentUser ?? _getAuthUser();
    if (_currentUser != null) {
      // Загружаем локальное фото, если есть
      final localPath = await _storageService.getUserPhotoPath(
        _currentUser!.id,
      );
      if (localPath != null) {
        setState(() {
          _currentUser!.localPhotoPath = localPath;
        });
      }
    }
  }

  User? _getAuthUser() {
    final firebaseUser = _authService.currentUser;
    return firebaseUser != null
        ? User(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? 'Аноним',
            photoUrl: firebaseUser.photoURL,
          )
        : null;
  }

  Future<void> _loadPosts() async {
    final loadedPosts = await _storageService.loadPosts();
    if (!mounted) return;
    setState(() {
      _posts = loadedPosts;
    });
  }

  Future<void> _savePosts() async {
    await _storageService.savePosts(_posts);
  }

  Future<void> _getWeather() async {
    if (_cityController.text.isEmpty) return;
    setState(() => _isLoading = true);

    try {
      final weather = await _weatherService.getWeather(_cityController.text);
      if (mounted) setState(() => _currentWeather = weather);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ошибка получения погоды')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _publishPost() async {
    if (_currentWeather == null) return;
    if (_commentController.text.isEmpty) return;
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сначала войдите в аккаунт')),
      );
      return;
    }

    final newPost = Post(
      id: const Uuid().v4(),
      user: _currentUser!,
      weather: _currentWeather!,
      comment: _commentController.text,
      createdAt: DateTime.now(),
    );

    setState(() {
      _posts.insert(0, newPost);
      _commentController.clear();
    });

    await _savePosts();
  }

  /// Обновление локального фото пользователя после изменений в Settings
  Future<void> _updateUserPhoto() async {
    if (_currentUser == null) return;
    final localPath = await _storageService.getUserPhotoPath(_currentUser!.id);
    if (localPath != null) {
      setState(() {
        _currentUser!.localPhotoPath = localPath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          if (_currentUser != null)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.settings,
                  arguments: _currentUser,
                ).then((_) => _updateUserPhoto());
              },
            ),
          if (_currentUser == null)
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () {
                showDialog(context: context, builder: (_) => AuthModal()).then((
                  _,
                ) {
                  final user = _getAuthUser();
                  if (mounted && user != null) {
                    setState(() => _currentUser = user);
                  }
                });
              },
            ),
          if (_currentUser != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await _authService.signOut();
                if (mounted) setState(() => _currentUser = null);
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Аватар текущего пользователя
            if (_currentUser != null)
              CircleAvatar(
                radius: 40,
                backgroundImage: _currentUser!.localPhotoPath != null
                    ? (kIsWeb
                          ? MemoryImage(
                              base64Decode(_currentUser!.localPhotoPath!),
                            )
                          : FileImage(File(_currentUser!.localPhotoPath!))
                                as ImageProvider)
                    : (_currentUser!.photoUrl != null
                          ? NetworkImage(_currentUser!.photoUrl!)
                          : null),
                child:
                    (_currentUser!.localPhotoPath == null &&
                        _currentUser!.photoUrl == null)
                    ? Text(_currentUser!.name[0])
                    : null,
              ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'Введите город',
                    ),
                    onSubmitted: (_) => _getWeather(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _getWeather,
                ),
              ],
            ),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(),
              ),

            if (_currentWeather != null && !_isLoading)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '${_currentWeather!.city}, ${_currentWeather!.country}\n'
                  '${_currentWeather!.temperature}°C, ${_currentWeather!.condition}',
                  textAlign: TextAlign.center,
                ),
              ),

            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Комментарий о погоде',
              ),
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _publishPost,
              child: const Text('Опубликовать пост'),
            ),

            const SizedBox(height: 20),
            Expanded(
              child: _posts.isEmpty
                  ? const Center(child: Text('Постов пока нет'))
                  : ListView.builder(
                      itemCount: _posts.length,
                      itemBuilder: (context, index) {
                        final post = _posts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: post.user.localPhotoPath != null
                                  ? (kIsWeb
                                        ? MemoryImage(
                                            base64Decode(
                                              post.user.localPhotoPath!,
                                            ),
                                          )
                                        : FileImage(
                                                File(post.user.localPhotoPath!),
                                              )
                                              as ImageProvider)
                                  : (post.user.photoUrl != null
                                        ? NetworkImage(post.user.photoUrl!)
                                        : null),
                              child:
                                  post.user.localPhotoPath == null &&
                                      post.user.photoUrl == null
                                  ? Text(post.user.name[0])
                                  : null,
                            ),
                            title: Text(
                              '${post.user.name} — ${post.weather.city}',
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${post.weather.temperature}°C, ${post.weather.condition}',
                                ),
                                Text(post.comment),
                                Text(
                                  '${post.createdAt.hour.toString().padLeft(2, '0')}:'
                                  '${post.createdAt.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
