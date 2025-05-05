// ignore_for_file: file_names

class HealthEntity {
  final String? injuryType;
  final String? healthCondition;
  final List<String>? pastTreatments;
  final List<String>? medications;
  final String? medicalHistory;
  final List<String>? medicalTests;
  final List<String>? prescribedMedications;
  final List<String>? recommendedExercises;

  HealthEntity({
    this.injuryType,
    this.healthCondition,
    this.pastTreatments,
    this.medications,
    this.medicalHistory,
    this.medicalTests,
    this.prescribedMedications,
    this.recommendedExercises,
  });
}
