import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helper/failuer_top_snak_bar.dart';
import '../../../../core/helper/scccess_top_snak_bar.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../../core/services/get_it_service.dart';
import '../../../../core/widgets/custom_progrss_hud.dart';
import '../../../../features/home/presentation/views/main_navigation_view.dart';
import '../manager/baby_questionnaire_cubit/baby_questionnaire_cubit.dart';
import '../manager/baby_questionnaire_cubit/baby_questionnaire_state.dart';
import 'baby_basic_info_page.dart';

class BabyQuestionnaireControllerView extends StatelessWidget {
  const BabyQuestionnaireControllerView({super.key});

  static const String routeName = '/baby-questionnaire';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => BabyQuestionnaireCubit(
            questionnaireRepo: getIt.get(),
            authService: getIt.get<FirebaseAuthService>(),
          )..checkQuestionnaireStatus(),
      child: const BabyQuestionnaireControllerContent(),
    );
  }
}

class BabyQuestionnaireControllerContent extends StatelessWidget {
  const BabyQuestionnaireControllerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BabyQuestionnaireCubit, BabyQuestionnaireState>(
      listener: (context, state) {
        if (state is BabyQuestionnaireError) {
          failuerTopSnackBar(context, state.message);
        } else if (state is BabyQuestionnaireCompleted) {
          Navigator.pushReplacementNamed(context, MainNavigationView.routeName);
        } else if (state is BabyQuestionnaireSubmitSuccess) {
          succesTopSnackBar(
            context,
            'Thank you for completing the questionnaire!',
          );
          Navigator.pushReplacementNamed(context, MainNavigationView.routeName);
        }
      },
      builder: (context, state) {
        return CustomProgrssHud(
          // 🎯 FIX: Only show loading for specific questionnaire operations
          // Exclude photo upload states to prevent UI rebuild issues
          isLoading: _shouldShowLoading(state),
          child: _buildContent(context, state),
        );
      },
    );
  }

  // 🎯 Helper method to determine when to show loading
  bool _shouldShowLoading(BabyQuestionnaireState state) {
    return state is BabyQuestionnaireLoading ||
        state is BabyQuestionnaireSaving;
    // ❌ Excluded: BabyPhotoUploading, BabyPhotoDeleting
    // These will be handled locally in BabyBasicInfoPage
  }

  // 🎯 Helper method to build content based on state
  Widget _buildContent(BuildContext context, BabyQuestionnaireState state) {
    if (state is BabyQuestionnaireReadyToStart ||
        state is BabyPhotoUploading || // ✅ Allow photo upload states
        state is BabyPhotoUploaded || // ✅ Allow photo uploaded states
        state is BabyPhotoDeleted || // ✅ Allow photo deleted states
        state is BabyPhotoDeleting) {
      // ✅ Allow photo deleting states
      return BabyBasicInfoPage(
        questionnaireCubit: context.read<BabyQuestionnaireCubit>(),
      );
    }

    // Show loading for initial states
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading questionnaire...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
