class User {
  final String id;
  final String name;
  final String? photoUrl; // URL с Firebase
  String? localPhotoPath; // путь к локальному фото (или Base64 для Web)

  User({
    required this.id,
    required this.name,
    this.photoUrl,
    this.localPhotoPath,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      photoUrl: json['photoUrl'],
      localPhotoPath: json['localPhotoPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'localPhotoPath': localPhotoPath,
    };
  }
}
