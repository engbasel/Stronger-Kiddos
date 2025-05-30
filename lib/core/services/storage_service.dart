import 'dart:io';

abstract class StorageService {
  // رفع ملف عام
  Future<String> uploadFile(File file, String path);

  // رفع صورة بروفايل المستخدم
  Future<String> uploadUserProfileImage(File imageFile, String userId);

  // حذف صورة بروفايل المستخدم
  Future<void> deleteUserProfileImage(String userId);

  // جلب رابط صورة بروفايل المستخدم
  Future<String?> getUserProfileImageUrl(String userId);

  // التحقق من وجود صورة بروفايل للمستخدم
  Future<bool> hasUserProfileImage(String userId);
}
