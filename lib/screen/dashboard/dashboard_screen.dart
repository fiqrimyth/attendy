import 'dart:async';
import 'package:attendy/model/menu_item_data.dart';
import 'package:attendy/screen/absence/absence_permit_screen.dart';
import 'package:attendy/screen/approval/approval_screen.dart';
import 'package:attendy/screen/dashboard/history/history_screen.dart';
import 'package:attendy/screen/leave/leave_permit_screen.dart';
import 'package:attendy/screen/overtime/overtime_permit_screen.dart';
import 'package:attendy/screen/profile/edit_profile_screen.dart';
import 'package:attendy/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../model/log_absensi.dart';
import '../attendance/attendance_screen.dart';
import '../camera/camera_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:attendy/screen/notification/notification_screen.dart';
import 'package:attendy/service/datetime_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _timeString = '';
  String _dateString = '';
  Timer? _timer;
  final _dateTimeService = DateTimeService.instance;

  // Tambah state untuk user info
  String _userName = '';
  String _userJob = '';
  String _userPhoto = '';

  // Tambah state untuk shift info
  String _shiftName = '';
  String _shiftTime = '';

  // Tambahkan state untuk mengontrol button
  bool isClockIn = false;
  String? clockInTime;
  // bool _isLoading = false;

  // Tambahkan variable untuk lokasi
  bool _isLocationFound = false;
  Position? _currentPosition;

  // Tambahkan list untuk menyimpan log absensi
  List<LogAbsensi> _logAbsensi = [];

  // Tambahkan variable untuk role
  // String _userRole = ''; // Bisa diisi: 'staff', 'supervisor', 'manager', dll

  // Tambahkan variable untuk jumlah notifikasi approval
  int _approvalCount = 3; // Nanti bisa diupdate dari API

  @override
  void initState() {
    super.initState();
    _getTime();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());

    // Load user data
    _loadUserData();
    _getCurrentLocation();
    _loadAttendanceState();
    _getApprovalCount();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dateTimeService.dispose();
    super.dispose();
  }

  void _getTime() async {
    try {
      final DateTime now = await _dateTimeService.getServerDateTime();
      debugPrint('=== DateTime Debug ===');
      debugPrint('Raw server datetime: ${now.toIso8601String()}');

      final String formattedTime = DateFormat('HH:mm:ss').format(now);
      final String formattedDate =
          DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);
      debugPrint('Formatted time: $formattedTime');
      debugPrint('Formatted date: $formattedDate');
      debugPrint('===================');

      if (mounted) {
        setState(() {
          _timeString = formattedTime;
          _dateString = formattedDate;
        });
      }
    } catch (e) {
      debugPrint('Error getting server time: $e');
      debugPrint('Stack trace: ${e is Error ? e.stackTrace : ''}');
      // Fallback ke waktu device jika gagal
      final DateTime now = DateTime.now();
      debugPrint('Fallback to device time: ${now.toIso8601String()}');

      if (mounted) {
        setState(() {
          _timeString = DateFormat('HH:mm:ss').format(now);
          _dateString = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);
        });
      }
    }
  }

  // Fungsi untuk load user data
  Future<void> _loadUserData() async {
    try {
      final user = await AuthService.instance.getUser();
      if (user != null) {
        setState(() {
          _userName = user.fullName;
          _userJob = user.jobType;
          _userPhoto = user.photo;

          // Perbaiki bagian ini
          _shiftName = user
              .shiftSchedule.shifts[user.shiftSchedule.assignedShift - 1].name;
          _shiftTime =
              '${user.shiftSchedule.currentShift.startTime} - ${user.shiftSchedule.currentShift.endTime}';
        });
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  // Function untuk handle clock in/out
  Future<void> _handleClockIn() async {
    if (_isLocationFound) {
      try {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CameraScreen(type: 'in'),
          ),
        );

        if (result != null && result is String && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AttendanceScreen(
                type: 'in',
                imagePath: result,
                latitude: _currentPosition?.latitude,
                longitude: _currentPosition?.longitude,
              ),
            ),
          );
        }
      } catch (e) {
        debugPrint('Error navigating to camera: $e');
      }
      return;
    }

    // Tampilkan snackbar terlebih dahulu
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sedang mendapatkan lokasi...')),
    );

    // Tunggu sebentar agar snackbar terlihat
    await Future.delayed(const Duration(seconds: 1));

    // Mulai proses request permission dan get lokasi
    bool locationObtained = await _requestAndGetLocation();
    if (!locationObtained) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Gagal mendapatkan lokasi. Silakan coba lagi.')),
      );
      return;
    }

    // Jika berhasil dapat lokasi, lanjut ke kamera
    if (_isLocationFound && mounted) {
      _handleClockIn(); // Panggil ulang untuk masuk ke flow kamera
    }
  }

  Future<void> _handleClockOut() async {
    if (_isLocationFound) {
      try {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CameraScreen(type: 'out'),
          ),
        );

        if (result != null && result is String && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AttendanceScreen(
                type: 'out',
                imagePath: result,
                latitude: _currentPosition?.latitude,
                longitude: _currentPosition?.longitude,
              ),
            ),
          );
        }
      } catch (e) {
        debugPrint('Error navigating to camera: $e');
      }
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sedang mendapatkan lokasi...')),
    );

    await Future.delayed(const Duration(seconds: 1));

    bool locationObtained = await _requestAndGetLocation();
    if (!locationObtained) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Gagal mendapatkan lokasi. Silakan coba lagi.')),
      );
      return;
    }

    if (_isLocationFound && mounted) {
      _handleClockOut();
    }
  }

  Future<void> _loadAttendanceState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isClockIn = prefs.getBool('isClockIn') ?? false;
      clockInTime = prefs.getString('clockInTime');
    });
  }

  // Tambahkan fungsi untuk mendapatkan lokasi
  Future<void> _getCurrentLocation() async {
    try {
      // Cek dan minta permission lokasi terlebih dahulu
      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint('Initial permission status: $permission');

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        debugPrint('Permission after request: $permission');

        if (permission == LocationPermission.denied) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Izin lokasi diperlukan untuk absensi')),
          );
          return;
        }
      }

      // Cek jika layanan lokasi aktif
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mohon aktifkan layanan lokasi')),
        );
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mohon izinkan akses lokasi di pengaturan perangkat'),
          ),
        );
        return;
      }

      // Jika sudah dapat izin, ambil posisi
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0, // Atur sesuai kebutuhan
        ),
      );

      if (mounted) {
        setState(() {
          _currentPosition = position;
          _isLocationFound = true;
        });
        debugPrint(
            'Location obtained: ${position.latitude}, ${position.longitude}');
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mendapatkan lokasi')),
      );
    }
  }

  // Modifikasi fungsi _requestAndGetLocation
  Future<bool> _requestAndGetLocation() async {
    try {
      // Cek service lokasi aktif
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Mohon aktifkan layanan lokasi di pengaturan perangkat'),
            duration: Duration(seconds: 3),
          ),
        );
        return false;
      }

      // Request permission dengan lebih eksplisit
      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint('Permission status: $permission');

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        debugPrint('Permission after request: $permission');

        // Jika masih denied setelah request
        if (permission == LocationPermission.denied) {
          if (!mounted) return false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Izin lokasi diperlukan untuk absensi'),
              duration: Duration(seconds: 3),
            ),
          );
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mohon izinkan akses lokasi di pengaturan perangkat'),
            duration: Duration(seconds: 3),
          ),
        );
        return false;
      }

      // Tambahkan loading indicator
      if (!mounted) return false;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        // Tambahkan timeout untuk mendapatkan posisi
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 0, // Atur sesuai kebutuhan
          ),
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('Gagal mendapatkan lokasi, timeout');
          },
        );

        // Tutup loading indicator
        if (mounted) Navigator.pop(context);

        if (mounted) {
          setState(() {
            _currentPosition = position;
            _isLocationFound = true;
          });
          debugPrint(
              'Location obtained: ${position.latitude}, ${position.longitude}');
        }
        return true;
      } catch (e) {
        // Tutup loading indicator jika error
        if (mounted) Navigator.pop(context);
        rethrow;
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      if (!mounted) return false;

      // Tampilkan pesan error yang lebih spesifik
      String errorMessage = 'Gagal mendapatkan lokasi';
      if (e is TimeoutException) {
        errorMessage = 'Timeout mendapatkan lokasi. Silakan coba lagi.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 3),
        ),
      );
      return false;
    }
  }

  // Fungsi untuk membangun item log absensi
  Widget _buildLogItem(LogAbsensi log) {
    Color statusColor;
    switch (log.status.toLowerCase()) {
      case 'approved':
        statusColor = Colors.green;
        break;
      case 'rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.access_time,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.type,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  DateFormat('dd MMM yyyy, HH:mm', 'id_ID')
                      .format(log.timestamp),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              log.status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk mendapatkan role user
  // Future<void> _getUserRole() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _userRole = prefs.getString('userRole') ?? 'staff';
  //   });
  // }

  List<MenuItemData> _getAllMenus() {
    return [
      MenuItemData(
        icon: 'assets/icon/linear/stetoscop_blue.svg',
        label: 'Izin Absen',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AbsencePermitScreen()),
        ),
      ),
      MenuItemData(
        icon: 'assets/icon/linear/calendar_blue.svg',
        label: 'Ajukan Cuti',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LeavePermitScreen()),
        ),
      ),
      MenuItemData(
        icon: 'assets/icon/linear/history_blue.svg',
        label: 'Ajukan Lembur',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OvertimePermitScreen()),
        ),
      ),
      MenuItemData(
        icon: 'assets/icon/linear/calendar_2_blue.svg',
        label: 'Kalender',
        onTap: () {}, // Implementasi kalender
      ),
      MenuItemData(
        icon: 'assets/icon/linear/tick-circle_blue.svg',
        label: 'Approval',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ApprovalScreen()),
        ), // Implementasi approval screen
        badge: _approvalCount, // Tambahkan badge count
      ),
    ];
  }

  // Fungsi untuk mendapatkan menu berdasarkan role
  // List<MenuItemData> _getMenuByRole() {
  //   if (_userRole == 'staff') {
  //     return [
  //       MenuItemData(
  //         icon: 'assets/icon/linear/stetoscop_blue.svg',
  //         label: 'Izin Absen',
  //         onTap: () => Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => const AbsencePermitScreen()),
  //         ),
  //       ),
  //       MenuItemData(
  //         icon: 'assets/icon/linear/calendar_blue.svg',
  //         label: 'Ajukan Cuti',
  //         onTap: () => Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => const LeavePermitScreen()),
  //         ),
  //       ),
  //       MenuItemData(
  //         icon: 'assets/icon/linear/history_blue.svg',
  //         label: 'Ajukan Lembur',
  //         onTap: () => Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => const OvertimePermitScreen()),
  //         ),
  //       ),
  //       MenuItemData(
  //         icon: 'assets/icon/linear/calendar_2_blue.svg',
  //         label: 'Kalender',
  //         onTap: () {}, // Implementasi kalender
  //       ),
  //     ];
  //   } else {
  //     // Menu untuk supervisor/manager
  //     return [
  //       MenuItemData(
  //         icon: 'assets/icon/linear/clock.svg',
  //         label: 'Approval',
  //         onTap: () {}, // Implementasi approval screen
  //       ),
  //       MenuItemData(
  //         icon: 'assets/icon/linear/document.svg',
  //         label: 'Report',
  //         onTap: () {}, // Implementasi report screen
  //       ),
  //     ];
  //   }
  // }

  // Fungsi untuk mendapatkan jumlah approval yang pending
  Future<void> _getApprovalCount() async {
    // Nanti bisa diganti dengan call API
    setState(() {
      _approvalCount = 3; // Contoh data statis
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header dengan profil
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfileScreen(),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: _userPhoto.isNotEmpty
                                  ? NetworkImage(_userPhoto) as ImageProvider
                                  : const AssetImage('assets/profile.jpg'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                _userJob,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icon/linear/notification.svg',
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Update bagian jam dan tanggal
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            _timeString,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _dateString,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),

                          // Shift Info
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 20),
                          Text(
                            _shiftName,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _shiftTime,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),

                          // Clock In/Out Buttons
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: isClockIn ? null : _handleClockIn,
                                  icon: const Icon(Icons.access_time),
                                  label: const Text('Clock In'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isClockIn ? Colors.grey : Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    disabledBackgroundColor: Colors.grey,
                                    disabledForegroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed:
                                      !isClockIn ? null : _handleClockOut,
                                  icon: const Icon(Icons.access_time),
                                  label: const Text('Clock Out'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        !isClockIn ? Colors.grey : Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    disabledBackgroundColor: Colors.grey,
                                    disabledForegroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Foto selfie diperlukan untuk Clock In/Clock Out',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Menu
                  const SizedBox(height: 32),
                  const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    children: _getAllMenus()
                        .map((menu) => _buildMenuButton(
                              SvgPicture.asset(
                                menu.icon,
                                width: 24,
                                height: 24,
                              ),
                              menu.label,
                              onTap: menu.onTap,
                              badge: menu.badge,
                            ))
                        .toList(),
                  ),

                  // Log Absensi
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Log Absensi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HistoryScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Lihat Log',
                          style: TextStyle(
                            color: Color(0xFF2962FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Ganti bagian empty state dengan ini
                  if (_logAbsensi.isEmpty) ...[
                    Center(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/image/no-data2.svg',
                            height: 200,
                          ),
                          const Text('Belum ada data saat ini'),
                        ],
                      ),
                    ),
                  ] else ...[
                    Column(
                      children:
                          _logAbsensi.map((log) => _buildLogItem(log)).toList(),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Update widget _buildMenuButton
  Widget _buildMenuButton(Widget icon, String label,
      {VoidCallback? onTap, int? badge}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              icon,
              if (badge != null && badge > 0)
                Positioned(
                  right: -8,
                  top: -8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      badge > 99 ? '99+' : badge.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Update fungsi refresh data
  Future<void> _refreshData() async {
    await _loadUserData();
    await _loadAttendanceState();
    await _getCurrentLocation();
    await _getApprovalCount();
  }
}
