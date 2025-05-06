import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helper/failuer_top_snak_bar.dart';
import '../../../../core/widgets/custom_progrss_hud.dart';
import '../manager/login_cubit/login_cubit.dart';
import '../manager/login_cubit/login_state.dart';
import 'login_view_body.dart';

class LoginViewBodyBlocConsumer extends StatelessWidget {
  const LoginViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          }
          if (state is LoginFailure) {
            failuerTopSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          return CustomProgrssHud(
            isLoading: state is LoginLoading,
            child: const LoginViewBody(),
          );
        },
      ),
    );
  }
}
