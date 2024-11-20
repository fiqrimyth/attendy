import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ApplicationLeavePermitScreen extends StatefulWidget {
  const ApplicationLeavePermitScreen({super.key});

  @override
  State<ApplicationLeavePermitScreen> createState() =>
      _ApplicationLeavePermitScreenState();
}

class _ApplicationLeavePermitScreenState
    extends State<ApplicationLeavePermitScreen> {
  final TextEditingController _reasonController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedCategory;
  // String? _selectedDelegate;
  File? _selectedFile;
  final _formKey = GlobalKey<FormState>();

  bool get isFormValid =>
      _selectedCategory != null &&
      _startDate != null &&
      _endDate != null &&
      _reasonController.text.isNotEmpty;

  String _formatDisplayDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  void showCategoryPicker() {
    // Implementasi pemilih kategori
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Implementasi pengiriman form
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        allowedExtensions: null,
      );

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
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
          'Pengajuan Cuti',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kategori Cuti',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F7FB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller:
                              TextEditingController(text: _selectedCategory),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            hintText: 'Pilih Kategori',
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            suffixIcon: SvgPicture.asset(
                              'assets/icon/linear/chevron-down.svg',
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          readOnly: true,
                          onTap: showCategoryPicker,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Dari Tanggal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F7FB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: TextEditingController(
                            text: _startDate != null
                                ? _formatDisplayDate(_startDate!)
                                : '',
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            hintText: 'Pilih Tanggal',
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            suffixIcon: SvgPicture.asset(
                              'assets/icon/linear/calendar.svg',
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          readOnly: true,
                          onTap: () =>
                              _selectDate(true), // true untuk startDate
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Sampai Tanggal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F7FB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: TextEditingController(
                            text: _endDate != null
                                ? _formatDisplayDate(_endDate!)
                                : '',
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            hintText: 'Pilih Tanggal',
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            suffixIcon: SvgPicture.asset(
                              'assets/icon/linear/calendar.svg',
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          readOnly: true,
                          onTap: () =>
                              _selectDate(false), // false untuk endDate
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Dokumen Pendukung',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildFileField(
                        onTap: _pickFile,
                        fileName: _selectedFile?.path.split('/').last,
                      ),
                      // ... sisa field sama seperti ApplicationAbsencePermitScreen
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
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
        ],
      ),
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
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
        if (isStartDate) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2B2B2B),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required void Function(String?)? onChanged,
    required List<DropdownMenuItem<String>> items,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Text(hint, style: TextStyle(color: Colors.grey[400])),
        isExpanded: true,
        underline: const SizedBox(),
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDateField({
    required String hint,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value != null ? DateFormat('dd MMMM yyyy').format(value) : hint,
              style: TextStyle(
                color: value != null ? Colors.black : Colors.grey[400],
              ),
            ),
            const Icon(Icons.calendar_today_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildFileField({
    required VoidCallback onTap,
    String? fileName,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              fileName ?? 'Upload File',
              style: TextStyle(
                color: fileName != null ? Colors.black : Colors.grey[400],
              ),
            ),
            const Icon(Icons.upload_outlined),
          ],
        ),
      ),
    );
  }
}
