import 'package:attendy/model/user.dart';

class LoginResponse {
  final String status;
  final String message;
  final String? exception;
  final String? detail;
  final List<LoginData> datas;

  LoginResponse({
    required this.status,
    required this.message,
    this.exception,
    this.detail,
    required this.datas,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      exception: json['exception']?.toString() ?? '',
      detail: json['detail']?.toString() ?? '',
      datas: json['datas'] != null
          ? (json['datas'] as List)
              .map((data) => LoginData.fromJson(data))
              .toList()
          : [],
    );
  }

  bool isSuccess() {
    return status == "200";
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'exception': exception,
      'detail': detail,
      'datas': datas.map((data) => data.toJson()).toList(),
    };
  }
}

class LoginData {
  final String token;
  final User user;

  LoginData({
    required this.token,
    required this.user,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json['token'] as String,
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }
}
