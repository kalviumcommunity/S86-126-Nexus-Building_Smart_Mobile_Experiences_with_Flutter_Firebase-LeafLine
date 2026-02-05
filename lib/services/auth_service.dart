import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// Sign up a new user with email and password
  Future<User?> signUp(String email, String password) async {
    try {
      final result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Signup error: $e');
      return null;
    }
  }

  /// Log in a user with email and password
  Future<User?> login(String email, String password) async {
    try {
      final result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  /// Log out the current user
  Future<void> logOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  /// Alias for logOut
  Future<void> logout() async {
    await logOut();
  }

  /// Get current logged-in user
  User? get currentUser => auth.currentUser;

  /// Stream of authentication state changes
  Stream<User?> authStateChanges() => auth.authStateChanges();

  /// Check if user is logged in
  bool get isLoggedIn => auth.currentUser != null;

  /// Get current user's email
  String? get currentUserEmail => auth.currentUser?.email;

  /// Get current user's UID
  String? get currentUserUID => auth.currentUser?.uid;
}
