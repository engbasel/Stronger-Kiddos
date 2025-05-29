import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/firebase_auth_service.dart';
import '../../../domain/entities/baby_questionnaire_entity.dart';
import '../../../domain/repos/baby_questionnaire_repo.dart';
import '../../views/baby_questionnaire_completion_view.dart';
import 'baby_questionnaire_state.dart';

class BabyQuestionnaireCubit extends Cubit<BabyQuestionnaireState> {
  final BabyQuestionnaireRepo questionnaireRepo;
  final FirebaseAuthService authService;

  // State variables (keep these public for direct access)
  String? babyPhotoUrl;
  String babyName = '';
  DateTime? dateOfBirth;
  String relationship = '';
  String gender = '';
  bool wasPremature = false;
  int? weeksPremature;
  List<String> diagnosedConditions = [];
  List<String> careProviders = [];
  bool hasMedicalContraindications = false;
  String? contraindicationsDescription;
  String floorTimeDaily = '';
  String containerTimeDaily = '';

  BabyQuestionnaireCubit({
    required this.questionnaireRepo,
    required this.authService,
  }) : super(BabyQuestionnaireInitial());

  Future<void> checkQuestionnaireStatus() async {
    emit(BabyQuestionnaireLoading());

    final userId = authService.currentUser?.uid;
    if (userId == null) {
      emit(const BabyQuestionnaireError('User not logged in'));
      return;
    }

    final result = await questionnaireRepo.hasCompletedQuestionnaire(
      userId: userId,
    );

    result.fold((failure) => emit(BabyQuestionnaireError(failure.message)), (
      hasCompleted,
    ) {
      if (hasCompleted) {
        emit(BabyQuestionnaireCompleted());
      } else {
        emit(BabyQuestionnaireReadyToStart());
      }
    });
  }

  // REMOVED: uploadBabyPhoto method - now handled directly in UI

  void updateBasicInfo(String name, DateTime birthDate, String rel) {
    babyName = name;
    dateOfBirth = birthDate;
    relationship = rel;
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

  void updateCareProviders(List<String> providers) {
    careProviders = providers;
  }

  void updateMedicalContraindications(
    bool hasContraindications, [
    String? description,
  ]) {
    hasMedicalContraindications = hasContraindications;
    contraindicationsDescription = description;
  }

  void updateFloorTime(String time) {
    floorTimeDaily = time;
  }

  void updateContainerTime(String time) {
    containerTimeDaily = time;
  }

  Future<void> submitQuestionnaire(BuildContext context) async {
    emit(BabyQuestionnaireSaving());

    final userId = authService.currentUser?.uid;
    if (userId == null) {
      emit(const BabyQuestionnaireError('User not logged in'));
      return;
    }

    if (dateOfBirth == null) {
      emit(const BabyQuestionnaireError('Please complete all required fields'));
      return;
    }

    final questionnaireData = BabyQuestionnaireEntity(
      babyPhotoUrl: babyPhotoUrl,
      babyName: babyName,
      dateOfBirth: dateOfBirth!,
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
      completedAt: DateTime.now(),
    );

    final result = await questionnaireRepo.saveQuestionnaireData(
      userId: userId,
      questionnaireData: questionnaireData,
    );

    result.fold((failure) => emit(BabyQuestionnaireError(failure.message)), (
      _,
    ) {
      emit(BabyQuestionnaireSubmitSuccess());
      Navigator.pushReplacementNamed(
        context,
        BabyQuestionnaireCompletionView.routeName,
      );
    });
  }
}
