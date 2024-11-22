class OvertimePermit {
  final String id;
  final String employeeId;
  final String employeeName;
  final String date;
  final String startTime;
  final String endTime;
  final String startDate;
  final String endDate;
  final String reason;
  final String compensationType;
  final bool isHourly;
  final String type;
  final String description;
  final String status;
  final String createdAt;
  final String updatedAt;

  OvertimePermit({
    this.id = '',
    this.employeeId = '',
    this.employeeName = '',
    required this.date,
    this.startTime = '',
    this.endTime = '',
    this.startDate = '',
    this.endDate = '',
    this.reason = '',
    this.compensationType = '',
    this.isHourly = true,
    required this.type,
    required this.description,
    this.status = 'Pending',
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory OvertimePermit.fromJson(Map<String, dynamic> json) {
    return OvertimePermit(
      id: json['id'] ?? '',
      employeeId: json['employee_id'] ?? '',
      employeeName: json['employee_name'] ?? '',
      date: json['date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      reason: json['reason'] ?? '',
      compensationType: json['compensation_type'] ?? '',
      isHourly: json['is_hourly'] ?? true,
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Pending',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'start_date': startDate,
      'end_date': endDate,
      'reason': reason,
      'compensation_type': compensationType,
      'is_hourly': isHourly,
      'type': type,
      'description': description,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static List<OvertimePermit> getDummyData() {
    return [
      OvertimePermit(
        id: '1',
        employeeId: 'EMP001',
        employeeName: 'John Doe',
        date: '22 April 2024',
        type: 'Lembur Kerja Jam',
        description: '2 Jam',
        isHourly: true,
        startTime: '17:00',
        endTime: '19:00',
        reason: 'Menyelesaikan project',
        status: 'Approved',
        compensationType: 'Paid Overtime',
        createdAt: '2024-04-22 10:00:00',
        updatedAt: '2024-04-22 15:30:00',
      ),
      OvertimePermit(
        id: '2',
        employeeId: 'EMP001',
        employeeName: 'John Doe',
        date: '22 April 2024',
        type: 'Lembur Kerja Hari',
        description: '1 Hari',
        isHourly: false,
        startDate: '22 April 2024',
        endDate: '23 April 2024',
        reason: 'Menyelesaikan project',
        status: 'Pending',
        compensationType: 'Leave Overtime',
        createdAt: '2024-04-22 09:00:00',
        updatedAt: '2024-04-22 09:00:00',
      ),
    ];
  }
}
