import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Ilustrasi utama
                      SvgPicture.asset(
                        'assets/image/image_attendance.svg',
                        height: constraints.maxHeight * 0.35,
                      ),
                      const SizedBox(height: 28),
                      // Judul
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Quick Attend & Hassle-free',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Subtitle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Aplikasi sederhana untuk mencatat kehadiran\nkaryawan dengan cepat dan efisien.\nTidak butuh waktu lama.',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.black,
                                    height: 1.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Simpan status bahwa onboarding sudah dilihat
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('showOnboarding', false);

                        // Cek token dan expired time
                        final token = prefs.getString('token');
                        final tokenExpiredTime =
                            prefs.getString('tokenExpiredTime');

                        if (context.mounted) {
                          if (token != null && tokenExpiredTime != null) {
                            final expiredDateTime =
                                DateTime.parse(tokenExpiredTime);
                            final now = DateTime.now();

                            if (now.isBefore(expiredDateTime)) {
                              // Token masih valid, langsung ke dashboard
                              Navigator.pushReplacementNamed(
                                  context, '/dashboard');
                            } else {
                              // Token expired, hapus data login dan ke halaman login
                              await prefs.remove('token');
                              await prefs.remove('tokenExpiredTime');
                              Navigator.pushReplacementNamed(context, '/login');
                            }
                          } else {
                            // Belum login, arahkan ke halaman login
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F80ED),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
