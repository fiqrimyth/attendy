class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final String status;
  final String? type;
  final String? description;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.status,
    this.type,
    this.description,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      status: json['status'] ?? '',
      type: json['type'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'date': date.toIso8601String(),
      'status': status,
      'type': type,
      'description': description,
    };
  }

  static List<NotificationModel> getDummyData() {
    return [
      NotificationModel(
        id: '1',
        title: 'Absensi Berhasil',
        message: 'Anda telah berhasil melakukan absensi masuk hari ini',
        date: DateTime.now(),
        status: 'Diajukan',
        type: 'attendance',
        description: 'Absensi masuk',
      ),
      NotificationModel(
        id: '2',
        title: 'Pengingat Absensi',
        message: 'Jangan lupa untuk melakukan absensi pulang hari ini',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        status: 'Ditolak',
        type: 'reminder',
        description: 'Pengingat absensi pulang',
      ),
    ];
  }
}
