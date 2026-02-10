import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

/// State provider for managing authentication with Provider pattern
/// 
/// This provider handles:
/// - User authentication state
/// - Sign up, login, and logout
/// - User session management
/// - Authentication errors
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  String? get userEmail => _user?.email;
  String? get userId => _user?.uid;

  AuthProvider() {
    // Listen to auth state changes
    _authService.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  /// Sign up a new user
  Future<bool> signUp(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _authService.signUp(email, password);
      _user = user;
      _isLoading = false;
      notifyListeners();
      return user != null;
    } catch (e) {
      _error = _formatError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Login existing user
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _authService.login(email, password);
      _user = user;
      _isLoading = false;
      notifyListeners();
      return user != null;
    } catch (e) {
      _error = _formatError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _user = null;
      _error = null;
    } catch (e) {
      _error = _formatError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Format Firebase Auth errors for user-friendly messages
  String _formatError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'This email is already registered';
        case 'invalid-email':
          return 'Invalid email address';
        case 'weak-password':
          return 'Password is too weak (min 6 characters)';
        case 'user-not-found':
          return 'No user found with this email';
        case 'wrong-password':
          return 'Incorrect password';
        case 'too-many-requests':
          return 'Too many failed attempts. Try again later';
        case 'network-request-failed':
          return 'Network error. Check your connection';
        default:
          return error.message ?? 'Authentication error occurred';
      }
    }
    return error.toString();
  }
}
