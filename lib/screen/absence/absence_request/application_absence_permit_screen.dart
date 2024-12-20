import 'package:attendy/service/permit_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

class ApplicationAbsencePermitScreen extends StatefulWidget {
  const ApplicationAbsencePermitScreen({super.key});

  @override
  State<ApplicationAbsencePermitScreen> createState() =>
      _ApplicationAbsencePermitScreenState();
}

class _ApplicationAbsencePermitScreenState
    extends State<ApplicationAbsencePermitScreen> {
  // MARK: - Properties & Controllers
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _picker = ImagePicker();
  final PermitService _permitService = PermitService();
  bool _isLoading = false;

  // Form state
  String? selectedCategoryId;
  String? selectedCategory;
  String? selectedDate;
  String? selectedDelegate;
  String? selectedFile;
  String? fileBase64;

  // Data Lists
  final List<Map<String, String>> categories = [
    {'id': '1', 'name': 'Sakit', 'type': ''},
    {'id': '2', 'name': 'Khitanan Anak', 'type': '(Special Leave)'},
    {'id': '3', 'name': 'Baptis Anak', 'type': '(Special Leave)'},
    {'id': '4', 'name': 'Keluarga Meninggal', 'type': '(Special Leave)'},
    {
      'id': '5',
      'name': 'Keluarga dalam Satu Rumah Meninggal',
      'type': '(Special Leave)'
    },
    {
      'id': '6',
      'name':
          'Keperluan dengan alasan sangat penting atas persetujuan pimpinan unit',
      'type': ''
    },
  ];

  final List<String> delegations = [
    'Faizah Haryanti',
    'Hasna Laksmiwati',
    'Kiandra Pudjiastuti',
    'Galuh Putra',
    'Wardi Saefullah',
    'Intan Yulianti',
  ];

  // MARK: - Computed Properties
  bool get isFormValid {
    return selectedCategoryId != null &&
        selectedDate != null &&
        selectedDelegate != null &&
        _formKey.currentState?.validate() == true;
  }

  // MARK: - Date Formatting Methods
  String _formatDisplayDate(DateTime date) {
    final List<String> months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatServerDate(DateTime date) {
    final List<String> months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    String day = date.day.toString().padLeft(2, '0');
    return '$day${months[date.month - 1]}${date.year}';
  }

  // MARK: - File Handling Methods
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

  // MARK: - Picker Methods
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
                    'Kategori Izin',
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
                            selectedCategory = category['name'];
                          });
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

  // MARK: - Dialog Methods
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
                      Navigator.of(context)
                        ..pop()
                        ..pop();
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

  // MARK: - Form Methods
  Future<void> _submitPermit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      final data = {
        'type': 'absence',
        'category_id': selectedCategoryId,
        'date': selectedDate != null
            ? _formatServerDate(DateTime.parse(selectedDate!))
            : '',
        'delegate_id': selectedDelegate,
        'description': _reasonController.text,
        'attachment': fileBase64,
        'filename': selectedFile,
      };

      final response = await _permitService.createPermit(data);

      if (mounted) {
        if (response.success == true) {
          _showSuccessDialog();
        } else {
          String errorMessage = 'Terjadi kesalahan';

          if (response.errors.isNotEmpty) {
            // Mengambil semua pesan error dan menggabungkannya
            errorMessage = response.errors.values
                .expand((messages) => messages is List ? messages : [messages])
                .join('\n');
          } else if (response.message.isNotEmpty) {
            errorMessage = response.message;
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // MARK: - Build Methods
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
          'Pengajuan Izin',
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
                        'Kategori Izin',
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
                              TextEditingController(text: selectedCategory),
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
                        'Tanggal Izin',
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
                            text: selectedDate != null
                                ? _formatDisplayDate(
                                    DateTime.parse(selectedDate!))
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
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedDate != null
                                  ? DateTime.parse(selectedDate!)
                                  : DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
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
                                        foregroundColor:
                                            Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    dialogTheme: const DialogTheme(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(28)),
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
                                      dayBackgroundColor:
                                          WidgetStateProperty.resolveWith(
                                              (states) {
                                        if (states
                                            .contains(WidgetState.selected)) {
                                          return Theme.of(context).primaryColor;
                                        }
                                        return null;
                                      }),
                                      todayBackgroundColor:
                                          WidgetStateProperty.resolveWith(
                                              (states) {
                                        if (states
                                            .contains(WidgetState.selected)) {
                                          return Theme.of(context).primaryColor;
                                        }
                                        return Colors.transparent;
                                      }),
                                      todayBorder: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 1,
                                      ),
                                      dayForegroundColor:
                                          WidgetStateProperty.resolveWith(
                                              (states) {
                                        if (states
                                            .contains(WidgetState.selected)) {
                                          return Colors.white;
                                        }
                                        return Colors.black;
                                      }),
                                      yearForegroundColor:
                                          WidgetStateProperty.resolveWith(
                                              (states) {
                                        if (states
                                            .contains(WidgetState.selected)) {
                                          return Colors.white;
                                        }
                                        return Colors.black;
                                      }),
                                      dayOverlayColor:
                                          WidgetStateProperty.resolveWith(
                                              (states) {
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
                                selectedDate = date.toIso8601String();
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Delegasikan ke',
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
                              TextEditingController(text: selectedDelegate),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                            hintText: 'Pilih Delegasi',
                            hintStyle:
                                const TextStyle(color: Color(0xFF757575)),
                            suffixIcon: SvgPicture.asset(
                              'assets/icon/linear/chevron-down.svg',
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          readOnly: true,
                          onTap: showDelegationPicker,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Text(
                            'Unggah File ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '(Opsional maks. 2MB)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F7FB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: TextEditingController(text: selectedFile),
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
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Text(
                            'Alasan Izin ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '(Opsional)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F7FB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: _reasonController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                            hintText: 'Ketik alasan disini',
                            hintStyle: TextStyle(color: Color(0xFF757575)),
                          ),
                          maxLines: 4,
                        ),
                      ),
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
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: isFormValid ? _submitPermit : null,
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
                          color: isFormValid
                              ? Colors.white
                              : const Color(0xFFBDBDBD),
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

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}
