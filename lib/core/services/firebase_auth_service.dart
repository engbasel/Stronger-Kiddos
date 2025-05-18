import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../errors/exceptions.dart';

class FirebaseAuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final messaging = FirebaseMessaging.instance;
  User? get currentUser => firebaseAuth.currentUser;

  /// دالة لحفظ التوكن
  // In firebase_auth_service.dart
  Future<void> saveUserToken(String token) async {
    final firestore = FirebaseFirestore.instance;
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      try {
        // Get current user questionnaire status
        bool hasCompletedQuestionnaire = false;
        try {
          final docSnapshot =
              await firestore.collection('questionnaires').doc(userId).get();
          hasCompletedQuestionnaire = docSnapshot.exists;
        } catch (e) {
          log('Error checking questionnaire status: $e');
        }

        // Save token with additional user metadata
        await firestore.collection('userTokens').doc(userId).set({
          'token': token,
          'userId': userId,
          'hasCompletedQuestionnaire': hasCompletedQuestionnaire,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        log('Token saved successfully for user $userId');
      } catch (e) {
        // More detailed error logging
        log('Failed to save token: ${e.toString()}');
        // Continue with auth flow despite token saving error
      }
    } else {
      log('User is not logged in, skipping token save.');
    }
  }

  /// Improved method to fetch and save token with retries
  Future<void> fetchAndSaveToken() async {
    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        final token = await messaging.getToken();
        if (token != null) {
          await saveUserToken(token);
          log('Token fetched and saved successfully: $token');
          return; // Success - exit the method
        } else {
          log('Failed to fetch token. Token is null.');
        }
      } catch (e) {
        log('Error fetching and saving token (attempt ${retryCount + 1}): $e');
      }

      // Wait before retry
      await Future.delayed(Duration(seconds: 2));
      retryCount++;
    }

    log('Failed to fetch and save token after $maxRetries attempts');
  }

  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // إرسال بريد التحقق
      await credential.user!.sendEmailVerification();

      await fetchAndSaveToken();

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log('Exception in createUserWithEmailAndPassword: ${e.toString()}');
      if (e.code == 'weak-password') {
        throw CustomExceptions(message: 'The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw CustomExceptions(message: 'The email address is already in use.');
      } else if (e.code == 'invalid-email') {
        throw CustomExceptions(message: 'Invalid email format.');
      } else if (e.code == 'network-request-failed') {
        throw CustomExceptions(
          message: 'No internet connection. Please try again later.',
        );
      } else {
        throw CustomExceptions(message: 'An unexpected error occurred.');
      }
    } catch (e) {
      log('Exception in createUserWithEmailAndPassword: ${e.toString()}');
      throw CustomExceptions(message: 'An unexpected error occurred.');
    }
  }

  /// تسجيل الدخول باستخدام الإيميل والباسورد
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await fetchAndSaveToken(); // استدعاء الدالة المشتركة

      if (credential.user != null && !credential.user!.emailVerified) {
        await firebaseAuth.signOut();
        throw CustomExceptions(
          message: 'Email not verified. Please check your inbox.',
        );
      }

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log('Exception in signInWithEmailAndPassword: ${e.toString()}');
      if (e.code == 'user-not-found') {
        throw CustomExceptions(message: 'User not found.');
      } else if (e.code == 'wrong-password') {
        throw CustomExceptions(message: 'Incorrect password.');
      } else if (e.code == 'network-request-failed') {
        throw CustomExceptions(
          message: 'No internet connection. Please try again later.',
        );
      } else {
        throw CustomExceptions(message: 'An unexpected error occurred.');
      }
    } catch (e) {
      log('Exception in signInWithEmailAndPassword: ${e.toString()}');
      throw CustomExceptions(message: 'An unexpected error occurred.');
    }
  }

  /// تسجيل الدخول باستخدام Google
  // في firebase_auth_service.dart
  Future<User> signInWithGoogle() async {
    // Sign out first to ensure the account selection dialog appears every time
    await GoogleSignIn().signOut();

    // Now proceed with the sign-in flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    try {
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user != null && !user.emailVerified) {
        log('Google account not verified: ${user.email}');
      }

      await fetchAndSaveToken();

      return user!;
    } on FirebaseAuthException catch (e) {
      log('Exception in signInWithGoogle: ${e.toString()}');
      if (e.code == 'account-exists-with-different-credential') {
        throw CustomExceptions(
          message: 'Account already exists with different credentials.',
        );
      } else {
        throw CustomExceptions(message: 'An unexpected error occurred.');
      }
    } catch (e) {
      log('Exception in signInWithGoogle: ${e.toString()}');
      throw CustomExceptions(message: 'An unexpected error occurred.');
    }
  }

  // في firebase_auth_service.dart
  Future<bool> checkEmailVerification() async {
    User? user = firebaseAuth.currentUser;

    if (user == null) {
      return false;
    }

    // إعادة تحميل معلومات المستخدم لضمان أحدث حالة
    await user.reload();
    user = firebaseAuth.currentUser; // تحديث المرجع بعد الإعادة

    return user?.emailVerified ?? false;
  }

  // دالة لإعادة إرسال بريد التحقق
  Future<void> resendVerificationEmail() async {
    User? user = firebaseAuth.currentUser;

    if (user == null) {
      throw CustomExceptions(message: 'No user logged in.');
    }

    if (user.emailVerified) {
      throw CustomExceptions(message: 'Email is already verified.');
    }

    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      log('Exception in resendVerificationEmail: ${e.toString()}');
      if (e.code == 'too-many-requests') {
        throw CustomExceptions(
          message: 'Too many requests. Please try again later.',
        );
      } else {
        throw CustomExceptions(
          message: e.message ?? 'Failed to send verification email.',
        );
      }
    } catch (e) {
      log('Exception in resendVerificationEmail: ${e.toString()}');
      throw CustomExceptions(
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// إرسال رابط إعادة تعيين كلمة المرور
  Future<void> sendPasswordResetLink({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      log('Exception in sendPasswordResetLink: ${e.toString()}');
      if (e.code == 'invalid-email') {
        throw CustomExceptions(message: 'Invalid email format.');
      } else {
        throw CustomExceptions(
          message: e.message ?? 'An unexpected error occurred.',
        );
      }
    } catch (e) {
      log('Exception in sendPasswordResetLink: ${e.toString()}');
      throw CustomExceptions(message: 'An unexpected error occurred.');
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  Future<void> deleteUser() async {
    try {
      if (firebaseAuth.currentUser != null) {
        await firebaseAuth.currentUser!.delete();
      } else {
        throw CustomExceptions(message: 'No user currently logged in.');
      }
    } catch (e) {
      log('Exception in deleteUser: ${e.toString()}');
      throw CustomExceptions(message: 'Failed to delete user.');
    }
  }

  bool isLoggedIn() {
    return firebaseAuth.currentUser != null;
  }
}
