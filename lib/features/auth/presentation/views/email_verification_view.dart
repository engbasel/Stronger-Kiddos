import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strongerkiddos/core/services/get_it_service.dart';
import 'package:strongerkiddos/features/auth/domain/repos/auth_repo.dart';
import 'package:strongerkiddos/features/auth/presentation/manager/email_verification_cubit/email_verification_cubit.dart';
import 'package:strongerkiddos/features/auth/presentation/widgets/email_verification_view_body.dart';

class EmailVerificationView extends StatelessWidget {
  const EmailVerificationView({super.key});
  static const String routeName = '/email-verification';

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return BlocProvider(
      create:
          (context) =>
              EmailVerificationCubit(getIt.get<AuthRepo>())
                ..startVerificationCheck(),
      child: EmailVerificationViewBody(email: email),
    );
  }
}
