import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/post_model.dart';
import '../../../core/models/weather_model.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Примеры пользователей
    final user1 = User(id: 'u1', name: 'Иван', photoUrl: null);
    final user2 = User(id: 'u2', name: 'Мария', photoUrl: null);

    // Примеры постов
    final posts = [
      Post(
        id: 'p1',
        user: user1,
        weather: Weather(
          city: 'Москва',
          country: 'RU',
          temperature: 18.0,
          condition: 'Облачно',
        ),
        comment: 'Привет, Москва!',
        createdAt: DateTime.now(),
      ),
      Post(
        id: 'p2',
        user: user2,
        weather: Weather(
          city: 'Санкт-Петербург',
          country: 'RU',
          temperature: 15.0,
          condition: 'Дождь',
        ),
        comment: 'Сегодня промозгло',
        createdAt: DateTime.now(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Лента пользователей')),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
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
                '${post.weather.temperature} °C, ${post.weather.condition}\n${post.comment}',
              ),
            ),
          );
        },
      ),
    );
  }
}
