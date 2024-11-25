import 'package:attendy/model/approval.dart';

class ApprovalResponse {
  final bool success;
  final String message;
  final Map<String, dynamic> errors;
  final List<Approval> data;

  ApprovalResponse({
    required this.success,
    required this.message,
    required this.errors,
    required this.data,
  });

  factory ApprovalResponse.fromJson(Map<String, dynamic> json) {
    return ApprovalResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      errors: json['errors'] != null
          ? Map<String, dynamic>.from(json['errors'])
          : {},
      data:
          (json['data'] as List?)?.map((e) => Approval.fromJson(e)).toList() ??
              [],
    );
  }

  String get errorMessage {
    if (errors.isNotEmpty) {
      return errors.values.join('\n');
    }
    return message;
  }
}
