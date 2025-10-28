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

  Future<void> login() async {
    // In a real app, you would get a token from your server
    await _storage.write(key: 'auth_token', value: 'dummy_token');
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    _isLoggedIn = false;
    notifyListeners();
  }
}