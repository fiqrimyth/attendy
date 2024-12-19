import 'package:attendy/model/log_absensi.dart';
import 'package:dio/dio.dart';

class AttendanceService {
  final String baseUrl = 'localhost:3000/api';
  final dio = Dio(); // Menggunakan package dio untuk HTTP request

  Future<List<LogAbsensi>> getAttendanceHistory() async {
    try {
      final response = await dio.get('$baseUrl/attendance/history');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => LogAbsensi.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data absensi');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
