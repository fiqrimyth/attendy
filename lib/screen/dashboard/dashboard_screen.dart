import 'dart:async';
import 'package:attendy/screen/absence/absence_permit_screen.dart';
import 'package:attendy/screen/dashboard/history/history_screen.dart';
import 'package:attendy/screen/leave/leave_permit_screen.dart';
import 'package:attendy/screen/overtime/overtime_permit_screen.dart';
import 'package:attendy/screen/profile/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../model/log_absensi.dart';
import '../attendance/attendance_screen.dart';
import '../camera/camera_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:attendy/screen/notification/notification_screen.dart';

// import 'package:intl/date_symbol_data_local.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _timeString = '';
  String _dateString = '';
  Timer? _timer;

  // Tambah state untuk shift info
  String _shiftName = '';
  String _shiftTime = '';
  // bool _isLoadingShift = true;

  // Tambahkan state untuk mengontrol button
  bool isClockIn = false;
  String? clockInTime;
  // bool _isLoading = false;

  // Tambahkan variable untuk lokasi
  bool _isLocationFound = false;
  Position? _currentPosition;

  // Model untuk data attendance (bisa dipindah ke file terpisah)
  /*
  class AttendanceData {
    final DateTime timestamp;
    final String location;
    final String type; // 'in' atau 'out'

    AttendanceData({
      required this.timestamp,
      required this.location,
      required this.type,
    });

    Map<String, dynamic> toJson() => {
      'timestamp': timestamp.toIso8601String(),
      'location': location,
      'type': type,
    };
  }
  */

  // Tambahkan list untuk menyimpan log absensi
  List<LogAbsensi> _logAbsensi = [];

  @override
  void initState() {
    super.initState();
    _getTime();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());

    // Sementara gunakan data dummy
    _getShiftInfo();
    _loadAttendanceState();

    // Tambahkan ini
    _getCurrentLocation();

    // Load log absensi
    _loadLogAbsensi();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = DateFormat('HH:mm:ss').format(now);
    final String formattedDate =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);

    if (mounted) {
      setState(() {
        _timeString = formattedTime;
        _dateString = formattedDate;
      });
    }
  }

  // Fungsi untuk mendapatkan info shift dari server
  // void _getShiftInfo() async {
  //   try {
  //     setState(() => _isLoadingShift = true);
  //
  //     final response = await apiService.getEmployeeShift();
  //     if (response.success) {
  //       setState(() {
  //         _shiftName = response.shiftName; // contoh: "Shift 1"
  //         _shiftTime = response.shiftTime; // contoh: "07:30 - 14:30"
  //       });
  //     } else {
  //       // Handle error - tampilkan pesan error atau set default value
  //       _setDefaultShiftInfo();
  //     }
  //   } catch (e) {
  //     debugPrint('Error getting shift info: $e');
  //     _setDefaultShiftInfo();
  //   } finally {
  //     setState(() => _isLoadingShift = false);
  //   }
  // }

  // Sementara gunakan data dummy
  void _getShiftInfo() {
    setState(() {
      _shiftName = 'Shift 1';
      _shiftTime = '07:30 - 14:30';
      // _isLoadingShift = false;
    });
  }

  // void _setDefaultShiftInfo() {
  //   setState(() {
  //     _shiftName = 'Tidak ada shift';
  //     _shiftTime = '-';
  //   });
  // }

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
        desiredAccuracy: LocationAccuracy.high,
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
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high,
          // ignore: deprecated_member_use
          timeLimit: const Duration(seconds: 5),
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

  // Fungsi untuk memuat log absensi
  void _loadLogAbsensi() {
    setState(() {
      _logAbsensi = LogAbsensi.getDummyData();
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                                builder: (context) => const EditProfileScreen(),
                              ),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage('assets/profile.jpg'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Jhon Doe',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Cook Helper',
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
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
                                onPressed: !isClockIn ? null : _handleClockOut,
                                icon: const Icon(Icons.access_time),
                                label: const Text('Clock Out'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      !isClockIn ? Colors.grey : Colors.blue,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildMenuButton(
                        SvgPicture.asset(
                          'assets/icon/linear/stetoscop_blue.svg',
                          width: 24,
                          height: 24,
                        ),
                        'Izin Absen'),
                    _buildMenuButton(
                        SvgPicture.asset(
                          'assets/icon/linear/calendar_blue.svg', // sesuaikan dengan path icon calendar Anda
                          width: 24,
                          height: 24,
                        ),
                        'Ajukan Cuti'),
                    _buildMenuButton(
                        SvgPicture.asset(
                          'assets/icon/linear/history_blue.svg', // sesuaikan dengan path icon timer Anda
                          width: 24,
                          height: 24,
                        ),
                        'Ajukan Lembur'),
                    _buildMenuButton(
                        SvgPicture.asset(
                          'assets/icon/linear/calendar_2_blue.svg', // sesuaikan dengan path icon kalender Anda
                          width: 24,
                          height: 24,
                        ),
                        'Kalender'),
                  ],
                ),

                // Log Absensi
                const SizedBox(height: 32),
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
    );
  }

  Widget _buildMenuButton(Widget icon, String label) {
    return InkWell(
      onTap: () {
        switch (label) {
          case 'Izin Absen':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const AbsencePermitScreen(), // Buat screen ini
              ),
            );
            break;
          case 'Ajukan Cuti':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const LeavePermitScreen(), // Buat screen ini
              ),
            );
            break;
          case 'Ajukan Lembur':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const OvertimePermitScreen(), // Buat screen ini
              ),
            );
            break;
          case 'Kalender':
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const KalenderScreen(), // Buat screen ini
            //   ),
            // );
            break;
        }
      },
      child: Column(
        children: [
          icon,
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
}
