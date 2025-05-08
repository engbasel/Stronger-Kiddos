// lib/features/auth/presentation/widgets/signin_view_body_bloc_consumer.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/helper/failuer_top_snak_bar.dart';
import '../../../../../core/helper/scccess_top_snak_bar.dart';
import '../../../../../core/services/firebase_auth_service.dart';
import '../../../../../core/services/get_it_service.dart';
import '../../../../../core/widgets/custom_progrss_hud.dart';
import '../../../../../features/questionnaire/domain/repos/questionnaire_repo.dart';
import '../../../../../features/questionnaire/presentation/views/questionnaire_controller_view.dart';
import '../../../home/presentation/Views/home_view.dart';
import '../manager/signup_cubit/signup_cubit.dart';
import '../manager/signup_cubit/signup_state.dart';
import '../views/email_verification_view.dart';
import '../views/otp_vericifaction.dart';
import '../views/successfully_verified_view.dart';

class SignInViewBodyBlocConsumer extends StatelessWidget {
  const SignInViewBodyBlocConsumer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) async {
        if (state is EmailSignupSuccess) {
          succesTopSnackBar(context, 'Account created successfully');
          if (state.requiresVerification) {
            Navigator.pushReplacementNamed(
              context,
              EmailVerificationView.routeName,
              arguments: {'email': state.email},
            );
          } else {
            // User is verified, redirect to questionnaire
            Navigator.pushReplacementNamed(
              context,
              QuestionnaireControllerView.routeName,
            );
          }
        } else if (state is GoogleSignupSuccess) {
          succesTopSnackBar(context, 'Account created successfully');

          // Check if user has completed questionnaire
          final authService = getIt<FirebaseAuthService>();
          final questionnaireRepo = getIt<QuestionnaireRepo>();
          final userId = authService.currentUser?.uid;

          if (userId != null) {
            final result = await questionnaireRepo.hasCompletedQuestionnaire(
              userId: userId,
            );

            final hasCompletedQuestionnaire = result.fold(
              (failure) => false,
              (completed) => completed,
            );

            if (!context.mounted) return;

            if (hasCompletedQuestionnaire) {
              Navigator.pushReplacementNamed(context, HomeView.routeName);
            } else {
              Navigator.pushReplacementNamed(
                context,
                QuestionnaireControllerView.routeName,
              );
            }
          }
        } else if (state is PhoneVerificationSent) {
          succesTopSnackBar(context, 'OTP sent successfully');
          Navigator.pushNamed(
            context,
            OtpVerificationView.routeName,
            arguments: {
              'verificationId': state.verificationId,
              'phoneNumber': state.phoneNumber,
              'name': '',
            },
          );
        } else if (state is PhoneSignupSuccess) {
          succesTopSnackBar(context, 'Phone verification successful');
          Navigator.pushReplacementNamed(
            context,
            SuccessfullyVerifiedView.routeName,
          );
        } else if (state is SignupFailure) {
          failuerTopSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: CustomProgrssHud(
            isLoading: state is SignupLoading,
            child: child,
          ),
        );
      },
    );
  }
}
