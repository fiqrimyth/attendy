import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controller untuk setiap field
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _pekerjaanController = TextEditingController();
  final TextEditingController _jenisKelaminController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telpController = TextEditingController();
  final TextEditingController _ktpController = TextEditingController();
  final TextEditingController _nipController = TextEditingController();

  // Tambahkan variable untuk image dan file
  File? _profileImage;
  List<File> _supportingFiles = [];

  // Method untuk handle image picker
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Ambil Foto'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) {
                    setState(() {
                      _profileImage = File(image.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() {
                      _profileImage = File(image.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Method untuk handle file picker
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        // Check file size (max 1MB)
        int fileSize = await file.length();
        if (fileSize > 1 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ukuran file maksimal 1MB')),
          );
          return;
        }

        // Check max files (6 files)
        if (_supportingFiles.length >= 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Maksimal 6 file yang dapat diunggah')),
          );
          return;
        }

        setState(() {
          _supportingFiles.add(file);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Method untuk save data
  Future<void> _saveData() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      // ignore: unused_local_variable
      Map<String, dynamic> data = {
        'nama': _namaController.text,
        'pekerjaan': _pekerjaanController.text,
        'jenis_kelamin': _jenisKelaminController.text,
        'tanggal_lahir': _tanggalLahirController.text,
        'alamat': _alamatController.text,
        'email': _emailController.text,
        'telp': _telpController.text,
        'ktp': _ktpController.text,
        'nip': _nipController.text,
      };

      // TODO: Implementasi pengiriman data ke backend

      // Remove loading indicator
      Navigator.pop(context);

      // Close screen
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan')),
      );
    } catch (e) {
      // Remove loading indicator
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Isi dengan data dummy
    _namaController.text = 'Jhon Doe';
    _pekerjaanController.text = 'Cook Helper';
    _jenisKelaminController.text = 'Laki - Laki';
    _tanggalLahirController.text = '05 Desember 1994';
    _alamatController.text =
        'Jl. Baskerville No.21, RT001/RW007, Kotabaru, Karawang';
    _emailController.text = 'jhon.doe@sejiwa.com';
    _telpController.text = '081278785656';
    _ktpController.text = '3215251902950001';
    _nipController.text = '199502192021021145';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: _saveData, // Update this to save data
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Image Section dengan ukuran yang lebih kecil
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/profile.jpg')
                            as ImageProvider,
                    child: InkWell(
                      onTap: _pickImage,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16, // Ukuran icon dikecilkan
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Form Fields dengan padding yang disesuaikan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildTextField('Nama', _namaController),
                  _buildTextField('Pekerjaan', _pekerjaanController),
                  _buildTextField('Jenis Kelamin', _jenisKelaminController),
                  _buildTextField(
                    'Tanggal Lahir',
                    _tanggalLahirController,
                    suffix: Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                  _buildTextField('Alamat Domisili', _alamatController,
                      maxLines: 2),
                  _buildTextField('Email', _emailController),
                  _buildTextField('Nomor Telepon', _telpController),
                  _buildTextField('Nomor KTP', _ktpController),
                  _buildTextField('Nomor Induk Pegawai', _nipController),
                  const SizedBox(height: 20),
                  _buildFilePendukungSection(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    Widget? suffix,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            suffixIcon: suffix,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFilePendukungSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'File Pendukung ',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            Text(
              '(Maks. 1MB, 6 File)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ..._supportingFiles
                .map((file) => _buildFileItem(file.path.split('/').last)),
            if (_supportingFiles.length < 6) _buildAddFileButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildFileItem(String filename) {
    return Container(
      width: (MediaQuery.of(context).size.width - 44) / 2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.insert_drive_file, color: Colors.black54),
          const SizedBox(height: 8),
          Text(
            filename,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAddFileButton() {
    return InkWell(
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'File Pendukung',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _pekerjaanController.dispose();
    _jenisKelaminController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    _emailController.dispose();
    _telpController.dispose();
    _ktpController.dispose();
    _nipController.dispose();
    super.dispose();
  }
}
