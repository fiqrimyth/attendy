class ShiftInfo {
  final String shiftName;
  final String shiftTime;
  final DateTime startTime;
  final DateTime endTime;

  ShiftInfo({
    required this.shiftName,
    required this.shiftTime,
    required this.startTime,
    required this.endTime,
  });

  factory ShiftInfo.fromJson(Map<String, dynamic> json) {
    return ShiftInfo(
      shiftName: json['shift_name'] ?? '',
      shiftTime: json['shift_time'] ?? '',
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
    );
  }
}
