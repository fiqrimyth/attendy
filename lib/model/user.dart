class User {
  final String userId;
  final String fullName;
  final String jobType;
  final String photo;
  final ShiftSchedule shiftSchedule;
  final NotificationInfo notifications;
  final List<dynamic> attendanceHistory;

  User({
    required this.userId,
    required this.fullName,
    required this.jobType,
    required this.photo,
    required this.shiftSchedule,
    required this.notifications,
    required this.attendanceHistory,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      fullName: json['fullName'],
      jobType: json['jobType'],
      photo: json['photo'],
      shiftSchedule: ShiftSchedule.fromJson(json['shiftSchedule']),
      notifications: NotificationInfo.fromJson(json['notifications']),
      attendanceHistory: json['attendanceHistory'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'jobType': jobType,
      'photo': photo,
      'shiftSchedule': shiftSchedule.toJson(),
      'notifications': notifications.toJson(),
    };
  }
}

// Class pendukung lainnya
class ShiftSchedule {
  final int assignedShift;
  final List<Shift> shifts;
  final CurrentShift currentShift;

  ShiftSchedule({
    required this.assignedShift,
    required this.shifts,
    required this.currentShift,
  });

  factory ShiftSchedule.fromJson(Map<String, dynamic> json) {
    return ShiftSchedule(
      assignedShift: json['assignedShift'],
      shifts: (json['shifts'] as List).map((e) => Shift.fromJson(e)).toList(),
      currentShift: CurrentShift.fromJson(json['currentShift']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assignedShift': assignedShift,
      'shifts': shifts.map((shift) => shift.toJson()).toList(),
      'currentShift': currentShift.toJson(),
    };
  }
}

// Tambahkan class Shift, CurrentShift, dan NotificationInfo sesuai kebutuhan
class NotificationInfo {
  final bool hasUnread;
  final int count;

  NotificationInfo({
    required this.hasUnread,
    required this.count,
  });

  factory NotificationInfo.fromJson(Map<String, dynamic> json) {
    return NotificationInfo(
      hasUnread: json['hasUnread'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasUnread': hasUnread,
      'count': count,
    };
  }
}

class Shift {
  final int id;
  final String name;
  final String startTime;
  final String endTime;

  Shift({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id'],
      name: json['name'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

class CurrentShift {
  final String startTime;
  final String endTime;

  CurrentShift({
    required this.startTime,
    required this.endTime,
  });

  factory CurrentShift.fromJson(Map<String, dynamic> json) {
    return CurrentShift(
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
