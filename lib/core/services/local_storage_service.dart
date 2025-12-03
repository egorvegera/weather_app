import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';

class LocalStorageService {
  static const String postsKey = 'posts';

  /// Сохраняем список постов
  Future<void> savePosts(List<Post> posts) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = posts.map((post) => json.encode(post.toJson())).toList();
    await prefs.setStringList(postsKey, jsonList);
  }

  /// Загружаем список постов
  Future<List<Post>> loadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(postsKey) ?? [];
    return jsonList
        .map((jsonStr) => Post.fromJson(json.decode(jsonStr)))
        .toList();
  }
}
