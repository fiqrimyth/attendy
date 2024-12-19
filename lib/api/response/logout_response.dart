import 'dart:convert';

class LogoutResponse {
  final String message;
  final String status;
  final dynamic exception;
  final dynamic detail;
  final List<dynamic> datas;

  LogoutResponse({
    required this.message,
    required this.status,
    this.exception,
    this.detail,
    required this.datas,
  });

  factory LogoutResponse.fromJson(String str) {
    final Map<String, dynamic> json = jsonDecode(str);
    return LogoutResponse(
      message: json['message'],
      status: json['status'],
      exception: json['exception'],
      detail: json['detail'],
      datas: json['datas'] ?? [],
    );
  }
}
