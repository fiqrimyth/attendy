class LogAbsensi {
  final String userId;
  final DateTime time;
  final String type;
  final String date;
  final String status;
  final Shift shift;
  final Location location;
  final String? photo;

  LogAbsensi({
    required this.userId,
    required this.time,
    required this.type,
    required this.date,
    required this.status,
    required this.shift,
    required this.location,
    this.photo,
  });

  factory LogAbsensi.fromJson(Map<String, dynamic> json) {
    return LogAbsensi(
      userId: json['userId'] ?? '',
      time:
          json['time'] != null ? DateTime.parse(json['time']) : DateTime.now(),
      type: json['type'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      shift: json['shift'] != null
          ? Shift.fromJson(json['shift'])
          : Shift(name: '', startTime: '', endTime: ''),
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : Location(type: 'Point', coordinates: [0, 0]),
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'time': time.toIso8601String(),
      'type': type,
      'date': date,
      'status': status,
      'shift': shift.toJson(),
      'location': location.toJson(),
      'photo': photo,
    };
  }
}

class Shift {
  final String name;
  final String startTime;
  final String endTime;

  Shift({
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      name: json['name'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? '',
      coordinates: List<double>.from(json['coordinates'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}
