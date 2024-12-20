class PermitHistory {
  final String id;
  final String userId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Field untuk Lembur
  final DateTime? overtimeDate;
  final String? startTime;
  final String? endTime;
  final String? overtimeReason;

  // Field untuk Izin
  final String? leaveCategory; // enum: "SICK", "ANNUAL", "OTHER"
  final DateTime? leaveDate;
  final String? delegatedTo;
  final AttachmentFile? attachmentFile;
  final String? leaveReason;

  // Field untuk Cuti
  final DateTime? startDate;
  final DateTime? endDate;

  const PermitHistory({
    required this.id,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.overtimeDate,
    this.startTime,
    this.endTime,
    this.overtimeReason,
    this.leaveCategory,
    this.leaveDate,
    this.delegatedTo,
    this.attachmentFile,
    this.leaveReason,
    this.startDate,
    this.endDate,
  });

  factory PermitHistory.fromJson(Map<String, dynamic> json) {
    return PermitHistory(
      id: json['id'],
      userId: json['userId'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      overtimeDate: json['overtimeDate'] != null
          ? DateTime.parse(json['overtimeDate'])
          : null,
      startTime: json['startTime'],
      endTime: json['endTime'],
      overtimeReason: json['overtimeReason'],
      leaveCategory: json['leaveCategory'],
      leaveDate:
          json['leaveDate'] != null ? DateTime.parse(json['leaveDate']) : null,
      delegatedTo: json['delegatedTo'],
      attachmentFile: json['attachmentFile'] != null
          ? AttachmentFile.fromJson(json['attachmentFile'])
          : null,
      leaveReason: json['leaveReason'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'overtimeDate': overtimeDate?.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'overtimeReason': overtimeReason,
      'leaveCategory': leaveCategory,
      'leaveDate': leaveDate?.toIso8601String(),
      'delegatedTo': delegatedTo,
      'attachmentFile': attachmentFile?.toJson(),
      'leaveReason': leaveReason,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}

class AttachmentFile {
  final String? fileName;
  final String? filePath;

  const AttachmentFile({
    this.fileName,
    this.filePath,
  });

  factory AttachmentFile.fromJson(Map<String, dynamic> json) {
    return AttachmentFile(
      fileName: json['fileName'],
      filePath: json['filePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'filePath': filePath,
    };
  }
}
