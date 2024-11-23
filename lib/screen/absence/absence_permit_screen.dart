import 'package:attendy/model/permit_history.dart';
import 'package:attendy/screen/absence/absence_request/application_absence_permit_screen.dart';
import 'package:attendy/screen/absence/detail/absence_detail_permit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:attendy/service/permit_service.dart';

class AbsencePermitScreen extends StatefulWidget {
  const AbsencePermitScreen({super.key});

  @override
  State<AbsencePermitScreen> createState() => _AbsencePermitScreenState();
}

class _AbsencePermitScreenState extends State<AbsencePermitScreen> {
  final PermitService _permitService = PermitService();
  bool _isLoading = true;
  String? _error;
  List<PermitHistory> _histories = [];
  Map<String, dynamic> _summary = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      final response = await _permitService.getPermitHistory();
      setState(() {
        _histories = response.data;
        _summary = response.summary;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildPermitCard(String title, String days) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF3FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '$days hari',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPermitHistory(List<PermitHistory> histories) {
    if (histories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/image/no-data2.svg',
              height: 200,
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum ada data saat ini',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: histories.length,
      separatorBuilder: (context, index) => const Divider(
        color: Colors.black12,
        height: 1,
        thickness: 0.5,
        indent: 0,
        endIndent: 0,
      ),
      itemBuilder: (context, index) {
        final history = histories[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          title: Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  history.date,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      history.type,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      history.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.black45,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AbsenceDetailPermitScreen(
                  permit: history,
                  permitId: history.id,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Izin Absen',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          _buildPermitCard(
                              'Jatah Cuti', '${_summary['jatahCuti'] ?? 0}'),
                          _buildPermitCard(
                              'Absen', '${_summary['absen'] ?? 0}'),
                          _buildPermitCard(
                              'Alpha', '${_summary['alpha'] ?? 0}'),
                          _buildPermitCard('Izin', '${_summary['izin'] ?? 0}'),
                          _buildPermitCard('Cuti', '${_summary['cuti'] ?? 0}'),
                          _buildPermitCard(
                              'Lembur', '${_summary['lembur'] ?? 0}'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Riwayat Izin',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_error != null || _histories.isEmpty)
                        _buildPermitHistory([])
                      else
                        _buildPermitHistory(_histories),
                    ],
                  ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ApplicationAbsencePermitScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Buat Izin'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}
