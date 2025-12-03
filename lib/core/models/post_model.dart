import 'user_model.dart';
import 'weather_model.dart';

class Post {
  final String id;
  final User user;
  final Weather weather;
  final String comment;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.user,
    required this.weather,
    required this.comment,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      user: User.fromJson(json['user']),
      weather: Weather.fromJson(json['weather']),
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'weather': weather.toJson(),
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
