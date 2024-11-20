import 'package:attendy/screen/attendance/attendance_screen.dart';
import 'package:attendy/screen/camera/camera_screen.dart';
import 'package:attendy/screen/dashboard/dashboard_screen.dart';
import 'package:attendy/screen/on_board/on_boarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('id_ID', null).then((_) => runApp(const MyApp()));
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
