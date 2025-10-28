import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  bool _isLoggedIn = false;
  bool _isLoading = true;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _tryAutoLogin();
  }

  Future<void> _tryAutoLogin() async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      _isLoggedIn = true;
      // Notify about logged-in state; loading will be cleared below.
      notifyListeners();
    }
    // Loading finished regardless of token presence
    _isLoading = false;
    notifyListeners();
  }

  /// Attempts to log in. Returns `true` on success, `false` on failure.
  ///
  /// In a real app this would call an API and return success based on
  /// server response. Here we simulate persistent storage of a token.
  /// Attempts to log in using provided [username] and [password].
  /// Returns `true` on success, `false` on failure.
  ///
  /// Currently this simulates storing a token; replace with real API call.
  Future<bool> login(String username, String password) async {
    // Simple client-side validation first
    if (username.trim().isEmpty || password.length < 4) {
      return false; // invalid credentials
    }

    try {
      // Simulate a network call latency
      await Future.delayed(const Duration(milliseconds: 1200));

      // Simulate occasional network failures
      final random = DateTime.now().millisecondsSinceEpoch % 10;
      if (random == 0) {
        // simulate network error ~10% of the time
        throw Exception('Network error');
      }

      // Simulate server-side credential check: here we accept any
      // username/password that passed the client-side validation.
      // Replace this block with a real HTTP call when you have an API.

      // On success: persist token
      await _storage.write(key: 'auth_token', value: 'dummy_token');
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } catch (e) {
      // If writing to storage fails or network error, ensure state remains logged out
      _isLoggedIn = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    _isLoggedIn = false;
    notifyListeners();
  }
}