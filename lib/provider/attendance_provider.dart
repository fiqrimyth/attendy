import 'package:attendy/model/log_absensi.dart';
import 'package:attendy/service/attendance_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceProvider extends ChangeNotifier {
  final AttendanceService _service = AttendanceService();

  Map<String, List<LogAbsensi>> _groupedAttendance = {};
  bool _isLoading = false;
  String? _error;

  Map<String, List<LogAbsensi>> get groupedAttendance => _groupedAttendance;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setData(Map<String, List<LogAbsensi>> data) {
    _groupedAttendance = data;
    notifyListeners();
  }

  Future<void> fetchAttendanceHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<LogAbsensi> logs = await _service.getAttendanceHistory();
      _groupedAttendance = _groupAttendanceByMonth(logs);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, List<LogAbsensi>> _groupAttendanceByMonth(List<LogAbsensi> logs) {
    Map<String, List<LogAbsensi>> grouped = {};

    for (var log in logs) {
      String monthYear = DateFormat('MMMM yyyy', 'id_ID').format(log.timestamp);
      if (!grouped.containsKey(monthYear)) {
        grouped[monthYear] = [];
      }
      grouped[monthYear]!.add(log);
    }

    return Map.fromEntries(grouped.entries.toList()
      ..sort((a, b) => DateFormat('MMMM yyyy', 'id_ID')
          .parse(b.key)
          .compareTo(DateFormat('MMMM yyyy', 'id_ID').parse(a.key))));
  }

  void setGroupedAttendance(Map<String, List<LogAbsensi>> data) {
    _groupedAttendance = data;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
