import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as b;
import 'package:strongerkiddos/core/services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService implements StorageService {
  static late Supabase _supabaseStorageService;

  static void initialize(Supabase supabase) {
    _supabaseStorageService = supabase;
  }

  static Future<bool> _bucketExists(String bucketName) async {
    try {
      final buckets =
          await _supabaseStorageService.client.storage.listBuckets();
      return buckets.any((bucket) => bucket.name == bucketName);
    } catch (e) {
      log('Error checking bucket existence: $e');
      return false;
    }
  }

  static Future<void> createBuckets(List<String> bucketNames) async {
    for (String bucketName in bucketNames) {
      try {
        // Check if bucket already exists
        if (await _bucketExists(bucketName)) {
          log('Bucket $bucketName already exists, skipping creation');
          continue;
        }
        await _supabaseStorageService.client.storage.createBucket(bucketName);
        log('Bucket $bucketName created successfully');
      } on StorageException catch (e) {
        if (e.message.contains('Duplicate') || e.statusCode == '409') {
          log('Bucket $bucketName already exists');
        } else {
          log('Error creating bucket $bucketName: $e');
        }
      } catch (e) {
        log('Unexpected error creating bucket $bucketName: $e');
      }
    }
  }

  @override
  Future<String> uploadFile(File file, String path) async {
    try {
      // Extract the directory and file name separately
      final directory =
          path.contains('/') ? path.substring(0, path.lastIndexOf('/')) : '';
      final fileName = b.basename(file.path);
      final filePath = directory.isEmpty ? fileName : '$directory/$fileName';

      String bucketName;

      // Determine bucket based on path
      if (path.startsWith('users/profile-images')) {
        bucketName = 'user-profiles';
      } else if (path.startsWith('babies/photos')) {
        bucketName = 'baby-photos';
      } else {
        bucketName = 'baby-photos'; // Default bucket
      }

      log('Uploading file to bucket: $bucketName, path: $filePath');

      // Remove old file if exists (for profile images and baby photos)
      if (path.startsWith('users/profile-images') ||
          path.startsWith('babies/photos')) {
        try {
          await _supabaseStorageService.client.storage.from(bucketName).remove([
            filePath,
          ]);
          log('Old file removed: $filePath');
        } catch (e) {
          log('No old file to remove: $filePath');
        }
      }

      // Upload file
      await _supabaseStorageService.client.storage
          .from(bucketName)
          .upload(
            filePath,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      // Get public URL
      final String publicUrl = _supabaseStorageService.client.storage
          .from(bucketName)
          .getPublicUrl(filePath);

      log('File uploaded successfully. URL: $publicUrl');
      return publicUrl;
    } catch (e) {
      log('Error uploading file: $e');
      throw Exception('Failed to upload file: $e');
    }
  }

  @override
  Future<String> uploadUserProfileImage(File imageFile, String userId) async {
    try {
      // تحديد مسار الملف: users/profile-images/userId.jpg
      final String filePath = 'users/profile-images/$userId.jpg';

      log('Uploading profile image for user: $userId to path: $filePath');

      // حذف الصورة القديمة إن وجدت
      try {
        await _supabaseStorageService.client.storage
            .from('user-profiles')
            .remove([filePath]);
        log('Old profile image deleted for user: $userId');
      } catch (e) {
        log('No old image to delete for user: $userId');
      }

      // رفع الصورة الجديدة
      await _supabaseStorageService.client.storage
          .from('user-profiles')
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true, // يستبدل الصورة إذا كانت موجودة
            ),
          );

      // جلب الرابط العام
      final String publicUrl = _supabaseStorageService.client.storage
          .from('user-profiles')
          .getPublicUrl(filePath);

      log('Profile image uploaded successfully. URL: $publicUrl');
      return publicUrl;
    } catch (e) {
      log('Error uploading profile image: $e');
      throw Exception('Failed to upload profile image: $e');
    }
  }

  @override
  Future<void> deleteUserProfileImage(String userId) async {
    try {
      final String filePath = 'users/profile-images/$userId.jpg';

      await _supabaseStorageService.client.storage.from('user-profiles').remove(
        [filePath],
      );

      log('Profile image deleted for user: $userId');
    } catch (e) {
      log('Error deleting profile image: $e');
      throw Exception('Failed to delete profile image: $e');
    }
  }

  @override
  Future<String?> getUserProfileImageUrl(String userId) async {
    try {
      final String filePath = 'users/profile-images/$userId.jpg';

      // التحقق من وجود الملف
      final fileExists = await hasUserProfileImage(userId);
      if (!fileExists) return null;

      // جلب الرابط العام
      final String publicUrl = _supabaseStorageService.client.storage
          .from('user-profiles')
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      log('Error getting profile image URL: $e');
      return null;
    }
  }

  @override
  Future<bool> hasUserProfileImage(String userId) async {
    try {
      // محاولة جلب معلومات الملف
      final files = await _supabaseStorageService.client.storage
          .from('user-profiles')
          .list(
            path: 'users/profile-images',
            searchOptions: SearchOptions(search: '$userId.jpg', limit: 1),
          );

      return files.isNotEmpty;
    } catch (e) {
      log('Error checking if profile image exists: $e');
      return false;
    }
  }
}
