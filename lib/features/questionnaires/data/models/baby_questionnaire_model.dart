import '../../domain/entities/baby_questionnaire_entity.dart';

class BabyQuestionnaireModel extends BabyQuestionnaireEntity {
  BabyQuestionnaireModel({
    super.babyPhotoUrl,
    required super.babyName,
    required super.dateOfBirth,
    required super.relationship,
    required super.gender,
    required super.wasPremature,
    super.weeksPremature,
    required super.diagnosedConditions,
    required super.careProviders,
    required super.hasMedicalContraindications,
    super.contraindicationsDescription,
    required super.floorTimeDaily,
    required super.containerTimeDaily,
    required super.completedAt,
  });

  factory BabyQuestionnaireModel.fromJson(Map<String, dynamic> json) {
    return BabyQuestionnaireModel(
      babyPhotoUrl: json['babyPhotoUrl'],
      babyName: json['babyName'] ?? '',
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      relationship: json['relationship'] ?? '',
      gender: json['gender'] ?? '',
      wasPremature: json['wasPremature'] ?? false,
      weeksPremature: json['weeksPremature'],
      diagnosedConditions: List<String>.from(json['diagnosedConditions'] ?? []),
      careProviders: List<String>.from(json['careProviders'] ?? []),
      hasMedicalContraindications: json['hasMedicalContraindications'] ?? false,
      contraindicationsDescription: json['contraindicationsDescription'],
      floorTimeDaily: json['floorTimeDaily'] ?? '',
      containerTimeDaily: json['containerTimeDaily'] ?? '',
      completedAt: DateTime.parse(json['completedAt']),
    );
  }

  Map<String, dynamic> toJson() {
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

  factory BabyQuestionnaireModel.fromEntity(BabyQuestionnaireEntity entity) {
    return BabyQuestionnaireModel(
      babyPhotoUrl: entity.babyPhotoUrl,
      babyName: entity.babyName,
      dateOfBirth: entity.dateOfBirth,
      relationship: entity.relationship,
      gender: entity.gender,
      wasPremature: entity.wasPremature,
      weeksPremature: entity.weeksPremature,
      diagnosedConditions: entity.diagnosedConditions,
      careProviders: entity.careProviders,
      hasMedicalContraindications: entity.hasMedicalContraindications,
      contraindicationsDescription: entity.contraindicationsDescription,
      floorTimeDaily: entity.floorTimeDaily,
      containerTimeDaily: entity.containerTimeDaily,
      completedAt: entity.completedAt,
    );
  }

  BabyQuestionnaireEntity toEntity() {
    return BabyQuestionnaireEntity(
      babyPhotoUrl: babyPhotoUrl,
      babyName: babyName,
      dateOfBirth: dateOfBirth,
      relationship: relationship,
      gender: gender,
      wasPremature: wasPremature,
      weeksPremature: weeksPremature,
      diagnosedConditions: diagnosedConditions,
      careProviders: careProviders,
      hasMedicalContraindications: hasMedicalContraindications,
      contraindicationsDescription: contraindicationsDescription,
      floorTimeDaily: floorTimeDaily,
      containerTimeDaily: containerTimeDaily,
      completedAt: completedAt,
    );
  }
}
