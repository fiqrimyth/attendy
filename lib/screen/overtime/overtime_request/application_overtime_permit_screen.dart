import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ApplicationOvertimePermitScreen extends StatefulWidget {
  const ApplicationOvertimePermitScreen({super.key});

  @override
  State<ApplicationOvertimePermitScreen> createState() =>
      _ApplicationOvertimePermitScreenState();
}

class _ApplicationOvertimePermitScreenState
    extends State<ApplicationOvertimePermitScreen> {
  final _formKey = GlobalKey<FormState>();

  String _formatDisplayDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID');
  }

  @override
  void dispose() {
    // Bersihkan controller untuk menghindari memory leak
    _reasonController.dispose();
    super.dispose();
  }

  // Tambahkan state variables
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final TextEditingController _reasonController = TextEditingController();

  bool _isHourlyView = true; // untuk tracking view aktif
  DateTime? _startDate;
  DateTime? _endDate;
  String?
      _selectedCompensationType; // Ubah dari String ke String? dan hapus default value

  bool get isFormValid {
    if (_isHourlyView) {
      return _selectedDate != null && _startTime != null && _endTime != null;
    } else {
      return _startDate != null &&
          _endDate != null &&
          _selectedCompensationType != null; // Tambahkan validasi kompensasi
    }
  }

  // Method submit form
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Proses pengiriman data ke server
        // ...

        // Tampilkan dialog sukses
        _showSuccessDialog();
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
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
          'Pengajuan Lembur',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tab Selection
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isHourlyView = true),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: _isHourlyView
                                        ? Colors.blue
                                        : const Color(0xFFE0E0E0),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: Text(
                                    'Jam',
                                    style: TextStyle(
                                      color: _isHourlyView
                                          ? Colors.blue
                                          : const Color(0xFF757575),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isHourlyView = false),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: !_isHourlyView
                                        ? Colors.blue
                                        : const Color(0xFFE0E0E0),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: Text(
                                    'Harian',
                                    style: TextStyle(
                                      color: !_isHourlyView
                                          ? Colors.blue
                                          : const Color(0xFF757575),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Conditional content based on view
                    if (_isHourlyView) ...[
                      // Tanggal Lembur
                      _buildFormField(
                        label: 'Tanggal Lembur',
                        child: _buildInputField(
                          hintText: 'Pilih Tanggal',
                          value: _selectedDate != null
                              ? _formatDisplayDate(_selectedDate!)
                              : null,
                          onTap: () => _selectDate(context),
                          suffixIcon: 'calendar',
                        ),
                      ),
                      // Jam dalam satu baris
                      Row(
                        children: [
                          Expanded(
                            child: _buildFormField(
                              label: 'Dari Jam',
                              child: _buildInputField(
                                hintText: 'Pilih Jam',
                                value: _startTime?.format(context),
                                onTap: () => _selectTime(context, true),
                                suffixIcon: 'clock',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildFormField(
                              label: 'Sampai Jam',
                              child: _buildInputField(
                                hintText: 'Pilih Jam',
                                value: _endTime?.format(context),
                                onTap: () => _selectTime(context, false),
                                suffixIcon: 'clock',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      // Daily view content
                      _buildFormField(
                        label: 'Dari Tanggal',
                        child: _buildInputField(
                          hintText: 'Pilih Tanggal',
                          value: _startDate != null
                              ? _formatDisplayDate(_startDate!)
                              : null,
                          onTap: () => _selectStartDate(context),
                          suffixIcon: 'calendar',
                        ),
                      ),
                      _buildFormField(
                        label: 'Sampai Tanggal',
                        child: _buildInputField(
                          hintText: 'Pilih Tanggal',
                          value: _endDate != null
                              ? _formatDisplayDate(_endDate!)
                              : null,
                          onTap: () => _selectEndDate(context),
                          suffixIcon: 'calendar',
                        ),
                      ),

                      // Jenis Kompensasi
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Jenis Kompensasi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildRadioOption('Paid Overtime'),
                              const SizedBox(width: 24),
                              _buildRadioOption('Leaved Overtime'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Alasan Lembur (sama untuk kedua view)
                    _buildFormField(
                      label: 'Alasan Lembur (Opsional)',
                      child: _buildReasonField(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isFormValid ? _submitForm : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isFormValid
                  ? const Color(0xFF2B67F6)
                  : const Color(0xFFF8F7FB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
              disabledBackgroundColor: const Color(0xFFF8F7FB),
            ),
            child: Text(
              'Kirim Approval',
              style: TextStyle(
                color: isFormValid ? Colors.white : const Color(0xFFBDBDBD),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    String? subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
            ),
          ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInputField({
    required String hintText,
    String? value,
    required VoidCallback onTap,
    required String suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF757575)),
          suffixIcon: SvgPicture.asset(
            'assets/icon/linear/$suffixIcon.svg',
            fit: BoxFit.scaleDown,
          ),
        ),
        readOnly: true,
        onTap: onTap,
      ),
    );
  }

  // Tambahkan helper methods
  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
            dialogTheme: const DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(28)),
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              headerBackgroundColor: Colors.white,
              dayStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              weekdayStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              headerHeadlineStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              headerForegroundColor: Colors.black,
              surfaceTintColor: Colors.white,
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).primaryColor;
                }
                return null;
              }),
              todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).primaryColor;
                }
                return Colors.transparent;
              }),
              todayBorder: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return Colors.black;
              }),
              yearForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return Colors.black;
              }),
              dayOverlayColor: WidgetStateProperty.resolveWith((states) {
                return Colors.transparent;
              }),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? _startTime ?? TimeOfDay.now()
          : _endTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  // Tambahkan method untuk memilih tanggal
  Future<void> _selectStartDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
            dialogTheme: const DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(28)),
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              headerBackgroundColor: Colors.white,
              dayStyle: const TextStyle(fontSize: 14, color: Colors.black),
              weekdayStyle: const TextStyle(fontSize: 14, color: Colors.black),
              headerHeadlineStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              headerForegroundColor: Colors.black,
              surfaceTintColor: Colors.white,
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).primaryColor;
                }
                return null;
              }),
              todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).primaryColor;
                }
                return Colors.transparent;
              }),
              todayBorder: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _startDate = date;
        if (_endDate != null && date.isAfter(_endDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal mulai terlebih dahulu')),
      );
      return;
    }

    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!,
      firstDate: _startDate!,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
            dialogTheme: const DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(28)),
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              headerBackgroundColor: Colors.white,
              dayStyle: const TextStyle(fontSize: 14, color: Colors.black),
              weekdayStyle: const TextStyle(fontSize: 14, color: Colors.black),
              headerHeadlineStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              headerForegroundColor: Colors.black,
              surfaceTintColor: Colors.white,
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).primaryColor;
                }
                return null;
              }),
              todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).primaryColor;
                }
                return Colors.transparent;
              }),
              todayBorder: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _endDate = date;
      });
    }
  }

  Widget _buildRadioOption(String value) {
    return GestureDetector(
      onTap: () => setState(() => _selectedCompensationType = value),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _selectedCompensationType == value
                    ? Colors.blue
                    : const Color(0xFF757575),
                width: 2,
              ),
            ),
            child: _selectedCompensationType == value
                ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B67F6).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Color(0xFF2B67F6),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Request Terkirim',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Silahkan tunggu approval di acc oleh atasan anda',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      // Pop dialog dan screen pengajuan cuti
                      Navigator.of(context)
                        ..pop() // Pop dialog
                        ..pop(); // Pop screen pengajuan cuti
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B67F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Kembali ke Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReasonField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: _reasonController,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          hintText: 'Masukkan alasan lembur',
          hintStyle: TextStyle(color: Color(0xFF757575)),
        ),
        maxLines: 3,
      ),
    );
  }
}
