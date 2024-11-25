import 'package:attendy/model/approval.dart';
import 'package:attendy/screen/approval/detail/detail_approval_screen.dart';
// import 'package:attendy/service/approval_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({super.key});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  // final ApprovalService _approvalService = ApprovalService();

  int _selectedTabIndex = 0;
  bool _isLoading = true;
  String? _error;
  // List<Approval> _histories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      // final response = await _approvalService.getPermitHistory();
      setState(() {
        // _histories = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // Dummy data untuk approval
  final List<Approval> _approvals = Approval.getDummyApprovals();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Approval', style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(color: Colors.black),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text('Error: $_error'))
                : Column(
                    children: [
                      _buildTabBar(),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _buildApprovalList(),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildTabItem('All', 0),
        _buildTabItem('Cuti', 1),
        _buildTabItem('Izin Absen', 2),
        _buildTabItem('Lembur', 3),
      ],
    );
  }

  Widget _buildTabItem(String label, int index) {
    final isSelected = _selectedTabIndex == index;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      selectedColor: Colors.blue,
      backgroundColor: Colors.transparent,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: isSelected ? BorderSide(color: Colors.white) : BorderSide.none,
      ),
    );
  }

  Widget _buildApprovalList() {
    // Filter data berdasarkan tab yang dipilih
    final filteredApprovals = _approvals.where((approval) {
      if (_selectedTabIndex == 0) return true; // All
      if (_selectedTabIndex == 1) return approval.category == 'leave';
      if (_selectedTabIndex == 2) return approval.category == 'absence';
      if (_selectedTabIndex == 3) return approval.category == 'overtime';
      return false;
    }).toList();

    return ListView.builder(
      itemCount: filteredApprovals.length,
      itemBuilder: (context, index) {
        final approval = filteredApprovals[index];
        return GestureDetector(
          onTap: () {
            // Navigasi ke halaman detail approval
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailApprovalScreen(approval: approval.toMap()),
              ),
            );
          },
          child: _buildApprovalCard(approval),
        );
      },
    );
  }

  Widget _buildApprovalCard(Approval approval) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (Izin Absen dan tanggal)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4E5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    approval.type,
                    style: const TextStyle(
                      color: Color(0xFFFF9F00),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  approval.date,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Garis pemisah
            const Divider(),
            const SizedBox(height: 10),
            // Profile section
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage:
                      AssetImage('assets/profile.jpg'), // Gambar profil
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      approval.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      approval.role,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Garis pemisah
            const Divider(),
            const SizedBox(height: 10),
            // Details section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icon/linear/folder-2.svg', // Ganti dengan path SVG
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      approval.type,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icon/linear/calendar.svg', // Ganti dengan path SVG
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      approval.date,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icon/linear/chat-2.svg', // Ganti dengan path SVG
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        approval.description,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icon/linear/note-2.svg', // Ganti dengan path SVG
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      approval.attachment ?? '',
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Garis pemisah
            const Divider(),
            const SizedBox(height: 10),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40, // Sesuaikan tinggi tombol
                    child: ElevatedButton(
                      onPressed: () {
                        // Reject action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Warna latar belakang
                        side: BorderSide(color: Colors.red), // Border merah
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Reject',
                        style: TextStyle(color: Colors.red), // Warna teks merah
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Jarak antara tombol
                Expanded(
                  child: SizedBox(
                    height: 40, // Sesuaikan tinggi tombol
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
          ],
        ),
      ),
    );
  }
}
