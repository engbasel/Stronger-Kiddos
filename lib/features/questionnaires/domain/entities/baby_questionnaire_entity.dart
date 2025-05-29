class BabyQuestionnaireEntity {
  final String? babyPhotoUrl;
  final String babyName;
  final DateTime dateOfBirth;
  final String relationship; // Mother, Father, etc.
  final String gender; // Boy, Girl
  final bool wasPremature;
  final int? weeksPremature;
  final List<String> diagnosedConditions;
  final List<String> careProviders;
  final bool hasMedicalContraindications;
  final String? contraindicationsDescription;
  final String floorTimeDaily;
  final String containerTimeDaily;
  final DateTime completedAt;

  BabyQuestionnaireEntity({
    this.babyPhotoUrl,
    required this.babyName,
    required this.dateOfBirth,
    required this.relationship,
    required this.gender,
    required this.wasPremature,
    this.weeksPremature,
    required this.diagnosedConditions,
    required this.careProviders,
    required this.hasMedicalContraindications,
    this.contraindicationsDescription,
    required this.floorTimeDaily,
    required this.containerTimeDaily,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'babyPhotoUrl': babyPhotoUrl,
      'babyName': babyName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'relationship': relationship,
      'gender': gender,
      'wasPremature': wasPremature,
      'weeksPremature': weeksPremature,
      'diagnosedConditions': diagnosedConditions,
      'careProviders': careProviders,
      'hasMedicalContraindications': hasMedicalContraindications,
      'contraindicationsDescription': contraindicationsDescription,
      'floorTimeDaily': floorTimeDaily,
      'containerTimeDaily': containerTimeDaily,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory BabyQuestionnaireEntity.fromMap(Map<String, dynamic> map) {
    return BabyQuestionnaireEntity(
      babyPhotoUrl: map['babyPhotoUrl'],
      babyName: map['babyName'] ?? '',
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      relationship: map['relationship'] ?? '',
      gender: map['gender'] ?? '',
      wasPremature: map['wasPremature'] ?? false,
      weeksPremature: map['weeksPremature'],
      diagnosedConditions: List<String>.from(map['diagnosedConditions'] ?? []),
      careProviders: List<String>.from(map['careProviders'] ?? []),
      hasMedicalContraindications: map['hasMedicalContraindications'] ?? false,
      contraindicationsDescription: map['contraindicationsDescription'],
      floorTimeDaily: map['floorTimeDaily'] ?? '',
      containerTimeDaily: map['containerTimeDaily'] ?? '',
      completedAt: DateTime.parse(map['completedAt']),
    );
  }
}
