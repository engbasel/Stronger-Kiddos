import 'dart:convert';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app_constants.dart';
import '../../../../../core/services/shared_preferences_sengleton.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/repos/auth_repo.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.authRepo) : super(LoginInitial());
  final AuthRepo authRepo;
  // تسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      // تحقق من حالة الاتصال
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none) ||
          connectivityResult.isEmpty) {
        // تحقق من وجود بيانات مخزنة للمستخدم
        final savedUserJson = Prefs.getString(AppConstants.kUserData);
        if (savedUserJson.isNotEmpty) {
          try {
            final userData = jsonDecode(savedUserJson);
            final user = UserModel.fromJson(userData);

            // يمكن إضافة منطق إضافي للتحقق من البريد وكلمة المرور محليًا
            if (user.email == email) {
              emit(LoginOffline(cachedUser: user));
              return;
            }
          } catch (e) {
            log('Error parsing saved user data: $e');
          }
        }
        emit(const LoginFailure(message: 'No internet connection.'));
        return;
      }

      final result = await authRepo.signInWithEmailAndPassword(email, password);
      result.fold(
        (failure) => emit(LoginFailure(message: failure.message)),
        (user) => emit(LoginSuccess(user: user)),
      );
    } catch (e) {
      emit(LoginFailure(message: 'There was an error: ${e.toString()}'));
    }
  }

  // تسجيل الدخول باستخدام حساب جوجل
  Future<void> signInWithGoogle() async {
    emit(LoginLoading());

    try {
      // تحقق من حالة الاتصال
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none) ||
          connectivityResult.isEmpty) {
        emit(const LoginFailure(message: 'No internet connection.'));
        return;
      }

      final result = await authRepo.signInWithGoogle();
      result.fold(
        (failure) => emit(LoginFailure(message: failure.message)),
        (user) => emit(GoogleLoginSuccess(user: user)),
      );
    } catch (e) {
      emit(LoginFailure(message: 'There was an error: ${e.toString()}'));
    }
  }

  // إرسال رابط إعادة تعيين كلمة المرور
  Future<void> sendPasswordResetLink({required String email}) async {
    emit(LoginLoading());

    try {
      // تحقق من حالة الاتصال
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none) ||
          connectivityResult.isEmpty) {
        emit(const LoginFailure(message: 'No internet connection.'));
        return;
      }

      final result = await authRepo.sendPasswordResetLink(email);
      result.fold(
        (failure) => emit(LoginFailure(message: failure.message)),
        (_) => emit(PasswordResetEmailSent()),
      );
    } catch (e) {
      emit(LoginFailure(message: 'There was an error: ${e.toString()}'));
    }
  }
}
