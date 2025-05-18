// lib/core/entities/questionnaire_entity.dart
class QuestionnaireEntity {
  final String childName;
  final int childAgeMonths;
  final String gender;
  final bool wasPremature;
  final int? weeksPremature;
  final List<String> diagnosedConditions;
  final List<String> specialists;
  final bool hasMedicalContraindications;
  final String? medicalContraindicationsDetails;
  final String floorTimeDaily;
  final String containerTimeDaily;
  final List<String> concernAreas;
  final DateTime completedAt;

  QuestionnaireEntity({
    required this.childName,
    required this.childAgeMonths,
    required this.gender,
    required this.wasPremature,
    this.weeksPremature,
    required this.diagnosedConditions,
    required this.specialists,
    required this.hasMedicalContraindications,
    this.medicalContraindicationsDetails,
    required this.floorTimeDaily,
    required this.containerTimeDaily,
    required this.concernAreas,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'childName': childName,
      'childAgeMonths': childAgeMonths,
      'gender': gender,
      'wasPremature': wasPremature,
      'weeksPremature': weeksPremature,
      'diagnosedConditions': diagnosedConditions,
      'specialists': specialists,
      'hasMedicalContraindications': hasMedicalContraindications,
      'medicalContraindicationsDetails': medicalContraindicationsDetails,
      'floorTimeDaily': floorTimeDaily,
      'containerTimeDaily': containerTimeDaily,
      'concernAreas': concernAreas,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory QuestionnaireEntity.fromMap(Map<String, dynamic> map) {
    return QuestionnaireEntity(
      childName: map['childName'] ?? '',
      childAgeMonths: map['childAgeMonths'] ?? 0,
      gender: map['gender'] ?? '',
      wasPremature: map['wasPremature'] ?? false,
      weeksPremature: map['weeksPremature'],
      diagnosedConditions: List<String>.from(map['diagnosedConditions'] ?? []),
      specialists: List<String>.from(map['specialists'] ?? []),
      hasMedicalContraindications: map['hasMedicalContraindications'] ?? false,
      medicalContraindicationsDetails: map['medicalContraindicationsDetails'],
      floorTimeDaily: map['floorTimeDaily'] ?? '',
      containerTimeDaily: map['containerTimeDaily'] ?? '',
      concernAreas: List<String>.from(map['concernAreas'] ?? []),
      completedAt:
          map['completedAt'] != null
              ? DateTime.parse(map['completedAt'])
              : DateTime.now(),
    );
  }
}
