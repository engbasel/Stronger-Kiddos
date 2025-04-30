// Update apple_button.dart in a similar way
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strongerkiddos/features/authentication/presentation/manager/cubit/auth_cubit.dart';
import 'package:strongerkiddos/features/authentication/presentation/manager/cubit/auth_state.dart';

Widget buildAppleButton() {
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
                    context.read<AuthCubit>().signInWithApple();
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          icon:
              isLoading
                  ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : const Icon(Icons.apple, size: 24),
          label: const Text(
            'Continue with Apple',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      );
    },
  );
}
