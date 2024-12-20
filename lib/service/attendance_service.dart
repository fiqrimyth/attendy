import 'package:attendy/config/api_config.dart';
import 'package:attendy/model/log_absensi.dart';
import 'package:attendy/service/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AttendanceService {
  final dio = Dio();

  Future<List<LogAbsensi>> getAttendanceHistory(String userId) async {
    try {
      final token = await AuthService.instance.getToken();
      if (token == null) throw Exception('Token tidak ditemukan');

      // Pastikan userId tidak kosong
      if (userId.isEmpty) throw Exception('User ID tidak boleh kosong');

      debugPrint('Fetching attendance history for userId: $userId');

      final response = await dio.get(
        '${ApiConfig.baseUrl}/api/history/$userId', // Pastikan userId terisi
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => true,
        ),
      );
      
      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      // Cek status dari response body
      if (response.data['status'] == '200') {
        final List<dynamic> monthData = response.data['datas'] ?? [];
        List<LogAbsensi> allLogs = [];

        // Iterasi melalui setiap bulan
        for (var month in monthData) {
          if (month['attendances'] != null) {
            for (var attendance in month['attendances']) {
              try {
                allLogs.add(LogAbsensi.fromJson(attendance));
              } catch (e) {
                debugPrint('Error parsing attendance: $e');
              }
            }
          }
        }

        return allLogs;
      } else {
        throw Exception(response.data['message'] ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      debugPrint('Error in getAttendanceHistory: $e');
      rethrow;
    }
  }
}
