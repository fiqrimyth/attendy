import 'package:attendy/api/response/permit_response.dart';
import 'package:dio/dio.dart';

class PermitService {
  final dio = Dio();

  Future<PermitResponse> getPermitHistory() async {
    try {
      final response = await dio.get('localhost:3000/api/permits');
      return PermitResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Gagal mengambil data izin');
    }
  }

  Future<PermitResponse> createPermit(Map<String, dynamic> data) async {
    try {
      final response = await dio.post('localhost:3000/api/permits', data: data);
      return PermitResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Gagal membuat izin');
    }
  }

  Future<PermitResponse> getPermitDetail(String id) async {
    try {
      final response = await dio.get('localhost:3000/api/permits/$id');
      return PermitResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Gagal mengambil detail izin');
    }
  }
}
