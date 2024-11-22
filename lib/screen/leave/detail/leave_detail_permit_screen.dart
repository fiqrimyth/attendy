import 'package:attendy/model/permit_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeaveDetailPermitScreen extends StatelessWidget {
  final PermitHistory permit;

  const LeaveDetailPermitScreen({
    super.key,
    required this.permit,
  });

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
          'Detail Cuti',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
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
              _buildDetailItem('Kategori Cuti', 'Cuti Tahunan'),
              _buildDivider(),
              _buildDetailItem(
                'Dari Tanggal',
                '29 April 2024',
                suffix: SvgPicture.asset(
                  'assets/icon/linear/calendar.svg',
                  colorFilter: const ColorFilter.mode(
                    Colors.black45,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              _buildDivider(),
              _buildDetailItem(
                'Sampai Tanggal',
                '30 April 2024',
                suffix: SvgPicture.asset(
                  'assets/icon/linear/calendar.svg',
                  colorFilter: const ColorFilter.mode(
                    Colors.black45,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              _buildDivider(),
              _buildDetailItem('Delegasikan ke', 'Faizah Haryanti'),
              _buildDivider(),
              _buildDetailItem('Unggah File', 'tidak ada file'),
              _buildDivider(),
              _buildDetailItem('Alasan Cuti', 'tidak ada alasan'),
              const SizedBox(height: 32),
              const Text(
                'File Attachment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {Widget? suffix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            if (suffix != null) suffix,
          ],
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        color: Color(0xFFEEEEEE),
        height: 1,
      ),
    );
  }
}
