import 'dart:convert';
import 'package:furcare_app/core/errors/exceptions.dart';
import 'package:furcare_app/data/models/auth_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> saveAccessToken(String token);
  Future<String?> getAccessToken();
  Future<void> clearUserData();
  Future<bool> hasValidSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _sharedPreferences;

  static const String _keyUser = 'user';
  static const String _keyAccessToken = 'access_token';

  AuthLocalDataSourceImpl({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  @override
  Future<void> saveUser(User user) async {
    try {
      final userJson = json.encode(user.toJson());
      await _sharedPreferences.setString(_keyUser, userJson);
    } catch (e) {
      throw CacheException(message: 'Failed to save user data');
    }
  }

  @override
  Future<User?> getUser() async {
    try {
      final userJson = _sharedPreferences.getString(_keyUser);
      if (userJson == null) return null;

      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    } catch (e) {
      throw CacheException(message: 'Failed to retrieve user data');
    }
  }

  @override
  Future<void> saveAccessToken(String token) async {
    try {
      await _sharedPreferences.setString(_keyAccessToken, token);
    } catch (e) {
      throw CacheException(message: 'Failed to save access token');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return _sharedPreferences.getString(_keyAccessToken);
    } catch (e) {
      throw CacheException(message: 'Failed to retrieve access token');
    }
  }

  @override
  Future<void> clearUserData() async {
    try {
      await _sharedPreferences.remove(_keyUser);
      await _sharedPreferences.remove(_keyAccessToken);
      await _sharedPreferences.remove('selected_branch_id');
    } catch (e) {
      throw CacheException(message: 'Failed to clear user data');
    }
  }

  @override
  Future<bool> hasValidSession() async {
    try {
      final token = await getAccessToken();
      final user = await getUser();
      return token != null && user != null;
    } catch (e) {
      return false;
    }
  }
}
