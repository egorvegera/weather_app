// lib/core/services/local_storage_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';

class LocalStorageService {
  /// -------------------------------
  /// Методы для работы с постами
  /// -------------------------------

  Future<File> _getPostsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/posts.json');
  }

  Future<List<Post>> loadPosts() async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        final jsonString = prefs.getString('posts');
        if (jsonString == null) return [];
        final List<dynamic> jsonData = json.decode(jsonString);
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
      final jsonString = json.encode(jsonData);

      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('posts', jsonString);
      } else {
        final file = await _getPostsFile();
        await file.writeAsString(jsonString);
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

  /// -------------------------------
  /// Методы для локального фото пользователя
  /// -------------------------------

  /// Сохраняем фото пользователя
  Future<void> saveUserPhoto(
    String userId,
    String sourcePath, {
    bool isWeb = false,
  }) async {
    try {
      if (kIsWeb || isWeb) {
        // Web: сохраняем Base64 в SharedPreferences
        final bytes = await File(sourcePath).readAsBytes();
        final base64String = base64Encode(bytes);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('${userId}_photo', base64String);
      } else {
        // Мобильные: сохраняем копию файла в Documents
        final dir = await getApplicationDocumentsDirectory();
        final fileName = '${userId}_profile.png';
        final savedFile = await File(sourcePath).copy('${dir.path}/$fileName');
        // возвращаем путь к файлу для использования
      }
    } catch (e) {
      print('Ошибка сохранения фото пользователя: $e');
    }
  }

  /// Получаем путь к фото пользователя (для мобильных) или Base64 (для Web)
  Future<String?> getUserPhotoPath(String userId) async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        final base64String = prefs.getString('${userId}_photo');
        return base64String;
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/${userId}_profile.png';
        final file = File(filePath);
        if (await file.exists()) {
          return file.path; // возвращаем путь к файлу
        }
      }
    } catch (e) {
      print('Ошибка получения фото пользователя: $e');
    }
    return null;
  }
}
