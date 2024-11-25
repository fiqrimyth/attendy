import 'package:attendy/api/response/approval_response.dart';
import 'package:dio/dio.dart';

class ApprovalService {
  final dio = Dio();

  Future<ApprovalResponse> getPermitHistory() async {
    try {
      final response = await dio.get('YOUR_API_ENDPOINT/permits');
      return ApprovalResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Gagal mengambil data izin');
    }
  }

  Future<ApprovalResponse> createPermit(Map<String, dynamic> data) async {
    try {
      final response = await dio.post('YOUR_API_ENDPOINT/permits', data: data);
      return ApprovalResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Gagal membuat izin');
    }
  }

  Future<ApprovalResponse> getPermitDetail(String id) async {
    try {
      final response = await dio.get('YOUR_API_ENDPOINT/permits/$id');
      return ApprovalResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Gagal mengambil detail izin');
    }
  }
}
