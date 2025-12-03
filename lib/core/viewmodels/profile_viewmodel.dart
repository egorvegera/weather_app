// lib/core/viewmodels/profile_viewmodel.dart
import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../models/weather_model.dart';

class ProfileViewModel extends ChangeNotifier {
  final User currentUser;
  final List<Post> posts = [];

  ProfileViewModel({required this.currentUser});

  void addPost(Weather weather, String comment) {
    final post = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      user: currentUser,
      weather: weather,
      comment: comment,
      createdAt: DateTime.now(),
    );
    posts.insert(0, post); // новые посты сверху
    notifyListeners();
  }
}
