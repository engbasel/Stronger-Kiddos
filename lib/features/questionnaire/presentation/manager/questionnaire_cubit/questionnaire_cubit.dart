// lib/features/questionnaire/presentation/manager/questionnaire_cubit.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/firebase_auth_service.dart';
import '../../../domain/entities/questionnaire_entity.dart';
import '../../../domain/repos/questionnaire_repo.dart';
import '../../views/questionnaire_completion_view.dart';
import 'questionnaire_state.dart';

class QuestionnaireCubit extends Cubit<QuestionnaireState> {
  final QuestionnaireRepo questionnaireRepo;
  final FirebaseAuthService authService;

  // State variables to hold questionnaire responses
  String childName = '';
  int childAgeMonths = 0;
  String gender = '';
  bool wasPremature = false;
  int? weeksPremature;
  List<String> diagnosedConditions = [];
  List<String> specialists = [];
  bool hasMedicalContraindications = false;
  String? medicalContraindicationsDetails;
  String floorTimeDaily = '';
  String containerTimeDaily = '';
  List<String> concernAreas = [];

  QuestionnaireCubit({
    required this.questionnaireRepo,
    required this.authService,
  }) : super(QuestionnaireInitial());

  // Check if user has already completed questionnaire
  Future<void> checkQuestionnaireStatus() async {
    emit(QuestionnaireLoading());

    final userId = authService.currentUser?.uid;
    if (userId == null) {
      emit(QuestionnaireError('User not logged in'));
      return;
    }

    final result = await questionnaireRepo.hasCompletedQuestionnaire(
      userId: userId,
    );

    result.fold((failure) => emit(QuestionnaireError(failure.message)), (
      hasCompleted,
    ) {
      if (hasCompleted) {
        emit(QuestionnaireCompleted());
      } else {
        emit(QuestionnaireReadyToStart());
      }
    });
  }

  // Update individual question responses
  void updateChildInfo(String name, int ageMonths) {
    childName = name;
    childAgeMonths = ageMonths;
  }

  void updateGender(String selectedGender) {
    gender = selectedGender;
  }

  void updatePrematureStatus(bool isPremature, [int? weeks]) {
    wasPremature = isPremature;
    weeksPremature = weeks;
  }

  void updateDiagnosedConditions(List<String> conditions) {
    diagnosedConditions = conditions;
  }

  void updateSpecialists(List<String> careSpecialists) {
    specialists = careSpecialists;
  }

  void updateMedicalContraindications(
    bool hasContraindications, [
    String? details,
  ]) {
    hasMedicalContraindications = hasContraindications;
    medicalContraindicationsDetails = details;
  }

  void updateFloorTime(String time) {
    floorTimeDaily = time;
  }

  void updateContainerTime(String time) {
    containerTimeDaily = time;
  }

  void updateConcernAreas(List<String> concerns) {
    concernAreas = concerns;
  }

  // Submit complete questionnaire
  Future<void> submitQuestionnaire(BuildContext context) async {
    emit(QuestionnaireSaving());

    final userId = authService.currentUser?.uid;
    if (userId == null) {
      emit(QuestionnaireError('User not logged in'));
      return;
    }

    final questionnaireData = QuestionnaireEntity(
      childName: childName,
      childAgeMonths: childAgeMonths,
      gender: gender,
      wasPremature: wasPremature,
      weeksPremature: weeksPremature,
      diagnosedConditions: diagnosedConditions,
      specialists: specialists,
      hasMedicalContraindications: hasMedicalContraindications,
      medicalContraindicationsDetails: medicalContraindicationsDetails,
      floorTimeDaily: floorTimeDaily,
      containerTimeDaily: containerTimeDaily,
      concernAreas: concernAreas,
      completedAt: DateTime.now(),
    );

    final result = await questionnaireRepo.saveQuestionnaireData(
      userId: userId,
      questionnaireData: questionnaireData,
    );

    result.fold((failure) => emit(QuestionnaireError(failure.message)), (_) {
      emit(QuestionnaireSubmitSuccess());
      // Navigate to completion screen
      Navigator.pushReplacementNamed(
        context,
        QuestionnaireCompletionView.routeName,
      );
    });
  }
}
