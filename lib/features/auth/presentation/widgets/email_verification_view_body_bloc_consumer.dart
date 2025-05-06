import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strongerkiddos/core/helper/failuer_top_snak_bar.dart';
import 'package:strongerkiddos/core/helper/scccess_top_snak_bar.dart';
import 'package:strongerkiddos/core/widgets/custom_progrss_hud.dart';
import 'package:strongerkiddos/features/auth/presentation/manager/email_verification_cubit/email_verification_cubit.dart';
import 'package:strongerkiddos/features/auth/presentation/views/successfully_verified_view.dart';
import 'package:strongerkiddos/features/auth/presentation/widgets/email_verification_view_body.dart';

class EmailVerificationViewBodyBlocConsumer extends StatelessWidget {
  final String email;

  const EmailVerificationViewBodyBlocConsumer({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
      listener: (context, state) {
        if (state is EmailVerified) {
          succesTopSnackBar(context, 'Email successfully verified!');
          Navigator.pushReplacementNamed(
            context,
            SuccessfullyVerifiedView.routeName,
          );
        } else if (state is VerificationEmailSent) {
          succesTopSnackBar(context, 'Verification email sent successfully');
        } else if (state is ResendVerificationFailed) {
          failuerTopSnackBar(context, state.message);
        } else if (state is VerificationCheckFailed) {
          failuerTopSnackBar(context, state.message);
        } else if (state is EmailNotVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Email not verified yet. Please check your inbox.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        return CustomProgrssHud(
          isLoading:
              state is ResendingVerificationEmail ||
              state is CheckingVerification,
          child: EmailVerificationViewBody(email: email),
        );
      },
    );
  }
}
