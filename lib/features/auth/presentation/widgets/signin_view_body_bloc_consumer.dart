import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/helper/failuer_top_snak_bar.dart';
import '../../../../../core/helper/scccess_top_snak_bar.dart';
import '../../../../../core/widgets/custom_progrss_hud.dart';
import '../../../home/presentation/Views/home_view.dart';
import '../manager/signup_cubit/signup_cubit.dart';
import '../manager/signup_cubit/signup_state.dart';
import '../views/otp_vericifaction.dart';
import '../views/successfully_verified_view.dart';

class SignInViewBodyBlocConsumer extends StatelessWidget {
  const SignInViewBodyBlocConsumer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is EmailSignupSuccess) {
          succesTopSnackBar(context, 'Account created successfully');
          Navigator.pushReplacementNamed(context, HomeView.routeName);
        } else if (state is GoogleSignupSuccess) {
          succesTopSnackBar(context, 'Account created successfully');
          Navigator.pushReplacementNamed(context, HomeView.routeName);
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
