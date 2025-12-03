class User {
  final String id;
  final String name;
  final String? photoUrl;

  User({required this.id, required this.name, this.photoUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], name: json['name'], photoUrl: json['photoUrl']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'photoUrl': photoUrl};
  }
}
