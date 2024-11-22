import 'package:attendy/provider/attendance_provider.dart';
import 'package:attendy/screen/attendance/attendance_screen.dart';
import 'package:attendy/screen/camera/camera_screen.dart';
import 'package:attendy/screen/dashboard/dashboard_screen.dart';
import 'package:attendy/screen/onboarding/on_boarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() {
  initializeDateFormatting('id_ID', null).then((_) => runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AttendanceProvider()),
            // ... provider lainnya ...
          ],
          child: const MyApp(),
        ),
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2962FF),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(const Color(0xFF2962FF)),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            textStyle: WidgetStateProperty.all(
              const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        useMaterial3: false,
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnBoardingScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/camera': (context) => const CameraScreen(
              type: '',
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/attendance') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => AttendanceScreen(
              imagePath: args['imagePath'] as String? ?? '',
              type: args['type'] as String,
            ),
          );
        }
        return null;
      },
    );
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final String status; // 'read' atau 'unread'

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.status,
  });

  static List<NotificationModel> getDummyData() {
    return [
      NotificationModel(
        id: '1',
        title: 'Absensi Berhasil',
        message: 'Anda telah berhasil melakukan absensi masuk hari ini',
        date: DateTime.now(),
        status: 'unread',
      ),
      NotificationModel(
        id: '2',
        title: 'Pengingat Absensi',
        message: 'Jangan lupa untuk melakukan absensi pulang hari ini',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        status: 'read',
      ),
      // Tambahkan dummy data lainnya sesuai kebutuhan
    ];
  }
}
