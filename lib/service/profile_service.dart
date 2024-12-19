import 'package:attendy/config/api_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:attendy/service/auth_service.dart';

class ProfileService {
  static final ProfileService instance = ProfileService._internal();
  final Dio _dio = Dio();

  ProfileService._internal();

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final token = await AuthService.instance.getToken();
      debugPrint('Getting user profile with token: $token');

      if (token == null) throw Exception('Token not found');

      final response = await _dio.get(
        '${ApiConfig.baseUrl}/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint('Profile response: ${response.data}');
      return response.data;
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      rethrow;
    }
  }
}
