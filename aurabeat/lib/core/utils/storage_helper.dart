import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static SharedPreferences? _prefs;

  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token management (secure storage)
  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  static Future<void> clearToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  // User data (shared preferences)
  static Future<void> saveUserId(int userId) async {
    await _prefs?.setInt(_userIdKey, userId);
  }

  static int? getUserId() {
    return _prefs?.getInt(_userIdKey);
  }

  static Future<void> saveUsername(String username) async {
    await _prefs?.setString(_usernameKey, username);
  }

  static String? getUsername() {
    return _prefs?.getString(_usernameKey);
  }

  static Future<void> clearUserData() async {
    await _prefs?.remove(_userIdKey);
    await _prefs?.remove(_usernameKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Clear all data (logout)
  static Future<void> clearAll() async {
    await clearToken();
    await clearUserData();
  }

  // Generic string storage
  static Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  // Generic int storage
  static Future<void> saveInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  // Generic bool storage
  static Future<void> saveBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  // Generic list storage
  static Future<void> saveStringList(String key, List<String> value) async {
    await _prefs?.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return _prefs?.getStringList(key);
  }

  // Remove specific key
  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }
}