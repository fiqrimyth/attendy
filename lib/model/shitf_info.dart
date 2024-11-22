class ShiftInfo {
  final String id;
  final String shiftName;
  final String shiftTime;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final String? description;
  final String? attachment;

  ShiftInfo({
    required this.id,
    required this.shiftName,
    required this.shiftTime,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.description,
    this.attachment,
  });

  factory ShiftInfo.fromJson(Map<String, dynamic> json) {
    return ShiftInfo(
      id: json['id'] ?? '',
      shiftName: json['shift_name'] ?? '',
      shiftTime: json['shift_time'] ?? '',
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      status: json['status'] ?? '',
      description: json['description'],
      attachment: json['attachment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shift_name': shiftName,
      'shift_time': shiftTime,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'status': status,
      'description': description,
      'attachment': attachment,
    };
  }

  static List<ShiftInfo> getDummyData() {
    return [
      ShiftInfo(
        id: '1',
        shiftName: 'Pagi',
        shiftTime: '07:00 - 15:00',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 8)),
        status: 'Active',
        description: 'Shift pagi reguler',
      ),
      ShiftInfo(
        id: '2',
        shiftName: 'Siang',
        shiftTime: '15:00 - 23:00',
        startTime: DateTime.now().add(const Duration(hours: 8)),
        endTime: DateTime.now().add(const Duration(hours: 16)),
        status: 'Inactive',
        description: 'Shift siang reguler',
      ),
    ];
  }
}
