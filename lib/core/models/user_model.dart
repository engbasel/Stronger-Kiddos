import 'package:firebase_auth/firebase_auth.dart';
import 'package:strongerkiddos/core/entities/doctor_entity.dart';
import 'package:strongerkiddos/core/entities/environmental_entity.dart';
import 'package:strongerkiddos/core/entities/general_entity.dart';
import 'package:strongerkiddos/core/entities/health_entity.dart';
import 'package:strongerkiddos/core/entities/progress_entity.dart';
import 'package:strongerkiddos/core/entities/social_entity.dart';
import 'package:strongerkiddos/core/entities/subscription_entity.dart';
import 'package:strongerkiddos/features/auth/domain/entities/user_entity.dart';
import 'package:strongerkiddos/features/auth/data/models/user_model.dart'
    as auth;

class UserModel {
  final UserEntity user;
  final HealthEntity healthInfo;
  final SocialEntity socialInfo;
  final GeneralEntity generalInfo;
  final SubscriptionEntity subscriptionInfo;
  final DoctorEntity doctorInfo;
  final ProgressEntity progressInfo;
  final EnvironmentalEntity environmentalInfo;

  UserModel({
    required this.user,
    required this.healthInfo,
    required this.socialInfo,
    required this.generalInfo,
    required this.subscriptionInfo,
    required this.doctorInfo,
    required this.progressInfo,
    required this.environmentalInfo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      user: UserEntity(
        id: json['id'],
        name: json['name'],
        role: json['role'],
        createdAt:
            json['created_at'] != null
                ? DateTime.parse(json['created_at'])
                : DateTime.now(),
        email: json['email'],
        phoneNumber: json['phone_number'],
        profileImageUrl: json['profile_image_url'],
        photoUrl: json['photoUrl'],
        isEmailVerified: json['isEmailVerified'] ?? false,
        userStat: json['userStat'] ?? 'active',
      ),
      healthInfo: HealthEntity(
        injuryType: json['injury_type'],
        healthCondition: json['health_condition'],
        pastTreatments:
            json['past_treatments'] != null
                ? List<String>.from(json['past_treatments'])
                : null,
        medications:
            json['medications'] != null
                ? List<String>.from(json['medications'])
                : null,
        medicalHistory: json['medical_history'],
        medicalTests:
            json['medical_tests'] != null
                ? List<String>.from(json['medical_tests'])
                : null,
        prescribedMedications:
            json['prescribed_medications'] != null
                ? List<String>.from(json['prescribed_medications'])
                : null,
        recommendedExercises:
            json['recommended_exercises'] != null
                ? List<String>.from(json['recommended_exercises'])
                : null,
      ),
      socialInfo: SocialEntity(
        maritalStatus: json['marital_status'],
        numberOfChildren: json['number_of_children'],
        occupation: json['occupation'],
        familySupport: json['family_support'],
        supportGroups:
            json['support_groups'] != null
                ? List<String>.from(json['support_groups'])
                : null,
        selfEsteem: json['self_esteem'],
        moodStatus: json['mood_status'],
      ),
      generalInfo: GeneralEntity(
        hasSubscription: json['has_subscription'],
        subscriptionStatus: json['subscription_status'],
        regularTreatment: json['regular_treatment'],
        visitCount: json['visit_count'],
        reminderEnabled: json['reminder_enabled'],
        lastVisitDate:
            json['last_visit_date'] != null
                ? DateTime.tryParse(json['last_visit_date'])
                : null,
        preferredLanguage: json['preferred_language'],
        notificationPreferences:
            json['notification_preferences'] != null
                ? List<String>.from(json['notification_preferences'])
                : null,
        sessionHistory:
            json['session_history'] != null
                ? List<String>.from(json['session_history'])
                : null,
        activityLevel: json['activity_level'],
      ),
      subscriptionInfo: SubscriptionEntity(
        subscriptionStartDate:
            json['subscription_start_date'] != null
                ? DateTime.tryParse(json['subscription_start_date'])
                : null,
        subscriptionEndDate:
            json['subscription_end_date'] != null
                ? DateTime.tryParse(json['subscription_end_date'])
                : null,
        purchasedServices:
            json['purchased_services'] != null
                ? List<String>.from(json['purchased_services'])
                : null,
        availableServices:
            json['available_services'] != null
                ? List<String>.from(json['available_services'])
                : null,
      ),
      doctorInfo: DoctorEntity(
        patientsCount: json['patients_count'],
        doctorRating: json['doctor_rating'],
        workingHours: json['working_hours'],
      ),
      progressInfo: ProgressEntity(
        treatmentProgress: json['treatment_progress'],
        vitalSigns:
            json['vital_signs'] != null
                ? Map<String, double>.from(json['vital_signs'])
                : null,
      ),
      environmentalInfo: EnvironmentalEntity(
        availableEquipment:
            json['available_equipment'] != null
                ? List<String>.from(json['available_equipment'])
                : null,
        environmentalFactors: json['environmental_factors'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final userMap = user.toMap();

    return {
      'id': userMap['id'],
      'name': userMap['name'],
      'email': userMap['email'],
      'phone_number': userMap['phoneNumber'],
      'profile_image_url': userMap['profileImageUrl'],
      'photoUrl': userMap['photoUrl'],
      'role': userMap['role'],
      'created_at': userMap['createdAt']?.toIso8601String(),
      'isEmailVerified': userMap['isEmailVerified'],
      'userStat': userMap['userStat'],

      // Health info
      'injury_type': healthInfo.injuryType,
      'health_condition': healthInfo.healthCondition,
      'past_treatments': healthInfo.pastTreatments,
      'medications': healthInfo.medications,
      'medical_history': healthInfo.medicalHistory,
      'medical_tests': healthInfo.medicalTests,
      'prescribed_medications': healthInfo.prescribedMedications,
      'recommended_exercises': healthInfo.recommendedExercises,

      // Social info
      'marital_status': socialInfo.maritalStatus,
      'number_of_children': socialInfo.numberOfChildren,
      'occupation': socialInfo.occupation,
      'family_support': socialInfo.familySupport,
      'support_groups': socialInfo.supportGroups,
      'self_esteem': socialInfo.selfEsteem,
      'mood_status': socialInfo.moodStatus,

      // General info
      'has_subscription': generalInfo.hasSubscription,
      'subscription_status': generalInfo.subscriptionStatus,
      'regular_treatment': generalInfo.regularTreatment,
      'visit_count': generalInfo.visitCount,
      'reminder_enabled': generalInfo.reminderEnabled,
      'last_visit_date': generalInfo.lastVisitDate?.toIso8601String(),
      'preferred_language': generalInfo.preferredLanguage,
      'notification_preferences': generalInfo.notificationPreferences,
      'session_history': generalInfo.sessionHistory,
      'activity_level': generalInfo.activityLevel,

      // Subscription info
      'subscription_start_date':
          subscriptionInfo.subscriptionStartDate?.toIso8601String(),
      'subscription_end_date':
          subscriptionInfo.subscriptionEndDate?.toIso8601String(),
      'purchased_services': subscriptionInfo.purchasedServices,
      'available_services': subscriptionInfo.availableServices,

      // Doctor info
      'patients_count': doctorInfo.patientsCount,
      'doctor_rating': doctorInfo.doctorRating,
      'working_hours': doctorInfo.workingHours,

      // Progress info
      'treatment_progress': progressInfo.treatmentProgress,
      'vital_signs': progressInfo.vitalSigns,

      // Environmental info
      'available_equipment': environmentalInfo.availableEquipment,
      'environmental_factors': environmentalInfo.environmentalFactors,
    };
  }

  // Create a UserModel from Firebase User and default values for other entities
  factory UserModel.fromFirebaseUser(User firebaseUser) {
    final authUserModel = auth.UserModel.fromFirebaseUser(firebaseUser);

    return UserModel(
      user: authUserModel,
      healthInfo: HealthEntity(),
      socialInfo: SocialEntity(),
      generalInfo: GeneralEntity(
        hasSubscription: false,
        subscriptionStatus: 'inactive',
        regularTreatment: false,
        visitCount: 0,
        reminderEnabled: true,
        lastVisitDate: null,
        preferredLanguage: 'en',
        notificationPreferences: ['email'],
        sessionHistory: [],
        activityLevel: 'moderate',
      ),
      subscriptionInfo: SubscriptionEntity(
        subscriptionStartDate: null,
        subscriptionEndDate: null,
        purchasedServices: [],
        availableServices: [],
      ),
      doctorInfo: DoctorEntity(
        patientsCount: 0,
        doctorRating: 0,
        workingHours: '',
      ),
      progressInfo: ProgressEntity(treatmentProgress: '', vitalSigns: {}),
      environmentalInfo: EnvironmentalEntity(
        availableEquipment: [],
        environmentalFactors: '',
      ),
    );
  }

  // Create a UserModel from an auth UserModel and default values for other entities
  factory UserModel.fromAuthModel(auth.UserModel authUserModel) {
    return UserModel(
      user: authUserModel,
      healthInfo: HealthEntity(),
      socialInfo: SocialEntity(),
      generalInfo: GeneralEntity(
        hasSubscription: false,
        subscriptionStatus: 'inactive',
        regularTreatment: false,
        visitCount: 0,
        reminderEnabled: true,
      ),
      subscriptionInfo: SubscriptionEntity(),
      doctorInfo: DoctorEntity(),
      progressInfo: ProgressEntity(),
      environmentalInfo: EnvironmentalEntity(),
    );
  }
}
