import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

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
  String? selectedDelegate;
  File? _selectedFile;
  final _formKey = GlobalKey<FormState>();
  String? selectedCategoryId;
  final List<Map<String, String>> categories = [
    {'id': '1', 'name': 'Cuti Tahunan', 'type': ''},
    {'id': '2', 'name': 'Cuti Besar', 'type': ''},
    {'id': '3', 'name': 'Cuti Haid', 'type': ''},
    {'id': '4', 'name': 'Cuti Sakit Berat', 'type': ''},
    {'id': '5', 'name': 'Cuti Menikah', 'type': '(Special Leave)'},
    {'id': '6', 'name': 'Cuti Menikahkan Anak', 'type': '(Special Leave)'},
    {'id': '7', 'name': 'Cuti Melahirkan Anak', 'type': '(Special Leave)'},
    {
      'id': '8',
      'name': 'Cuti Istri Melahirkan Anak atau Keguguran',
      'type': '(Special Leave)'
    },
  ];
  final List<String> delegations = [
    'John Doe',
    'Jane Smith',
    'Mike Johnson',
    // Tambahkan daftar delegasi lainnya
  ];

  final ImagePicker _picker = ImagePicker();
  String? selectedFile;
  String? fileBase64;

  bool get isFormValid =>
      _selectedCategory != null &&
      _startDate != null &&
      _endDate != null &&
      selectedDelegate != null;

  String _formatDisplayDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  void showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFEEEEEE),
                        width: 1,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Kategori Cuti',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = category['id'] == selectedCategoryId;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedCategoryId = category['id'];
                          });

                          this.setState(() {
                            _selectedCategory = category['type']!.isEmpty
                                ? category['name']
                                : '${category['name']} ${category['type']}';
                          });

                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFEEEEEE),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Wrap(
                                  spacing: 4,
                                  children: [
                                    Text(
                                      category['name']!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isSelected
                                            ? Theme.of(context).primaryColor
                                            : Colors.black,
                                      ),
                                    ),
                                    if (category['type']!.isNotEmpty)
                                      Text(
                                        category['type']!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.check_circle_rounded,
                                    color: Theme.of(context).primaryColor,
                                    size: 24,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showDelegationPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFEEEEEE),
                        width: 1,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Pilih Delegasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: delegations.length,
                    itemBuilder: (context, index) {
                      final delegation = delegations[index];
                      final isSelected = delegation == selectedDelegate;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedDelegate = delegation;
                          });

                          this.setState(() {
                            selectedDelegate = delegation;
                          });

                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFEEEEEE),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  delegation,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.check_circle_rounded,
                                    color: Theme.of(context).primaryColor,
                                    size: 24,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

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
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      setState(() {
        selectedFile = null;
        fileBase64 = null;
      });

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
        allowCompression: true,
      );

      if (result != null && result.files.single.path != null) {
        await _processFile(
            File(result.files.single.path!), result.files.single.name);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih file: ${e.toString()}')),
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
          'Pengajuan Cuti',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormField(
                      label: 'Kategori Cuti',
                      child: _buildInputField(
                        hintText: 'Pilih Kategori',
                        value: _selectedCategory,
                        onTap: showCategoryPicker,
                        suffixIcon: 'chevron-down',
                      ),
                    ),
                    _buildFormField(
                      label: 'Dari Tanggal',
                      child: _buildInputField(
                        hintText: 'Pilih Tanggal',
                        value: _startDate != null
                            ? _formatDisplayDate(_startDate!)
                            : null,
                        onTap: () => _selectDate(true),
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
                        onTap: () => _selectDate(false),
                        suffixIcon: 'calendar',
                      ),
                    ),
                    _buildFormField(
                      label: 'Delegasikan ke',
                      child: _buildInputField(
                        hintText: 'Pilih Delegasi',
                        value: selectedDelegate,
                        onTap: showDelegationPicker,
                        suffixIcon: 'chevron-down',
                      ),
                    ),
                    _buildFormField(
                      label: 'Unggah File',
                      subtitle: '(Opsional maks. 2 MB)',
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F7FB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: TextEditingController(
                              text: _selectedFile?.path.split('/').last),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            hintText: 'Upload File',
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            suffixIcon: SvgPicture.asset(
                              'assets/icon/linear/export.svg',
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          readOnly: true,
                          onTap: _showFilePickerOptions,
                        ),
                      ),
                    ),
                    _buildFormField(
                      label: 'Alasan Cuti',
                      subtitle: '(Opsional)',
                      child: TextFormField(
                        controller: _reasonController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF8F7FB),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Ketik alasan disini',
                          hintStyle: const TextStyle(color: Color(0xFF757575)),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        maxLines: 4,
                      ),
                    ),
                  ],
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
                      color:
                          isFormValid ? Colors.white : const Color(0xFFBDBDBD),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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

  void _showFilePickerOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Upload File',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Upload your attachment, you can take a photo directly or choose from your smartphone gallery',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOptionButton(
                      icon: Icons.camera_alt_outlined,
                      label: 'Kamera',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    _buildOptionButton(
                      icon: Icons.photo_outlined,
                      label: 'Galeri',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                    _buildOptionButton(
                      icon: Icons.file_present_outlined,
                      label: 'File',
                      onTap: () {
                        Navigator.pop(context);
                        _pickFile();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        selectedFile = null;
        fileBase64 = null;
      });

      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();

        if (status.isGranted) {
          final XFile? pickedFile = await _picker.pickImage(
            source: source,
            maxWidth: 1800,
            maxHeight: 1800,
          );

          if (pickedFile != null) {
            await _processFile(
                File(pickedFile.path), pickedFile.path.split('/').last);
          }
        } else if (status.isPermanentlyDenied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text('Silakan aktifkan permission kamera di pengaturan')),
            );
            openAppSettings();
          }
        }
      } else if (source == ImageSource.gallery) {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: 1800,
          maxHeight: 1800,
        );

        if (pickedFile != null) {
          await _processFile(
              File(pickedFile.path), pickedFile.path.split('/').last);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _processFile(File file, String fileName) async {
    try {
      final int fileSize = await file.length();
      final double fileSizeInMB = fileSize / (1024 * 1024);

      if (fileSizeInMB > 2) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Ukuran file tidak boleh lebih dari 2MB')),
          );
        }
        return;
      }

      final bytes = await file.readAsBytes();
      if (mounted) {
        setState(() {
          fileBase64 = base64Encode(bytes);
          selectedFile = fileName;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memproses file: ${e.toString()}')),
        );
      }
    }
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
}
