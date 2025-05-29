import 'package:equatable/equatable.dart';

abstract class BabyQuestionnaireState extends Equatable {
  const BabyQuestionnaireState();

  @override
  List<Object?> get props => [];
}

class BabyQuestionnaireInitial extends BabyQuestionnaireState {}

class BabyQuestionnaireLoading extends BabyQuestionnaireState {}

class BabyQuestionnaireReadyToStart extends BabyQuestionnaireState {}

class BabyQuestionnaireCompleted extends BabyQuestionnaireState {}

class BabyQuestionnaireSaving extends BabyQuestionnaireState {}

class BabyQuestionnaireSubmitSuccess extends BabyQuestionnaireState {}

class BabyQuestionnaireError extends BabyQuestionnaireState {
  final String message;

  const BabyQuestionnaireError(this.message);

  @override
  List<Object?> get props => [message];
}
