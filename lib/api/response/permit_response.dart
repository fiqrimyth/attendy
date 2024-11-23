import 'package:attendy/model/permit_history.dart';

class PermitResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> errors;
  final Map<String, int> summary;
  final List<PermitHistory> data;

  PermitResponse({
    required this.success,
    required this.message,
    required this.errors,
    required this.summary,
    required this.data,
  });

  factory PermitResponse.fromJson(Map<String, dynamic> json) {
    return PermitResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      errors: json['errors'] != null
          ? Map<String, dynamic>.from(json['errors'])
          : {},
      data: (json['data'] as List?)
              ?.map((e) => PermitHistory.fromJson(e))
              .toList() ??
          [],
      summary: (json['summary'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as int? ?? 0)) ??
          {
            'jatah_cuti': 0,
            'absen': 0,
            'alpha': 0,
            'izin': 0,
            'cuti': 0,
            'lembur': 0,
          },
    );
  }

  String get errorMessage {
    if (errors.isNotEmpty) {
      return errors.values.join('\n');
    }
    return message;
  }
}
