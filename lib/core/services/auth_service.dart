import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Вход через email и пароль
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  // Регистрация через email, пароль и имя
  Future<User?> registerWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Устанавливаем displayName
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();
      return _auth.currentUser;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  // Анонимный вход
  Future<User?> signInAnonymously() async {
    final userCredential = await _auth.signInAnonymously();
    return userCredential.user;
  }

  // Выход
  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
