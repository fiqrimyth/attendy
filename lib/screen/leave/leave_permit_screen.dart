import 'package:attendy/model/permit_history.dart';
import 'package:attendy/screen/leave/leave_request/application_leave_permit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeavePermitScreen extends StatelessWidget {
  const LeavePermitScreen({super.key});

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
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => DetailPermitScreen(permit: history),
            //   ),
            // );
          },
        );
      },
    );
  }

  Widget _buildContent(List<PermitHistory> histories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildPermitCard('Jatah Cuti', '10'),
            _buildPermitCard('Absen', '2'),
            _buildPermitCard('Alpha', '2'),
            _buildPermitCard('Izin', '2'),
            _buildPermitCard('Cuti', '2'),
            _buildPermitCard('Lembur', '6'),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Riwayat Cuti',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        histories.isEmpty
            ? Center(
                child: Column(
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
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            : _buildPermitHistory(histories),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<PermitHistory> histories = [
      PermitHistory(
        date: '22 April 2024',
        type: 'Cuti Tahunan',
        description: '2 hari',
        permitType: PermitType.leave,
      ),
    ];

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
          'Ajukan Cuti',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildContent(histories),
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ApplicationLeavePermitScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Ajukan Cuti'),
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
