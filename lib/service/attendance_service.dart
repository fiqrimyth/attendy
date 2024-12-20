import 'package:attendy/config/api_config.dart';
import 'package:attendy/model/log_absensi.dart';
import 'package:attendy/service/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AttendanceService {
  final dio = Dio(); // Menggunakan package dio untuk HTTP request

  Future<List<LogAbsensi>> getAttendanceHistory(String userId) async {
    try {
      final token = await AuthService.instance.getToken();
      if (token == null) throw Exception('Token tidak ditemukan');

      final response = await dio.get(
        '${ApiConfig.baseUrl}/api/history/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => true,
        ),
      );
      debugPrint('response log history: $response');
      debugPrint('Status Code history: ${response.statusCode}');

      // Cek status dari response body
      if (response.data['status'] == '200') {
        // Jika datas adalah array kosong, langsung return list kosong
        if (response.data['datas'] == null || response.data['datas'].isEmpty) {
          return [];
        }

        final List<dynamic> data = response.data['datas'];
        List<LogAbsensi> types = [];

        for (var item in data) {
          try {
            types.add(LogAbsensi.fromJson(item));
          } catch (e) {
            print('Error parsing item: $item');
          }
        }

        return types;
      } else {
        throw Exception(response.data['message'] ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      rethrow;
    }
  }
}
