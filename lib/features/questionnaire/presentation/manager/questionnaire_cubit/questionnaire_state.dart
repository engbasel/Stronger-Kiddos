import 'package:equatable/equatable.dart';

abstract class QuestionnaireState extends Equatable {
  const QuestionnaireState();

  @override
  List<Object?> get props => [];
}

class QuestionnaireInitial extends QuestionnaireState {}

class QuestionnaireLoading extends QuestionnaireState {}

class QuestionnaireReadyToStart extends QuestionnaireState {}

class QuestionnaireCompleted extends QuestionnaireState {}

class QuestionnaireSaving extends QuestionnaireState {}

class QuestionnaireSubmitSuccess extends QuestionnaireState {}

class QuestionnaireError extends QuestionnaireState {
  final String message;

  const QuestionnaireError(this.message);

  @override
  List<Object?> get props => [message];
}
