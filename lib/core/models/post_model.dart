import 'user_model.dart';
import 'weather_model.dart';

class Post {
  final String id;
  final User user;
  final Weather weather;
  final String comment;
  final DateTime createdAt;

  const Post({
    required this.id,
    required this.user,
    required this.weather,
    required this.comment,
    required this.createdAt,
  });
}
