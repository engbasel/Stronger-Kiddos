import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/get_it_service.dart';
import '../../domain/repos/auth_repo.dart';
import '../../persentation/manager/login_cubit/login_cubit.dart';
import '../widgets/login_view_body_bloc_consumer.dart'
    show LoginViewBodyBlocConsumer;

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(getIt.get<AuthRepo>()),
      child: LoginViewBodyBlocConsumer(),
    );
  }
}
