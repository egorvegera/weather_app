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
    setState(() => _posts = loadedPosts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Лента пользователей')),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Card(
            margin: const EdgeInsets.all(8),
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
