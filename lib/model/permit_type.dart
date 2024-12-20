class PermitType {
  final String id;
  final String name;
  final int daysAllowed;
  final String description;
  final bool isActive;

  PermitType({
    required this.id,
    required this.name,
    required this.daysAllowed,
    required this.description,
    required this.isActive,
  });

  factory PermitType.fromJson(Map<String, dynamic> json) {
    return PermitType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      daysAllowed: json['daysAllowed'] ?? 0,
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }

  @override
  String toString() =>
      'PermitType(description: $description, daysAllowed: $daysAllowed)';
}
