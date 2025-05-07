import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/repos/auth_repo.dart';
import '../../../domain/entities/user_entity.dart';
part 'email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  final AuthRepo authRepo;
  Timer? _timer;

  EmailVerificationCubit(this.authRepo) : super(EmailVerificationInitial());

  void startVerificationCheck() {
    log('Starting verification check...');
    emit(CheckingVerification());
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      checkVerificationStatus();
    });
  }

  void stopVerificationCheck() {
    log('Stopping verification check...');
    _timer?.cancel();
    _timer = null;
  }

  Future<void> checkVerificationStatus() async {
    try {
      log('Checking email verification status...');

      // Force reload the current user to get the latest data
      await FirebaseAuth.instance.currentUser?.reload();

      final user = FirebaseAuth.instance.currentUser;
      log(
        'Current user: ${user?.email}, emailVerified: ${user?.emailVerified}',
      );

      if (user == null) {
        log('No current user found');
        emit(VerificationCheckFailed(message: 'No user logged in'));
        return;
      }

      // Get sign-in methods to check if this is a Google account
      final isGoogleAccount = user.providerData.any(
        (userInfo) => userInfo.providerId == 'google.com',
      );

      // Get the verification status from Firebase
      bool isVerified = user.emailVerified;
      log('Email verification status: $isVerified');

      // If this is a Google account and we haven't explicitly verified it yet
      if (isGoogleAccount) {
        final userData = await authRepo.getUserData(uid: user.uid);

        // Google accounts must go through our verification process
        // Only mark as verified if our database already says it's verified
        if (!userData.isEmailVerified) {
          log(
            'Google account requires app verification. Ignoring Firebase verification status.',
          );
          emit(EmailNotVerified());
          return;
        }
      }

      if (isVerified) {
        log('Email is verified! Updating database...');
        // Update our database to reflect the verified status
        try {
          final userData = await authRepo.getUserData(uid: user.uid);
          if (!userData.isEmailVerified) {
            // Update the email verified status in our database
            await authRepo.updateUserData(
              user: UserEntity(
                id: userData.id,
                name: userData.name,
                email: userData.email,
                phoneNumber: userData.phoneNumber,
                photoUrl: userData.photoUrl,
                profileImageUrl: userData.profileImageUrl,
                role: userData.role,
                createdAt: userData.createdAt,
                isEmailVerified: true, // Set to true when verified
                userStat: userData.userStat,
              ),
            );
            log('Database updated with verified status');
          }
        } catch (e) {
          log('Error updating database: $e');
        }

        stopVerificationCheck();
        emit(EmailVerified());
      } else {
        log('Email not verified yet');
        emit(EmailNotVerified());
      }
    } catch (e) {
      log('Error checking verification status: $e');
      emit(VerificationCheckFailed(message: e.toString()));
    }
  }

  Future<void> resendVerificationEmail() async {
    emit(ResendingVerificationEmail());
    try {
      log('Resending verification email...');
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        log('Verification email sent successfully');
        emit(VerificationEmailSent());
      } else {
        log('No user found to send verification email');
        emit(ResendVerificationFailed(message: 'User not found'));
      }
    } catch (e) {
      log('Error resending verification email: $e');
      emit(ResendVerificationFailed(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    stopVerificationCheck();
    return super.close();
  }
}
