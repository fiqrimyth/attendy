import 'package:attendy/api/response/permit_response.dart';
import 'package:attendy/config/api_config.dart';
import 'package:attendy/model/permit_history.dart';
import 'package:attendy/model/permit_type.dart';
import 'package:attendy/service/auth_service.dart';
import 'package:dio/dio.dart';

class PermitService {
  final dio = Dio();

  Future<List<PermitType>> getPermitTypes(String userId) async {
    try {
      final token = await AuthService.instance.getToken();

      if (token == null) throw Exception('Token tidak ditemukan');

      final response = await dio.get(
        '${ApiConfig.baseUrl}/api/leave-typeId/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          throw Exception('Response data is null');
        }

        if (!response.data.containsKey('datas')) {
          throw Exception('Response does not contain "datas" key');
        }

        final List<dynamic> data = response.data['datas'];

        List<PermitType> types = [];
        for (var item in data) {
          try {
            types.add(PermitType.fromJson(item));
          } catch (e) {
            print('Error parsing item: $item');
          }
        }

        return types;
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PermitHistory>> getPermitHistory(String userId) async {
    try {
      final token = await AuthService.instance.getToken();

      if (token == null) throw Exception('Token tidak ditemukan');

      final response = await dio.get(
        '${ApiConfig.baseUrl}/api/permission-history/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          throw Exception('Response data is null');
        }

        if (!response.data.containsKey('datas')) {
          throw Exception('Response does not contain "datas" key');
        }

        final List<dynamic> data = response.data['datas'];

        List<PermitHistory> histories = [];
        for (var item in data) {
          try {
            histories.add(PermitHistory.fromJson(item));
          } catch (e) {
            print('Error parsing item: $item');
          }
        }

        return histories;
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.data}');
      }
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
