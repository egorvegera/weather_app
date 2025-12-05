import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';

class LocalStorageService {
  // -------------------------------
  // Методы для работы с постами
  // -------------------------------

  Future<List<Post>> loadPosts() async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        final content = prefs.getString('posts');
        if (content == null) return [];
        final List<dynamic> jsonData = json.decode(content);
        return jsonData.map((e) => Post.fromJson(e)).toList();
      } else {
        final file = await _getPostsFile();
        if (!await file.exists()) return [];
        final content = await file.readAsString();
        final List<dynamic> jsonData = json.decode(content);
        return jsonData.map((e) => Post.fromJson(e)).toList();
      }
    } catch (e) {
      print('Ошибка загрузки постов: $e');
      return [];
    }
  }

  Future<void> savePosts(List<Post> posts) async {
    try {
      final jsonData = posts.map((e) => e.toJson()).toList();
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('posts', json.encode(jsonData));
      } else {
        final file = await _getPostsFile();
        await file.writeAsString(json.encode(jsonData));
      }
    } catch (e) {
      print('Ошибка сохранения постов: $e');
    }
  }

  Future<void> addPost(Post post) async {
    final posts = await loadPosts();
    posts.insert(0, post);
    await savePosts(posts);
  }

  Future<File> _getPostsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/posts.json');
  }

  // -------------------------------
  // Методы для локального фото пользователя
  // -------------------------------

  Future<void> saveUserPhoto(String userId, String path) async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('${userId}_photo', path);
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/${userId}_photo.txt');
        await file.writeAsString(path);
      }
    } catch (e) {
      print('Ошибка сохранения фото пользователя: $e');
    }
  }

  Future<String?> getUserPhotoPath(String userId) async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString('${userId}_photo');
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/${userId}_photo.txt');
        if (await file.exists()) {
          return file.readAsString();
        }
      }
    } catch (e) {
      print('Ошибка получения фото пользователя: $e');
    }
    return null;
  }
}
