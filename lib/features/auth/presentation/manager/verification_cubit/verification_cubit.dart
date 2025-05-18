// في lib/features/auth/presentation/manager/verification_cubit/verification_cubit.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strongerkiddos/core/services/firebase_auth_service.dart';
import 'package:strongerkiddos/core/services/get_it_service.dart';
import 'verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  VerificationCubit() : super(VerificationInitial());

  final FirebaseAuthService _authService = getIt<FirebaseAuthService>();
  Timer? _timer;

  // بدء التحقق التلقائي من البريد الإلكتروني
  void startEmailVerificationCheck() {
    emit(VerificationLoading());

    // التحقق كل 5 ثوانٍ من حالة التوثيق
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkEmailVerification();
    });

    emit(VerificationInitial());
  }

  // التحقق اليدوي من حالة البريد الإلكتروني
  Future<void> checkEmailVerification() async {
    emit(VerificationLoading());

    try {
      final isVerified = await _authService.checkEmailVerification();

      if (isVerified) {
        _timer?.cancel();
        _timer = null;
        emit(VerificationSuccess());
      } else {
        emit(VerificationPending());
      }
    } catch (e) {
      emit(VerificationFailure(message: e.toString()));
    }
  }

  // إعادة إرسال رابط التحقق
  Future<void> resendVerificationEmail() async {
    emit(VerificationLoading());

    try {
      await _authService.resendVerificationEmail();
      emit(ResendVerificationEmailSuccess());
    } catch (e) {
      emit(VerificationFailure(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _timer = null;
    return super.close();
  }
}
