import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/post_model.dart';
import '../../../core/models/weather_model.dart';
import '../../../core/services/weather_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User currentUser = User(id: 'u1', name: 'Иван', photoUrl: null);
  final WeatherService _weatherService = WeatherService();

  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  Weather? _currentWeather;
  final List<Post> _posts = [];

  bool _isLoading = false;

  Future<void> _getWeather() async {
    if (_cityController.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final weather = await _weatherService.getWeather(_cityController.text);
      setState(() {
        _currentWeather = weather;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка при получении погоды')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _publishPost() {
    if (_currentWeather == null || _commentController.text.isEmpty) return;

    final newPost = Post(
      id: const Uuid().v4(),
      user: currentUser,
      weather: _currentWeather!,
      comment: _commentController.text,
      createdAt: DateTime.now(),
    );

    setState(() {
      _posts.insert(0, newPost); // добавляем пост в начало списка
      _commentController.clear();
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ввод города для погоды
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
            const SizedBox(height: 10),

            // Отображение текущей погоды
            if (_isLoading) const CircularProgressIndicator(),
            if (_currentWeather != null && !_isLoading)
              Text(
                '${_currentWeather!.city}, ${_currentWeather!.country}\n'
                '${_currentWeather!.temperature} °C, ${_currentWeather!.condition}',
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 10),

            // Поле для комментария и кнопка публикации
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

            // Список постов
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
                                  '${post.createdAt.hour}:${post.createdAt.minute}',
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
