import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailApprovalScreen extends StatelessWidget {
  final Map<String, dynamic> approval;

  const DetailApprovalScreen({super.key, required this.approval});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Detail Approval',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(color: Colors.black),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildDetailContent(),
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  Widget _buildDetailContent() {
    String category = approval['category'] ?? 'Tidak ada kategori';

    switch (category) {
      case 'leave':
        return _buildCutiDetail();
      case 'absence':
        return _buildIzinDetail();
      case 'overtime':
        return _buildLemburDetail();
      case 'Tugas Khusus':
        return _buildTugasKhususDetail();
      default:
        return const Center(child: Text('Kategori tidak dikenal'));
    }
  }

  Widget _buildCutiDetail() {
    return _buildDetailColumn([
      _buildDetailRow('Nama', approval['name']),
      _buildDetailRow('Pekerjaan', approval['role']),
      _buildDetailRow('Kategori Cuti', approval['description']),
      _buildDetailRow('Dari Tanggal', approval['date']),
      _buildDetailRow('Sampai Tanggal', approval['endDate']),
      _buildDetailRow('Delegasikan ke', approval['delegate']),
      _buildDetailRow(
          'Unggah File', approval['attachment'] ?? 'tidak ada file'),
      _buildDetailRow('Alasan Cuti', approval['reason'] ?? 'tidak ada alasan'),
      _buildAttachmentRow(approval['attachment']),
    ]);
  }

  Widget _buildIzinDetail() {
    return _buildDetailColumn([
      _buildDetailRow('Nama', approval['name']),
      _buildDetailRow('Pekerjaan', approval['role']),
      _buildDetailRow('Kategori Izin', approval['description']),
      _buildDetailRow('Tanggal Izin', approval['date']),
      _buildDetailRow('Delegasikan ke', approval['delegate']),
      _buildDetailRow(
          'Unggah File', approval['attachment'] ?? 'tidak ada file'),
      _buildDetailRow('Alasan Izin', approval['reason'] ?? 'tidak ada alasan'),
      _buildAttachmentRow(approval['attachment']),
    ]);
  }

  Widget _buildLemburDetail() {
    return _buildDetailColumn([
      _buildDetailRow('Nama', approval['name']),
      _buildDetailRow('Pekerjaan', approval['role']),
      _buildDetailRow('Jenis Kompensasi', approval['description']),
      _buildDetailRow('Dari Tanggal', approval['startDate']),
      _buildDetailRow('Sampai Tanggal', approval['endDate']),
      _buildDetailRow(
          'Alasan Lembur', approval['reason'] ?? 'tidak ada alasan'),
    ]);
  }

  Widget _buildTugasKhususDetail() {
    return _buildDetailColumn([
      _buildDetailRow('Nama', approval['name']),
      _buildDetailRow('Pekerjaan', approval['role']),
      _buildDetailRow('Deskripsi Tugas', approval['description']),
      _buildDetailRow('Tanggal Tugas', approval['date']),
      _buildDetailRow('Delegasikan ke', approval['delegate']),
      _buildDetailRow(
          'Unggah File', approval['attachment'] ?? 'tidak ada file'),
      _buildDetailRow('Alasan Tugas', approval['reason'] ?? 'tidak ada alasan'),
    ]);
  }

  Widget _buildDetailColumn(List<Widget> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Detail Form',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...details,
      ],
    );
  }

  Widget _buildDetailRow(String label, dynamic value, {Widget? suffix}) {
    String displayValue =
        (value is String && value.isNotEmpty) ? value : 'tidak ada informasi';

    // Mengubah icon menjadi SVG
    String? iconPath;
    if (label.toLowerCase().contains('tanggal')) {
      iconPath = 'assets/icon/linear/calendar.svg';
    } else if (label.toLowerCase().contains('jam')) {
      iconPath = 'assets/icon/linear/clock.svg';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(
                displayValue,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            if (iconPath != null)
              SvgPicture.asset(
                iconPath,
                width: 20,
                height: 20,
                color: Colors.grey[600],
              ),
            if (suffix != null) suffix,
          ],
        ),
        Divider(),
        SizedBox()
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  // Reject action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Reject',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  // Approve action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Approve'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentRow(String? attachment) {
    if (attachment == null ||
        !(attachment.endsWith('.pdf') ||
            attachment.endsWith('.jpg') ||
            attachment.endsWith('.png'))) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'File Attachment',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Icon(
                attachment.endsWith('.pdf')
                    ? Icons.picture_as_pdf
                    : Icons.image,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  attachment,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
