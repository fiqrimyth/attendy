import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../model/permit_history.dart';

class AbsenceDetailPermitScreen extends StatelessWidget {
  final PermitHistory permit;

  const AbsenceDetailPermitScreen({
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
          'Detail Izin',
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
              _buildDetailItem('Kategori Izin', permit.type),
              _buildDivider(),
              _buildDetailItem(
                'Tanggal Izin',
                permit.date,
                suffix: SvgPicture.asset(
                  'assets/icon/linear/calendar.svg',
                  colorFilter: const ColorFilter.mode(
                    Colors.black45,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              _buildDivider(),
              _buildDetailItem('Delegasikan ke', permit.delegate ?? '-'),
              _buildDivider(),
              _buildDetailItem('Unggah File', permit.fileName ?? '-'),
              _buildDivider(),
              _buildDetailItem('Alasan Izin', permit.description),
              if (permit.fileUrl != null) ...[
                const SizedBox(height: 32),
                const Text(
                  'File Attachment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    // Handle preview/download file
                  },
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F7FB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icon/linear/document.svg',
                          width: 40,
                          height: 40,
                          colorFilter: const ColorFilter.mode(
                            Colors.black45,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          permit.fileName ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
