// Update the build_google_button.dart file
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strongerkiddos/features/authentication/presentation/manager/cubit/auth_cubit.dart';
import 'package:strongerkiddos/features/authentication/presentation/manager/cubit/auth_state.dart';

Widget buildGoogleButton() {
  return BlocBuilder<AuthCubit, AuthState>(
    builder: (context, state) {
      final isLoading = state.status == AuthStatus.loading;

      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed:
              isLoading
                  ? null
                  : () {
                    context.read<AuthCubit>().signInWithGoogle();
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade200,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          icon:
              isLoading
                  ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey.shade700,
                    ),
                  )
                  : Image.asset(
                    'assets/png/Google.png',
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffe4e7eb),
                        ),
                        child: const Center(
                          child: Text(
                            'G',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          label: const Text(
            'Continue with Google',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      );
    },
  );
}
