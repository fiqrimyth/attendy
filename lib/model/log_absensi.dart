class LogAbsensi {
  final String id;
  final String type;
  final DateTime timestamp;
  final String status;
  final String? description;
  final String? attachment;
  final String employeeId;
  final String employeeName;
  final String department;
  final String position;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String month;

  LogAbsensi({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.status,
    required this.employeeId,
    required this.employeeName,
    required this.department,
    required this.position,
    required this.startDate,
    required this.endDate,
    this.description,
    this.attachment,
    required this.reason,
    required this.month,
  });

  factory LogAbsensi.fromJson(Map<String, dynamic> json) {
    return LogAbsensi(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      status: json['status'] ?? '',
      description: json['description'],
      attachment: json['attachment'],
      employeeId: json['employeeId'] ?? '',
      employeeName: json['employeeName'] ?? '',
      department: json['department'] ?? '',
      position: json['position'] ?? '',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : DateTime.now(),
      reason: json['reason'] ?? '',
      month: json['month'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'description': description,
      'attachment': attachment,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'department': department,
      'position': position,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'reason': reason,
      'month': month,
    };
  }

  static List<LogAbsensi> getDummyData() {
    return [
      LogAbsensi(
        id: 'A001',
        type: 'Clock In',
        timestamp: DateTime(2024, 4, 22, 7, 30),
        status: 'Approved',
        employeeId: 'EMP001',
        employeeName: 'John Doe',
        department: 'IT',
        position: 'Software Engineer',
        startDate: DateTime(2024, 4, 22, 7, 30),
        endDate: DateTime(2024, 4, 22, 7, 30),
        description: 'Absensi masuk tepat waktu',
        reason: 'Regular attendance',
        month: 'April',
      ),
      LogAbsensi(
        id: 'A002',
        type: 'Clock Out',
        timestamp: DateTime(2024, 4, 22, 16, 30),
        status: 'Approved',
        employeeId: 'EMP001',
        employeeName: 'John Doe',
        department: 'IT',
        position: 'Software Engineer',
        startDate: DateTime(2024, 4, 22, 16, 30),
        endDate: DateTime(2024, 4, 22, 16, 30),
        description: 'Absensi pulang tepat waktu',
        reason: 'End of working hours',
        month: 'April',
      ),
      LogAbsensi(
        id: 'M001',
        type: 'Clock In',
        timestamp: DateTime(2024, 3, 22, 7, 30),
        status: 'Approved',
        employeeId: 'EMP001',
        employeeName: 'John Doe',
        department: 'IT',
        position: 'Software Engineer',
        startDate: DateTime(2024, 3, 22, 7, 30),
        endDate: DateTime(2024, 3, 22, 7, 30),
        description: 'Absensi masuk tepat waktu',
        reason: 'Regular attendance',
        month: 'Maret',
      ),
      LogAbsensi(
        id: 'M001',
        type: 'Clock In',
        timestamp: DateTime(2024, 3, 22, 7, 30),
        status: 'Approved',
        employeeId: 'EMP001',
        employeeName: 'John Doe',
        department: 'IT',
        position: 'Software Engineer',
        startDate: DateTime(2024, 3, 22, 7, 30),
        endDate: DateTime(2024, 3, 22, 7, 30),
        description: 'Absensi masuk tepat waktu',
        reason: 'Regular attendance',
        month: 'Maret',
      ),
    ];
  }
}
