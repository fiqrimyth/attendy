import 'package:http/http.dart' as http;
import 'package:attendy/api/response/login_response.dart';
import 'package:attendy/model/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:attendy/model/user.dart';
import 'package:attendy/api/response/logout_response.dart';
import 'dart:convert';
import 'package:attendy/config/api_config.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final AuthService instance = AuthService._internal();
  factory AuthService() => instance;
  AuthService._internal();

  User? _currentUser;
  String? _token;

  Future<LoginResponse> login(Login loginData) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginData.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(decodedResponse);

        // Simpan data jika login berhasil
        if (loginResponse.isSuccess() && loginResponse.datas.isNotEmpty) {
          final loginData = loginResponse.datas.first;
          await saveToken(loginData.token);
          await saveUserData(loginData.user);
        }

        return loginResponse;
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error during login: $e');
      rethrow;
    }
  }

  Future<LogoutResponse> logout() async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/logout'),
      );

      // Clear stored data
      await clearUserData();

      return LogoutResponse.fromJson(response.body);
    } catch (e) {
      debugPrint('Error during logout: $e');
      rethrow;
    }
  }

  Future<String?> getToken() async {
    if (_token != null) return _token;

    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  Future<void> saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    debugPrint('Token saved: $token');
  }

  Future<void> saveUserData(User user) async {
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();

    // Simpan user sebagai JSON string
    final userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);

    // Simpan juga field individual untuk kemudahan akses
    await prefs.setString('user_id', user.userId);
    await prefs.setString('full_name', user.fullName);
    await prefs.setString('job_type', user.jobType);
    await prefs.setString('photo', user.photo);

    debugPrint('User data saved: $userJson');
  }

  Future<User?> getUser() async {
    if (_currentUser != null) {
      debugPrint('Returning cached user: ${_currentUser?.toJson()}');
      return _currentUser;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');

      if (userJson != null) {
        final userData = jsonDecode(userJson);
        _currentUser = User.fromJson(userData);
        debugPrint('Loaded user from prefs: ${_currentUser?.toJson()}');
        return _currentUser;
      }

      debugPrint('No user data found');
      return null;
    } catch (e) {
      debugPrint('Error getting user data: $e');
      return null;
    }
  }

  Future<void> clearUserData() async {
    _currentUser = null;
    _token = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user');
    await prefs.remove('user_id');
    await prefs.remove('full_name');
    await prefs.remove('job_type');
    await prefs.remove('photo');

    debugPrint('User data cleared');
  }
}
