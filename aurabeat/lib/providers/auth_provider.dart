import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../core/utils/storage_helper.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  bool _isAuthenticated = false;
  User? _currentUser;
  String? _error;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;
  String? get error => _error;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await StorageHelper.isLoggedIn();
    if (isLoggedIn) {
      _isAuthenticated = true;
      final userId = StorageHelper.getUserId();
      final username = StorageHelper.getUsername();
      if (userId != null && username != null) {
        _currentUser = User(id: userId, username: username);
      }
    }
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final request = LoginRequest(username: username, password: password);
      final response = await _authService.login(request);
      
      await StorageHelper.saveToken(response.token);
      if (response.user != null) {
        await StorageHelper.saveUserId(response.user!.id);
        await StorageHelper.saveUsername(response.user!.username);
        _currentUser = response.user;
      }
      
      _isAuthenticated = true;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String username, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final request = RegisterRequest(username: username, password: password);
      final response = await _authService.register(request);
      
      // await StorageHelper.saveToken(response.token);
      // if (response.user != null) {
      //   await StorageHelper.saveUserId(response.user!.id);
      //   await StorageHelper.saveUsername(response.user!.username);
      //   _currentUser = response.user;
      // }
      
      //_isAuthenticated = true;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await StorageHelper.clearAll();
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}