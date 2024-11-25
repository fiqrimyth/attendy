class Approval {
  final String id;
  final String name;
  final String role;
  final String date;
  final String type;
  final String description;
  final String? fileName;
  final String? fileUrl;
  final String? delegate;
  final String? status;
  final String? category;
  final String? attachment;

  const Approval({
    required this.id,
    required this.name,
    required this.role,
    required this.date,
    required this.type,
    required this.description,
    this.fileName,
    this.fileUrl,
    this.delegate,
    required this.status,
    this.category,
    this.attachment,
  });

  factory Approval.fromJson(Map<String, dynamic> json) {
    return Approval(
      id: json['id'],
      name: json['name'] as String,
      role: json['role'] as String,
      date: json['date'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      fileName: json['fileName'] as String?,
      fileUrl: json['fileUrl'] as String?,
      delegate: json['delegate'] as String?,
      status: json['status'] as String,
      category: json['category'] as String?,
      attachment: json['attachment'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'date': date,
      'type': type,
      'description': description,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'delegate': delegate,
      'status': status,
      'category': category,
      'attachment': attachment,
    };
  }

  Approval copyWith({
    String? id,
    String? name,
    String? role,
    String? date,
    String? type,
    String? description,
    String? fileName,
    String? fileUrl,
    String? delegate,
    String? status,
    String? category,
    String? attachment,
  }) {
    return Approval(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      date: date ?? this.date,
      type: type ?? this.type,
      description: description ?? this.description,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      delegate: delegate ?? this.delegate,
      status: status ?? this.status,
      category: category ?? this.category,
      attachment: attachment ?? this.attachment,
    );
  }

  @override
  String toString() {
    return 'Approval(id: $id, name: $name, role: $role, date: $date, type: $type, description: $description, '
        'fileName: $fileName, fileUrl: $fileUrl, '
        'delegate: $delegate, status: $status, category: $category, attachment: $attachment)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Approval &&
        other.id == id &&
        other.name == name &&
        other.role == role &&
        other.date == date &&
        other.type == type &&
        other.description == description &&
        other.fileName == fileName &&
        other.fileUrl == fileUrl &&
        other.delegate == delegate &&
        other.status == status &&
        other.category == category &&
        other.attachment == attachment;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      role,
      date,
      type,
      description,
      fileName,
      fileUrl,
      delegate,
      status,
      category,
      attachment,
    );
  }

  static List<Approval> getDummyApprovals() {
    return [
      Approval(
        id: '1',
        name: 'John Doe',
        role: 'Manager',
        date: '29 April 2024',
        type: 'Cuti',
        description: 'Cuti Tahunan',
        status: 'Pending',
        category: 'leave',
        attachment: 'surat keterangan dokter.pdf',
      ),
      Approval(
        id: '2',
        name: 'Jane Smith',
        role: 'Supervisor',
        date: '22 April 2024',
        type: 'Izin Absen',
        description: 'Demam tinggi disertai batuk',
        status: 'Pending',
        category: 'absence',
        attachment: 'surat keterangan dokter.pdf',
      ),
      Approval(
        id: '3',
        name: 'Bob Johnson',
        role: 'Employee',
        date: '22 April 2024',
        type: 'Lembur',
        description: 'Bantu pengepakan produk',
        status: 'Approved',
        category: 'overtime',
        attachment: 'No Attachment',
      ),
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'type': type,
      'date': date,
      'name': name,
      'role': role,
      'category': category,
      'description': description,
      'attachment': attachment,
    };
  }
}
