import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strongerkiddos/app_router.dart';
import 'package:strongerkiddos/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:strongerkiddos/features/splash/presentation/views/splash_view.dart';
import 'package:strongerkiddos/features/authentication/presentation/login/login_view.dart';
import 'package:strongerkiddos/features/home/presentation/views/home_view.dart';
import 'core/services/injection_container.dart';
import 'features/authentication/presentation/manager/cubit/auth_cubit.dart';
import 'features/authentication/presentation/manager/cubit/auth_state.dart';

class StrongerKiddos extends StatelessWidget {
  const StrongerKiddos({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => sl<AuthCubit>()..checkAuth(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stronger Kiddos',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFF9B356),
            primary: const Color(0xFFF9B356),
          ),
        ),
        home: const AuthWrapper(),
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'An error occurred')),
          );
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.initial:
          case AuthStatus.loading:
            return const SplashView();
          case AuthStatus.authenticated:
            return const HomeView();
          case AuthStatus.unauthenticated:
            return const Onboardingview();
          case AuthStatus.error:
            // On error, show login screen
            return const Loginview();
        }
      },
    );
  }
}
