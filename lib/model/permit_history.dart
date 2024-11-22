enum PermitType {
  leave('Cuti'),
  absence('Izin Absen'),
  overtime('Lembur');

  final String label;
  const PermitType(this.label);
}

class PermitHistory {
  final String date;
  final String type;
  final String description;
  final PermitType permitType;
  final String? fileName;
  final String? fileUrl;
  final String? delegate;

  const PermitHistory({
    required this.date,
    required this.type,
    required this.description,
    required this.permitType,
    this.fileName,
    this.fileUrl,
    this.delegate,
  });

  // Konversi dari JSON ke Object
  factory PermitHistory.fromJson(Map<String, dynamic> json) {
    return PermitHistory(
      date: json['date'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      permitType: PermitType.values.firstWhere(
        (type) => type.name == json['permitType'],
        orElse: () => PermitType.absence,
      ),
      fileName: json['fileName'] as String?,
      fileUrl: json['fileUrl'] as String?,
      delegate: json['delegate'] as String?,
    );
  }

  // Konversi dari Object ke JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'type': type,
      'description': description,
      'permitType': permitType.name,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'delegate': delegate,
    };
  }

  // Copy with method untuk membuat salinan objek dengan nilai yang diubah
  PermitHistory copyWith({
    String? date,
    String? type,
    String? description,
    PermitType? permitType,
    String? fileName,
    String? fileUrl,
    String? delegate,
  }) {
    return PermitHistory(
      date: date ?? this.date,
      type: type ?? this.type,
      description: description ?? this.description,
      permitType: permitType ?? this.permitType,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      delegate: delegate ?? this.delegate,
    );
  }

  @override
  String toString() {
    return 'PermitHistory(date: $date, type: $type, description: $description, '
        'permitType: ${permitType.name}, fileName: $fileName, fileUrl: $fileUrl, '
        'delegate: $delegate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PermitHistory &&
        other.date == date &&
        other.type == type &&
        other.description == description &&
        other.permitType == permitType &&
        other.fileName == fileName &&
        other.fileUrl == fileUrl &&
        other.delegate == delegate;
  }

  @override
  int get hashCode {
    return Object.hash(
      date,
      type,
      description,
      permitType,
      fileName,
      fileUrl,
      delegate,
    );
  }

  static List<PermitHistory> getDummyData({PermitType? filterType}) {
    final allData = [
      PermitHistory(
        date: '22 April 2024',
        type: 'Cuti Tahunan',
        description: '2 hari',
        permitType: PermitType.leave,
      ),
      PermitHistory(
        date: '22 April 2024',
        type: 'Sakit',
        description: 'Demam Tinggi',
        permitType: PermitType.absence,
      ),
      PermitHistory(
        date: '23 April 2024',
        type: 'Lembur',
        description: 'Project Deadline',
        permitType: PermitType.overtime,
      ),
    ];

    if (filterType != null) {
      return allData.where((item) => item.permitType == filterType).toList();
    }
    return allData;
  }
}
