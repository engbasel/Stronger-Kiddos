import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helper/failuer_top_snak_bar.dart';
import '../../../../core/helper/scccess_top_snak_bar.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../../core/services/get_it_service.dart';
import '../../../../core/widgets/custom_progrss_hud.dart';
import '../../../../features/home/presentation/Views/home_view.dart';
import '../manager/questionnaire_cubit/questionnaire_cubit.dart';
import '../manager/questionnaire_cubit/questionnaire_state.dart';
import 'child_info_question.dart';

class QuestionnaireControllerView extends StatelessWidget {
  const QuestionnaireControllerView({super.key});

  static const String routeName = '/questionnaire';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => QuestionnaireCubit(
            questionnaireRepo: getIt.get(),
            authService: getIt.get<FirebaseAuthService>(),
          )..checkQuestionnaireStatus(),
      child: const QuestionnaireControllerContent(),
    );
  }
}

class QuestionnaireControllerContent extends StatelessWidget {
  const QuestionnaireControllerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuestionnaireCubit, QuestionnaireState>(
      listener: (context, state) {
        if (state is QuestionnaireError) {
          failuerTopSnackBar(context, state.message);
        } else if (state is QuestionnaireCompleted) {
          // User already completed questionnaire, skip to home
          Navigator.pushReplacementNamed(context, HomeView.routeName);
        } else if (state is QuestionnaireSubmitSuccess) {
          succesTopSnackBar(
            context,
            'Thank you for completing the questionnaire!',
          );
          Navigator.pushReplacementNamed(context, HomeView.routeName);
        }
      },
      builder: (context, state) {
        return CustomProgrssHud(
          isLoading:
              state is QuestionnaireLoading || state is QuestionnaireSaving,
          child:
              state is QuestionnaireReadyToStart
                  ? ChildInfoQuestion(
                    questionnaireCubit: context.read<QuestionnaireCubit>(),
                  )
                  : const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
        );
      },
    );
  }
}
