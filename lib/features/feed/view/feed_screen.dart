import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/models/post_model.dart';
import '../../../core/services/local_storage_service.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final LocalStorageService _storageService = LocalStorageService();
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final loadedPosts = await _storageService.loadPosts();

    // Загружаем локальные фото для каждого пользователя
    for (var post in loadedPosts) {
      final localPhoto = await _storageService.getUserPhotoPath(post.user.id);
      if (localPhoto != null) {
        post.user.localPhotoPath = localPhoto;
      }
    }

    if (mounted) setState(() => _posts = loadedPosts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Лента пользователей')),
      body: _posts.isEmpty
          ? const Center(child: Text('Постов пока нет'))
          : RefreshIndicator(
              onRefresh: _loadPosts, // позволяет обновлять ленту свайпом вниз
              child: ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  ImageProvider? avatarImage;

                  if (post.user.localPhotoPath != null) {
                    avatarImage = kIsWeb
                        ? MemoryImage(base64Decode(post.user.localPhotoPath!))
                        : FileImage(File(post.user.localPhotoPath!));
                  } else if (post.user.photoUrl != null) {
                    avatarImage = NetworkImage(post.user.photoUrl!);
                  }

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: avatarImage,
                        child: avatarImage == null
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
            ),
    );
  }
}
