import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerificationService {
  static Future<bool> verifyEmail(String verificationCode) async {
    try {
      // In a real implementation, you'd validate the verification code
      // For now, we'll assume the code is valid if the current user exists
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Mark as verified in your database
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'isEmailVerified': true, 'userStat': 'active'});

        log('Email verification successful for user: ${user.email}');
        return true;
      }
      return false;
    } catch (e) {
      log('Error verifying email: $e');
      return false;
    }
  }
}
