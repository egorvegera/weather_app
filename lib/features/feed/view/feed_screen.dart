import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/post_model.dart';
import '../../../core/models/weather_model.dart';
import '../../../core/services/local_storage_service.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final LocalStorageService _storage = LocalStorageService();
  List<Post> allPosts = [];

  @override
  void initState() {
    super.initState();
    loadFeed();
  }

  Future<void> loadFeed() async {
    /// 1 — Загружаем пользовательские посты из SharedPreferences
    final userPosts = await _storage.loadPosts();

    /// 2 — Создаём фейковых пользователей
    final user1 = User(id: 'u1', name: 'Иван', photoUrl: null);
    final user2 = User(id: 'u2', name: 'Мария', photoUrl: null);

    /// 3 — Создаём фейковые посты
    final fakePosts = [
      Post(
        id: 'fp1',
        user: user1,
        weather: Weather(
          city: 'Москва',
          country: 'RU',
          temperature: 18.0,
          condition: 'Облачно',
        ),
        comment: 'Привет, Москва!',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Post(
        id: 'fp2',
        user: user2,
        weather: Weather(
          city: 'Санкт-Петербург',
          country: 'RU',
          temperature: 15.0,
          condition: 'Дождь',
        ),
        comment: 'Сегодня холодно',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];

    /// 4 — Объединяем все посты в одну ленту
    final combined = [...fakePosts, ...userPosts];

    /// 5 — Сортируем по времени (сначала новые)
    combined.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    setState(() {
      allPosts = combined;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Лента пользователей')),
      body: allPosts.isEmpty
          ? const Center(child: Text("Постов пока нет"))
          : RefreshIndicator(
              onRefresh: loadFeed,
              child: ListView.builder(
                itemCount: allPosts.length,
                itemBuilder: (context, index) {
                  final post = allPosts[index];

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: post.user.photoUrl != null
                            ? NetworkImage(post.user.photoUrl!)
                            : null,
                        child: post.user.photoUrl == null
                            ? Text(post.user.name[0])
                            : null,
                      ),
                      title: Text('${post.user.name} — ${post.weather.city}'),
                      subtitle: Text(
                        '${post.weather.temperature} °C, ${post.weather.condition}\n'
                        '${post.comment}',
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
