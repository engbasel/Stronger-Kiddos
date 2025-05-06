import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/repos/auth_repo.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepo authRepo;

  SignupCubit({required this.authRepo}) : super(SignupInitial());

  // التسجيل باستخدام البريد الإلكتروني وكلمة المرور
  Future<void> signupWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(SignupLoading());

    try {
      // تحقق من حالة الاتصال
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none) ||
          connectivityResult.isEmpty) {
        emit(const SignupFailure(message: 'No internet connection.'));
        return;
      }

      final result = await authRepo.createUserWithEmailAndPassword(
        email,
        password,
        name,
      );

      result.fold(
        (failure) => emit(SignupFailure(message: failure.message)),
        (user) => emit(EmailSignupSuccess(user: user)),
      );
    } catch (e) {
      emit(SignupFailure(message: 'There was an error: ${e.toString()}'));
    }
  }

  // التسجيل باستخدام حساب جوجل
  Future<void> signupWithGoogle() async {
    emit(SignupLoading());

    try {
      // تحقق من حالة الاتصال
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none) ||
          connectivityResult.isEmpty) {
        emit(const SignupFailure(message: 'No internet connection.'));
        return;
      }

      final result = await authRepo.signInWithGoogle();
      result.fold(
        (failure) => emit(SignupFailure(message: failure.message)),
        (user) => emit(GoogleSignupSuccess(user: user)),
      );
    } catch (e) {
      emit(SignupFailure(message: 'There was an error: ${e.toString()}'));
    }
  }

  // المصادقة عبر الهاتف - إرسال رمز التحقق
  Future<void> verifyPhoneNumber({required String phoneNumber}) async {
    emit(SignupLoading());

    try {
      // تحقق من حالة الاتصال
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none) ||
          connectivityResult.isEmpty) {
        emit(const SignupFailure(message: 'No internet connection.'));
        return;
      }

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // تم التحقق تلقائيًا (على أجهزة Android)
          await _signInWithPhoneCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(SignupFailure(message: e.message ?? 'فشل التحقق من الهاتف'));
        },
        codeSent: (String verificationId, int? resendToken) {
          // تم إرسال الرمز بنجاح
          emit(PhoneVerificationSent(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // انتهت مهلة استرداد الرمز تلقائيًا
          log('Auto retrieval timeout: $verificationId');
        },
      );
    } catch (e) {
      emit(SignupFailure(message: 'There was an error: ${e.toString()}'));
    }
  }

  // التحقق من الرمز المرسل إلى الهاتف
  Future<void> verifyOTP({
    required String verificationId,
    required String smsCode,
    required String name, // إضافة الاسم للمستخدم الجديد
  }) async {
    emit(SignupLoading());

    try {
      // تحقق من حالة الاتصال
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none) ||
          connectivityResult.isEmpty) {
        emit(const SignupFailure(message: 'No internet connection.'));
        return;
      }

      // إنشاء بيانات اعتماد باستخدام رمز التحقق
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await _signInWithPhoneCredential(credential, name: name);
    } catch (e) {
      emit(SignupFailure(message: 'There was an error: ${e.toString()}'));
    }
  }

  // تسجيل الدخول باستخدام بيانات اعتماد الهاتف
  Future<void> _signInWithPhoneCredential(
    PhoneAuthCredential credential, {
    String name = '', // إضافة اسم افتراضي
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        // إنشاء كائن مستخدم جديد
        final userData = UserModel(
          id: userCredential.user!.uid,
          name:
              name.isNotEmpty
                  ? name
                  : (userCredential.user!.displayName ?? 'user'),
          email: userCredential.user!.email ?? '',
          phoneNumber: userCredential.user!.phoneNumber,
          isEmailVerified: userCredential.user!.emailVerified,
        );

        // تحقق مما إذا كان المستخدم موجودًا بالفعل في قاعدة البيانات
        bool userExists = await _isUserExists(userCredential.user!.uid);

        if (!userExists) {
          // إضافة المستخدم إلى قاعدة البيانات إذا لم يكن موجودًا
          await authRepo.addUserData(user: userData);
        }

        emit(PhoneSignupSuccess(user: userData));
      } else {
        emit(const SignupFailure(message: 'Failed to sign in.'));
      }
    } on FirebaseAuthException catch (e) {
      emit(SignupFailure(message: e.message ?? 'Failed to sign in.'));
    } catch (e) {
      emit(SignupFailure(message: 'There was an error: ${e.toString()}'));
    }
  }

  // التحقق من وجود المستخدم
  Future<bool> _isUserExists(String uid) async {
    try {
      final docExists = await authRepo.getUserData(uid: uid);
      // ignore: unnecessary_null_comparison
      return docExists != null;
    } catch (e) {
      log('Error checking if user exists: $e');
      return false;
    }
  }
}
