import 'dart:developer';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/firebase_auth_service.dart';
import '../../../domain/entities/baby_questionnaire_entity.dart';
import '../../../domain/repos/baby_questionnaire_repo.dart';
import '../../../../auth/domain/repos/auth_repo.dart';
import '../../views/baby_questionnaire_completion_view.dart';
import 'baby_questionnaire_state.dart';

class BabyQuestionnaireCubit extends Cubit<BabyQuestionnaireState> {
  final BabyQuestionnaireRepo questionnaireRepo;
  final FirebaseAuthService authService;
  final AuthRepo authRepo;

  // State variables
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
    required this.authRepo,
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

  // 🔥 رفع صورة الطفل وتحديث بروفايل المستخدم (unified location: babies/photos/)
  Future<void> uploadBabyPhoto(File imageFile) async {
    emit(BabyPhotoUploading());

    final userId = authService.currentUser?.uid;
    if (userId == null) {
      emit(const BabyQuestionnaireError('User not logged in'));
      return;
    }

    try {
      // 1. رفع الصورة للطفل (ستذهب إلى babies/photos/ - unified location)
      final babyPhotoResult = await questionnaireRepo.uploadBabyPhoto(
        imageFile: imageFile,
        userId: userId,
      );

      await babyPhotoResult.fold(
        (failure) async {
          emit(BabyQuestionnaireError(failure.message));
        },
        (photoUrl) async {
          // 2. حفظ رابط الصورة في متغير الطفل
          babyPhotoUrl = photoUrl;

          // 3. تحديث صورة بروفايل المستخدم بنفس الصورة (same location, same photo)
          final userPhotoResult = await authRepo.updateUserPhoto(
            userId: userId,
            photoUrl: photoUrl,
          );

          await userPhotoResult.fold(
            (failure) async {
              // حتى لو فشل تحديث البروفايل، الطفل محفوظ
              log(
                'Warning: Failed to update user profile photo: ${failure.message}',
              );
              emit(BabyPhotoUploaded(photoUrl));
            },
            (updatedUser) async {
              // نجح التحديث لكلاهما (same photo in unified location)
              log('Photo uploaded successfully to unified location and synced');
              emit(BabyPhotoUploaded(photoUrl));
            },
          );
        },
      );
    } catch (e) {
      emit(BabyQuestionnaireError('Failed to upload photo: ${e.toString()}'));
    }
  }

  // 🔥 حذف صورة الطفل وصورة البروفايل (unified location: babies/photos/)
  Future<void> deleteBabyPhoto() async {
    emit(BabyPhotoDeleting());

    final userId = authService.currentUser?.uid;
    if (userId == null) {
      emit(const BabyQuestionnaireError('User not logged in'));
      return;
    }

    try {
      // 1. حذف الصورة من المكان الموحد (babies/photos/)
      final deleteResult = await questionnaireRepo.deleteBabyPhoto(
        userId: userId,
      );

      await deleteResult.fold(
        (failure) async {
          emit(BabyQuestionnaireError(failure.message));
        },
        (_) async {
          // 2. حذف صورة البروفايل من users collection (same photo)
          final userPhotoResult = await authRepo.updateUserPhoto(
            userId: userId,
            photoUrl: null, // حذف الصورة
          );

          // تحديث المتغير المحلي
          babyPhotoUrl = null;

          await userPhotoResult.fold(
            (failure) async {
              // حتى لو فشل حذف البروفايل، صورة الطفل محذوفة
              log(
                'Warning: Failed to delete user profile photo: ${failure.message}',
              );
              emit(BabyPhotoDeleted());
            },
            (updatedUser) async {
              // نجح الحذف (unified location)
              log('Photo deleted successfully from unified location');
              emit(BabyPhotoDeleted());
            },
          );
        },
      );
    } catch (e) {
      emit(BabyQuestionnaireError('Failed to delete photo: ${e.toString()}'));
    }
  }

  Future<void> loadExistingQuestionnaire() async {
    emit(BabyQuestionnaireLoading());

    final userId = authService.currentUser?.uid;
    if (userId == null) {
      emit(const BabyQuestionnaireError('User not logged in'));
      return;
    }

    final result = await questionnaireRepo.getQuestionnaireData(userId: userId);

    result.fold((failure) => emit(BabyQuestionnaireError(failure.message)), (
      questionnaire,
    ) {
      // Load existing data into cubit state
      babyPhotoUrl = questionnaire.babyPhotoUrl;
      babyName = questionnaire.babyName;
      dateOfBirth = questionnaire.dateOfBirth;
      relationship = questionnaire.relationship;
      gender = questionnaire.gender;
      wasPremature = questionnaire.wasPremature;
      weeksPremature = questionnaire.weeksPremature;
      diagnosedConditions = questionnaire.diagnosedConditions;
      careProviders = questionnaire.careProviders;
      hasMedicalContraindications = questionnaire.hasMedicalContraindications;
      contraindicationsDescription = questionnaire.contraindicationsDescription;
      floorTimeDaily = questionnaire.floorTimeDaily;
      containerTimeDaily = questionnaire.containerTimeDaily;

      emit(BabyQuestionnaireLoaded(questionnaire));
    });
  }

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

  Future<void> updateQuestionnaire(BuildContext context) async {
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

    final result = await questionnaireRepo.updateQuestionnaireData(
      userId: userId,
      questionnaireData: questionnaireData,
    );

    result.fold((failure) => emit(BabyQuestionnaireError(failure.message)), (
      _,
    ) {
      emit(BabyQuestionnaireUpdateSuccess());
    });
  }

  // Helper method to check if photo exists (unified location)
  Future<bool> checkBabyPhotoExists() async {
    final userId = authService.currentUser?.uid;
    if (userId == null) return false;

    final result = await questionnaireRepo.hasBabyPhoto(userId: userId);
    return result.fold((failure) => false, (exists) => exists);
  }

  // Helper method to get photo URL (unified location)
  Future<String?> getBabyPhotoUrl() async {
    final userId = authService.currentUser?.uid;
    if (userId == null) return null;

    final result = await questionnaireRepo.getBabyPhotoUrl(userId: userId);
    return result.fold((failure) => null, (url) => url);
  }

  // Reset all data
  void resetQuestionnaire() {
    babyPhotoUrl = null;
    babyName = '';
    dateOfBirth = null;
    relationship = '';
    gender = '';
    wasPremature = false;
    weeksPremature = null;
    diagnosedConditions = [];
    careProviders = [];
    hasMedicalContraindications = false;
    contraindicationsDescription = null;
    floorTimeDaily = '';
    containerTimeDaily = '';
  }
}
