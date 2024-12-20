import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../model/permit_history.dart';
import '../../../service/permit_service.dart';

class AbsenceDetailPermitScreen extends StatefulWidget {
  final PermitHistory permit;
  final String permitId;

  const AbsenceDetailPermitScreen({
    required this.permit,
    required this.permitId,
    super.key,
  });

  @override
  State<AbsenceDetailPermitScreen> createState() =>
      _AbsenceDetailPermitScreenState();
}

class _AbsenceDetailPermitScreenState extends State<AbsenceDetailPermitScreen> {
  final PermitService _permitService = PermitService();
  bool _isLoading = true;
  String? _error;
  PermitHistory? _permit;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      setState(() => _isLoading = true);
      final response = await _permitService.getPermitDetail(widget.permitId);
      setState(() {
        _permit = response.data.first;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
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
          'Detail Izin',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
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
                        _buildDetailItem(
                            'Kategori Izin', _permit?.leaveCategory ?? '-'),
                        _buildDivider(),
                        _buildDetailItem(
                          'Tanggal Izin',
                          _permit?.createdAt.toString() ?? '-',
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
                            'Delegasikan ke', _permit?.delegatedTo ?? '-'),
                        _buildDivider(),
                        _buildDetailItem('Unggah File',
                            _permit?.attachmentFile?.fileName ?? '-'),
                        _buildDivider(),
                        _buildDetailItem(
                            'Alasan Izin', _permit?.leaveReason ?? ''),
                        if (_permit?.attachmentFile != null) ...[
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
                              // Implementasi preview/download file
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
                                    _permit?.attachmentFile?.fileName ?? '',
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
