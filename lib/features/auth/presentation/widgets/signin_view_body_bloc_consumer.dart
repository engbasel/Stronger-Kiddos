import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocConsumer;

import '../../../../../core/helper/failuer_top_snak_bar.dart';
import '../../../../../core/helper/scccess_top_snak_bar.dart';
import '../../../../../core/widgets/custom_progrss_hud.dart';
import '../manager/signup_cubit/signup_cubit.dart';
import '../manager/signup_cubit/signup_state.dart';
import 'signup_view_body.dart';

class SignInViewBodyBlocConsumer extends StatelessWidget {
  const SignInViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is EmailSignupSuccess) {
          succesTopSnackBar(context, 'Account created successfully');
          Navigator.pushReplacementNamed(context, '/home');
        }
        if (state is SignupFailure) {
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
            child: SignupViewBody(),
          ),
        );
      },
    );
  }
}
