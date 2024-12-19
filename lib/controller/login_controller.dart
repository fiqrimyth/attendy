import 'package:attendy/api/response/login_response.dart';
import 'package:attendy/api/response/logout_response.dart';
import 'package:attendy/model/login.dart';
import 'package:attendy/service/auth_service.dart';

class LoginController {
  final AuthService _authService = AuthService();

  Future<LoginResponse> handleLogin(
      String email, String password, String deviceId) async {
    try {
      final loginData = Login(
        email: email,
        password: password,
        deviceId: deviceId,
      );

      final response = await _authService.login(loginData);
      return response;
    } catch (e) {
      // Menangani berbagai jenis error response
      if (e.toString().contains('400')) {
        return LoginResponse(
          status: '400',
          message: 'Email atau password salah',
          datas: [],
        );
      } else if (e.toString().contains('401')) {
        return LoginResponse(
          status: '401',
          message: 'Unauthorized: Kredensial tidak valid',
          datas: [],
        );
      } else if (e.toString().contains('403')) {
        return LoginResponse(
          status: '403',
          message: 'Akses ditolak',
          datas: [],
        );
      } else if (e.toString().contains('404')) {
        return LoginResponse(
          status: '404',
          message: 'Pengguna tidak ditemukan',
          datas: [],
        );
      } else {
        return LoginResponse(
          status: '500',
          message: 'Terjadi kesalahan pada server: ${e.toString()}',
          datas: [],
        );
      }
    }
  }

  Future<LogoutResponse> handleLogout() async {
    try {
      final response = await _authService.logout();
      return response;
    } catch (e) {
      // Menangani berbagai jenis error response
      if (e.toString().contains('400')) {
        return LogoutResponse(
          status: '400',
          message: 'Permintaan logout tidak valid',
          datas: [],
        );
      } else if (e.toString().contains('401')) {
        return LogoutResponse(
          status: '401',
          message: 'Unauthorized: Token tidak valid atau kadaluarsa',
          datas: [],
        );
      } else if (e.toString().contains('403')) {
        return LogoutResponse(
          status: '403',
          message: 'Akses ditolak',
          datas: [],
        );
      } else if (e.toString().contains('404')) {
        return LogoutResponse(
          status: '404',
          message: 'Sesi tidak ditemukan',
          datas: [],
        );
      } else {
        return LogoutResponse(
          status: '500',
          message: 'Terjadi kesalahan pada server: ${e.toString()}',
          datas: [],
        );
      }
    }
  }

  // Fungsi untuk cek status login
  Future<bool> isLoggedIn() async {
    final token = await _authService.getToken();
    return token != null && token.isNotEmpty;
  }
}
