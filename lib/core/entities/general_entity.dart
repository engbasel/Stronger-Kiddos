// ignore_for_file: file_names

class GeneralEntity {
  final bool? hasSubscription;
  final String? subscriptionStatus;
  final bool? regularTreatment;
  final int? visitCount;
  final bool? reminderEnabled;
  final DateTime? lastVisitDate;
  final String? preferredLanguage;
  final List<String>? notificationPreferences;
  final List<String>? sessionHistory;
  final String? activityLevel;

  GeneralEntity({
    this.hasSubscription,
    this.subscriptionStatus,
    this.regularTreatment,
    this.visitCount,
    this.reminderEnabled,
    this.lastVisitDate,
    this.preferredLanguage,
    this.notificationPreferences,
    this.sessionHistory,
    this.activityLevel,
  });
}
