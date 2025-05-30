import 'package:equatable/equatable.dart';
import '../../../domain/entities/baby_questionnaire_entity.dart';

abstract class BabyQuestionnaireState extends Equatable {
  const BabyQuestionnaireState();

  @override
  List<Object?> get props => [];
}

class BabyQuestionnaireInitial extends BabyQuestionnaireState {}

class BabyQuestionnaireLoading extends BabyQuestionnaireState {}

class BabyQuestionnaireReadyToStart extends BabyQuestionnaireState {}

class BabyQuestionnaireCompleted extends BabyQuestionnaireState {}

class BabyQuestionnaireLoaded extends BabyQuestionnaireState {
  final BabyQuestionnaireEntity questionnaire;

  const BabyQuestionnaireLoaded(this.questionnaire);

  @override
  List<Object?> get props => [questionnaire];
}

class BabyQuestionnaireSaving extends BabyQuestionnaireState {}

class BabyQuestionnaireSubmitSuccess extends BabyQuestionnaireState {}

class BabyQuestionnaireUpdateSuccess extends BabyQuestionnaireState {}

// Photo related states
class BabyPhotoUploading extends BabyQuestionnaireState {}

class BabyPhotoUploaded extends BabyQuestionnaireState {
  final String photoUrl;

  const BabyPhotoUploaded(this.photoUrl);

  @override
  List<Object?> get props => [photoUrl];
}

class BabyPhotoDeleting extends BabyQuestionnaireState {}

class BabyPhotoDeleted extends BabyQuestionnaireState {}

class BabyQuestionnaireError extends BabyQuestionnaireState {
  final String message;

  const BabyQuestionnaireError(this.message);

  @override
  List<Object?> get props => [message];
}
