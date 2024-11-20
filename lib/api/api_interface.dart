import 'package:dio/dio.dart';
import 'package:attendy/api/api_response.dart';
import '../model/shitf_info.dart';

class ApiService {
  final Dio _dio = Dio();

  // ... kode lainnya ...

  Future<ApiResponse<ShiftInfo>> getEmployeeShift() async {
    try {
      final response = await _dio.get('/employee/shift');

      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          data: ShiftInfo.fromJson(response.data),
        );
      }

      return ApiResponse(
        success: false,
        message: response.data['message'] ?? 'Gagal mendapatkan info shift',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Terjadi kesalahan: $e',
      );
    }
  }
}
