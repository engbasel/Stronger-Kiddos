import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:strongerkiddos/core/errors/exceptions.dart';
import 'package:strongerkiddos/features/authentication/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
  );
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithApple();
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<bool> isSignedIn();
  Future<UserModel?> getCurrentUser();
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(UserModel) onVerificationCompleted,
    required void Function(String) onVerificationFailed,
    required void Function(String, int?) onCodeSent,
    required void Function(String) onCodeAutoRetrievalTimeout,
  });

  Future<UserModel> verifyOTP({
    required String verificationId,
    required String otp,
  });
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  }) : _firebaseAuth = firebaseAuth,
       _googleSignIn = googleSignIn;

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw AuthException(message: 'User is null after sign in');
      }

      return UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
        isEmailVerified: user.emailVerified,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message ?? 'Sign in failed');
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw AuthException(message: 'User is null after sign up');
      }

      // Update display name
      await user.updateDisplayName(name);

      return UserModel(
        id: user.uid,
        name: name,
        email: user.email ?? '',
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
        isEmailVerified: user.emailVerified,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message ?? 'Sign up failed');
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If user cancels the flow
      if (googleUser == null) {
        throw AuthException(message: 'Sign in cancelled by user');
      }

      try {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google credential
        final userCredential = await _firebaseAuth.signInWithCredential(
          credential,
        );
        final user = userCredential.user;

        if (user == null) {
          throw AuthException(message: 'User is null after Google sign in');
        }

        return UserModel(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          photoUrl: user.photoURL,
          phoneNumber: user.phoneNumber,
          isEmailVerified: user.emailVerified,
        );
      } catch (credentialError) {
        // If there's an issue with the credentials, try to sign out of Google
        await _googleSignIn.signOut();
        throw AuthException(
          message: 'Google sign-in credential error: $credentialError',
        );
      }
    } catch (e) {
      throw AuthException(message: 'Google sign-in error: ${e.toString()}');
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      User? user = _firebaseAuth.currentUser;

      if (user == null) {
        throw AuthException(message: 'No user is currently signed in');
      }

      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: e.message ?? 'Failed to send verification email',
      );
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  // Add method to check email verification status
  @override
  Future<bool> isEmailVerified() async {
    try {
      User? user = _firebaseAuth.currentUser;

      if (user == null) {
        return false;
      }

      // Reload user to get the latest status
      await user.reload();

      // Get fresh user instance after reload
      user = _firebaseAuth.currentUser;

      return user?.emailVerified ?? false;
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signInWithApple() async {
    try {
      // Perform the authorization request
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create an OAuthCredential
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase with the Apple credential
      final userCredential = await _firebaseAuth.signInWithCredential(
        oauthCredential,
      );
      final user = userCredential.user;

      if (user == null) {
        throw AuthException(message: 'User is null after Apple sign in');
      }

      // Combine first and last name if available
      String name = user.displayName ?? '';
      if (appleCredential.givenName != null ||
          appleCredential.familyName != null) {
        name =
            '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                .trim();
        // Update display name if we got it from Apple
        if (name.isNotEmpty) {
          await user.updateDisplayName(name);
        }
      }

      return UserModel(
        id: user.uid,
        name: name,
        email: user.email ?? '',
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
        isEmailVerified: user.emailVerified,
      );
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message ?? 'Reset password failed');
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<bool> isSignedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }

    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
      isEmailVerified: user.emailVerified,
    );
  }

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(UserModel) onVerificationCompleted,
    required void Function(String) onVerificationFailed,
    required void Function(String, int?) onCodeSent,
    required void Function(String) onCodeAutoRetrievalTimeout,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification completed (Android only)
          final userCredential = await _firebaseAuth.signInWithCredential(
            credential,
          );
          final user = userCredential.user;

          if (user == null) {
            throw AuthException(
              message: 'User is null after phone auth completed',
            );
          }

          final userModel = UserModel(
            id: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            photoUrl: user.photoURL,
            phoneNumber: user.phoneNumber,
            isEmailVerified: user.emailVerified,
          );

          onVerificationCompleted(userModel);
        },
        verificationFailed: (FirebaseAuthException e) {
          onVerificationFailed(e.message ?? 'Phone verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          onCodeAutoRetrievalTimeout(verificationId);
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel> verifyOTP({
    required String verificationId,
    required String otp,
  }) async {
    try {
      // Create credential
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      // Sign in with credential
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user == null) {
        throw AuthException(message: 'User is null after OTP verification');
      }

      return UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
        isEmailVerified: user.emailVerified,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message ?? 'OTP verification failed');
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }
}
