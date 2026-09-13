import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(
        _getErrorMessage(e.code),
      );
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser {
    return _auth.currentUser;
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-credential':
        return 'Email atau password salah.';

      case 'user-not-found':
        return 'Akun admin tidak ditemukan.';

      case 'wrong-password':
        return 'Password salah.';

      case 'invalid-email':
        return 'Format email tidak valid.';

      case 'user-disabled':
        return 'Akun admin telah dinonaktifkan.';

      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';

      default:
        return 'Login gagal. Silakan coba lagi.';
    }
  }
}