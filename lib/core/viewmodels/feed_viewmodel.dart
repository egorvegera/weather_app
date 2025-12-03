import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../models/weather_model.dart';

class FeedViewModel extends ChangeNotifier {
  List<Post> _posts = [];
  List<Post> get posts => _posts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Получение фейковых постов для примера
  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // имитация загрузки

    // создаём фейковые пользователи и посты
    final user1 = User(
      id: '1',
      name: 'Иван Иванов',
      photoUrl: 'https://via.placeholder.com/150',
    );
    final user2 = User(
      id: '2',
      name: 'Мария Петрова',
      photoUrl: 'https://via.placeholder.com/150',
    );

    final post1 = Post(
      id: '1',
      user: user1,
      weather: Weather(
        city: 'Москва',
        country: 'Россия',
        temperature: 18.0,
        condition: 'Облачно',
      ),
      comment: 'Сегодня прохладно',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    );

    final post2 = Post(
      id: '2',
      user: user2,
      weather: Weather(
        city: 'Санкт-Петербург',
        country: 'Россия',
        temperature: 15.0,
        condition: 'Дождь',
      ),
      comment: 'Не забывайте зонты!',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    );

    _posts = [post1, post2];
    _isLoading = false;
    notifyListeners();
  }
}
