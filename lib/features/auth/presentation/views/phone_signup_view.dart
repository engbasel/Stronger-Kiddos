import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/get_it_service.dart';
import '../../domain/repos/auth_repo.dart';
import '../manager/signup_cubit/signup_cubit.dart';
import '../widgets/phone_signup_view_body.dart';
import '../widgets/signin_view_body_bloc_consumer.dart';

class PhoneSignupView extends StatelessWidget {
  const PhoneSignupView({super.key});
  static const String routeName = '/phone-signup';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(getIt.get<AuthRepo>()),
      child: SignInViewBodyBlocConsumer(child: PhoneSignupViewBody()),
    );
  }
}
