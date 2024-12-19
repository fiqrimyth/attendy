import 'package:attendy/service/auth_service.dart';
import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  String _userName = '';
  String _userJob = '';
  String _userPhoto = '';
  String _shiftName = '';
  String _shiftTime = '';

  // Getter untuk mengakses data
  String get userName => _userName;
  String get userJob => _userJob;
  String get userPhoto => _userPhoto;
  String get shiftName => _shiftName;
  String get shiftTime => _shiftTime;

  Future<void> loadUserData() async {
    try {
      final user = await AuthService.instance.getUser();
      debugPrint('Loaded user data: ${user?.toJson()}');

      if (user != null) {
        _userName = user.fullName;
        _userJob = user.jobType;
        _userPhoto = user.photo;

        if (user.shiftSchedule.shifts.isNotEmpty) {
          _shiftName = user
              .shiftSchedule.shifts[user.shiftSchedule.assignedShift - 1].name;
          _shiftTime =
              '${user.shiftSchedule.currentShift.startTime} - ${user.shiftSchedule.currentShift.endTime}';
        } else {
          _shiftName = 'Shift tidak tersedia';
          _shiftTime = '-';
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
      _resetData();
    }
  }

  void _resetData() {
    _userName = 'Error loading data';
    _userJob = '-';
    _userPhoto = '';
    _shiftName = '-';
    _shiftTime = '-';
    notifyListeners();
  }
}
