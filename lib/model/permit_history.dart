enum PermitType {
  leave('Cuti'),
  absence('Izin Absen'),
  overtime('Lembur');

  final String label;
  const PermitType(this.label);
}

class PermitHistory {
  final String id;
  final String date;
  final String type;
  final String description;
  final PermitType permitType;
  final String? fileName;
  final String? fileUrl;
  final String? delegate;
  final String? status;
  final String? jatahCuti;
  final String? absen;
  final String? alpha;
  final String? sakit;
  final String? izin;
  final String? cuti;
  final String? lembur;

  const PermitHistory({
    required this.id,
    required this.date,
    required this.type,
    required this.description,
    required this.permitType,
    this.fileName,
    this.fileUrl,
    this.delegate,
    this.status,
    this.jatahCuti,
    this.absen,
    this.alpha,
    this.sakit,
    this.izin,
    this.cuti,
    this.lembur,
  });

  // Konversi dari JSON ke Object
  factory PermitHistory.fromJson(Map<String, dynamic> json) {
    return PermitHistory(
      id: json['id'],
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
      status: json['status'] as String?,
      jatahCuti: json['jatahCuti'] as String?,
      absen: json['absen'] as String?,
      alpha: json['alpha'] as String?,
      sakit: json['sakit'] as String?,
      izin: json['izin'] as String?,
      cuti: json['cuti'] as String?,
      lembur: json['lembur'] as String?,
    );
  }

  // Konversi dari Object ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'type': type,
      'description': description,
      'permitType': permitType.name,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'delegate': delegate,
      'status': status,
      'jatahCuti': jatahCuti,
      'absen': absen,
      'alpha': alpha,
      'sakit': sakit,
      'izin': izin,
      'cuti': cuti,
      'lembur': lembur,
    };
  }

  // Copy with method untuk membuat salinan objek dengan nilai yang diubah
  PermitHistory copyWith({
    String? id,
    String? date,
    String? type,
    String? description,
    PermitType? permitType,
    String? fileName,
    String? fileUrl,
    String? delegate,
    String? status,
    String? jatahCuti,
    String? absen,
    String? alpha,
    String? sakit,
    String? izin,
    String? cuti,
    String? lembur,
  }) {
    return PermitHistory(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      description: description ?? this.description,
      permitType: permitType ?? this.permitType,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      delegate: delegate ?? this.delegate,
      status: status ?? this.status,
      jatahCuti: jatahCuti ?? this.jatahCuti,
      absen: absen ?? this.absen,
      alpha: alpha ?? this.alpha,
      sakit: sakit ?? this.sakit,
      izin: izin ?? this.izin,
      cuti: cuti ?? this.cuti,
      lembur: lembur ?? this.lembur,
    );
  }

  @override
  String toString() {
    return 'PermitHistory(id: $id, date: $date, type: $type, description: $description, '
        'permitType: ${permitType.name}, fileName: $fileName, fileUrl: $fileUrl, '
        'delegate: $delegate, status: $status, jatahCuti: $jatahCuti, '
        'absen: $absen, alpha: $alpha, sakit: $sakit, izin: $izin, '
        'cuti: $cuti, lembur: $lembur)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PermitHistory &&
        other.id == id &&
        other.date == date &&
        other.type == type &&
        other.description == description &&
        other.permitType == permitType &&
        other.fileName == fileName &&
        other.fileUrl == fileUrl &&
        other.delegate == delegate &&
        other.status == status &&
        other.jatahCuti == jatahCuti &&
        other.absen == absen &&
        other.alpha == alpha &&
        other.sakit == sakit &&
        other.izin == izin &&
        other.cuti == cuti &&
        other.lembur == lembur;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      date,
      type,
      description,
      permitType,
      fileName,
      fileUrl,
      delegate,
      status,
      jatahCuti,
      absen,
      alpha,
      sakit,
      izin,
      cuti,
      lembur,
    );
  }

  static List<PermitHistory> getDummyData({PermitType? filterType}) {
    final allData = [
      PermitHistory(
        id: '1',
        date: '22 April 2024',
        type: 'Cuti Tahunan',
        description: '2 hari',
        permitType: PermitType.leave,
      ),
      PermitHistory(
        id: '2',
        date: '22 April 2024',
        type: 'Sakit',
        description: 'Demam Tinggi',
        permitType: PermitType.absence,
      ),
      PermitHistory(
        id: '3',
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
