import 'dart:async';

import 'package:attendy/config/api_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:attendy/service/auth_service.dart';

class DateTimeService {
  static final DateTimeService instance = DateTimeService._internal();
  final Dio _dio = Dio();
  DateTime? _serverDateTime;
  Timer? _syncTimer;

  DateTimeService._internal();

  Future<DateTime> getServerDateTime() async {
    try {
      if (_serverDateTime == null) {
        debugPrint('Server datetime is null, syncing with server...');
        await syncDateTime();
      }

      final now = _serverDateTime ?? DateTime.now();
      debugPrint('Current server time: ${now.toIso8601String()}');
      return now;
    } catch (e) {
      debugPrint('Error in getServerDateTime: $e');
      rethrow;
    }
  }

  Future<void> syncDateTime() async {
    try {
      debugPrint('Syncing datetime with server...');
      final token = await AuthService.instance.getToken();

      debugPrint('Using token: $token');
      debugPrint('Calling endpoint: ${ApiConfig.baseUrl}/datetime');

      if (token == null) {
        debugPrint('Token not found');
        throw Exception('Token not found');
      }

      final response = await _dio.get(
        '${ApiConfig.baseUrl}/datetime',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint('Server response: ${response.data}');

      if (response.statusCode == 200) {
        _serverDateTime = DateTime.parse(response.data['datetime']);
        debugPrint(
            'Server datetime synced: ${_serverDateTime?.toIso8601String()}');

        // Reset timer jika sudah ada
        _syncTimer?.cancel();

        // Update local time setiap detik berdasarkan server time
        _syncTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          _serverDateTime = _serverDateTime?.add(const Duration(seconds: 1));
        });
      }
    } catch (e) {
      debugPrint('Error syncing datetime: $e');
      rethrow;
    }
  }

  void dispose() {
    debugPrint('Disposing DateTimeService');
    _syncTimer?.cancel();
    _serverDateTime = null;
  }
}
