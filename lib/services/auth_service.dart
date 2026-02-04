import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _sessionKey = "is_logged_in";

  // Register with Email & Password
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An error occurred during registration";
    }
  }

  // Login with Email & Password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveSession();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "An error occurred during login";
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
    await _clearSession();
  }

  // Session Management
  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sessionKey, true);
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sessionKey) ?? false;
  }
}
