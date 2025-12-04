import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/post_model.dart';
import '../../../core/models/weather_model.dart';
import '../../../core/models/user_model.dart'; // User
import '../../../core/services/weather_service.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/auth_service.dart';
import '../../auth/view/auth_modal.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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
  User? _currentUser; // исправлено

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initUser();
    _loadPosts();
  }

  void _initUser() {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser != null) {
      _currentUser = User(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'Аноним',
        photoUrl: firebaseUser.photoURL,
      );
    }
  }

  Future<void> _loadPosts() async {
    final loadedPosts = await _storageService.loadPosts();
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
      setState(() => _currentWeather = weather);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка при получении погоды')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _publishPost() async {
    if (_currentWeather == null ||
        _commentController.text.isEmpty ||
        _currentUser == null)
      return;

    final newPost = Post(
      id: const Uuid().v4(),
      user: _currentUser!, // User
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AuthModal(),
              ).then((_) => _initUser());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              setState(() => _currentUser = null);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            if (_isLoading) const CircularProgressIndicator(),
            if (_currentWeather != null && !_isLoading)
              Text(
                '${_currentWeather!.city}, ${_currentWeather!.country}\n${_currentWeather!.temperature} °C, ${_currentWeather!.condition}',
                textAlign: TextAlign.center,
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
                              backgroundImage: post.user.photoUrl != null
                                  ? NetworkImage(post.user.photoUrl!)
                                  : null,
                              child: post.user.photoUrl == null
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
                                  '${post.weather.temperature} °C, ${post.weather.condition}',
                                ),
                                Text(post.comment),
                                Text(
                                  '${post.createdAt.hour}:${post.createdAt.minute.toString().padLeft(2, '0')}',
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
