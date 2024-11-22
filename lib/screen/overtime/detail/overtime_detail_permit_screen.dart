import 'package:attendy/model/overtime_permit.dart';
import 'package:flutter/material.dart';

class OvertimeDetailPermitScreen extends StatelessWidget {
  final OvertimePermit permit;

  const OvertimeDetailPermitScreen({
    super.key,
    required this.permit,
  });

  Widget _buildDetailItem(String label, String value, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            if (icon != null)
              Icon(
                icon,
                color: Colors.black54,
                size: 20,
              ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(height: 1),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Lembur',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Detail Form',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // Tampilan untuk overtime berdasarkan jam
              if (permit.isHourly) ...[
                _buildDetailItem(
                  'Tanggal Lembur',
                  permit.date,
                  icon: Icons.calendar_today_outlined,
                ),
                _buildDetailItem(
                  'Dari Jam',
                  permit.startTime,
                  icon: Icons.access_time,
                ),
                _buildDetailItem(
                  'Sampai Jam',
                  permit.endTime,
                  icon: Icons.access_time,
                ),
              ]
              // Tampilan untuk overtime berdasarkan hari
              else ...[
                _buildDetailItem(
                  'Dari Tanggal',
                  permit.startDate,
                  icon: Icons.calendar_today_outlined,
                ),
                _buildDetailItem(
                  'Sampai Tanggal',
                  permit.endDate,
                  icon: Icons.calendar_today_outlined,
                ),
                _buildDetailItem(
                  'Jenis Kompensasi',
                  permit.compensationType,
                ),
              ],

              _buildDetailItem(
                'Alasan Lembur',
                permit.reason.isEmpty ? 'tidak ada alasan' : permit.reason,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
