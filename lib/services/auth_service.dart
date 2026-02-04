import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  /// Lazy FirebaseAuth access (SAFE)
  FirebaseAuth get _auth => FirebaseAuth.instance;

  /// Sign up a new user with email and password
  Future<User?> signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('Signup error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected signup error: $e');
      return null;
    }
  }

  /// Log in a user with email and password
  Future<User?> logIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected login error: $e');
      return null;
    }
  }

  /// Log out the current user
  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  /// Get current logged-in user
  User? get currentUser => _auth.currentUser;

  /// Stream of authentication state changes
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;

  /// Get current user's email
  String? get currentUserEmail => _auth.currentUser?.email;

  /// Get current user's UID
  String? get currentUserUID => _auth.currentUser?.uid;
}
