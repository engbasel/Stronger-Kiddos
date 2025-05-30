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

      // ALL photos now go to baby-photos bucket
      const String bucketName = 'baby-photos';

      log('Uploading file to bucket: $bucketName, path: $filePath');

      // Remove old file if exists
      try {
        await _supabaseStorageService.client.storage.from(bucketName).remove([
          filePath,
        ]);
        log('Old file removed: $filePath');
      } catch (e) {
        log('No old file to remove: $filePath');
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
      // 🔥 User profile images now go to the SAME location as baby photos
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final String filePath = 'babies/photos/$userId-$timestamp.jpg';

      log('Uploading profile image for user: $userId to path: $filePath');

      // 🔥 حذف كل الصور القديمة للمستخدم (same location as baby photos)
      await _deleteAllPhotosForUser(userId);

      // رفع الصورة الجديدة - same location as baby photos
      await _supabaseStorageService.client.storage
          .from('baby-photos')
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      // جلب الرابط العام
      final String publicUrl = _supabaseStorageService.client.storage
          .from('baby-photos')
          .getPublicUrl(filePath);

      log('Profile image uploaded successfully. URL: $publicUrl');
      return publicUrl;
    } catch (e) {
      log('Error uploading profile image: $e');
      throw Exception('Failed to upload profile image: $e');
    }
  }

  // 🔥 دالة موحدة لحذف كل صور المستخدم (profile + baby) من نفس المكان
  Future<void> _deleteAllPhotosForUser(String userId) async {
    try {
      final files = await _supabaseStorageService.client.storage
          .from('baby-photos')
          .list(path: 'babies/photos');

      // البحث عن كل الملفات اللي تبدأ بـ userId
      final userFiles =
          files
              .where((file) => file.name.startsWith('$userId-'))
              .map((file) => 'babies/photos/${file.name}')
              .toList();

      if (userFiles.isNotEmpty) {
        await _supabaseStorageService.client.storage
            .from('baby-photos')
            .remove(userFiles);
        log('Deleted ${userFiles.length} old photos for user: $userId');
      }
    } catch (e) {
      log('Error deleting old photos: $e');
      // مانعملش throw عشان ماتأثرش على الرفع
    }
  }

  @override
  Future<void> deleteUserProfileImage(String userId) async {
    try {
      // 🔥 حذف من نفس مكان صور الأطفال
      await _deleteAllPhotosForUser(userId);
      log('All photos deleted for user: $userId');
    } catch (e) {
      log('Error deleting photos: $e');
      throw Exception('Failed to delete photos: $e');
    }
  }

  @override
  Future<String?> getUserProfileImageUrl(String userId) async {
    try {
      // 🔥 البحث عن آخر صورة للمستخدم من نفس مكان صور الأطفال
      final files = await _supabaseStorageService.client.storage
          .from('baby-photos')
          .list(path: 'babies/photos');

      // البحث عن كل الملفات اللي تبدأ بـ userId وترتيبهم حسب timestamp
      final userFiles =
          files.where((file) => file.name.startsWith('$userId-')).toList();

      if (userFiles.isEmpty) return null;

      // ترتيب الملفات حسب التاريخ (آخر واحد أول)
      userFiles.sort((a, b) {
        final timestampA = _extractTimestamp(a.name);
        final timestampB = _extractTimestamp(b.name);
        return timestampB.compareTo(timestampA); // descending order
      });

      // أخذ آخر ملف (الأحدث)
      final latestFile = userFiles.first;
      final String filePath = 'babies/photos/${latestFile.name}';

      // جلب الرابط العام
      final String publicUrl = _supabaseStorageService.client.storage
          .from('baby-photos')
          .getPublicUrl(filePath);

      log('Latest photo URL for user $userId: $publicUrl');
      return publicUrl;
    } catch (e) {
      log('Error getting photo URL: $e');
      return null;
    }
  }

  // 🔥 دالة لاستخراج timestamp من اسم الملف
  int _extractTimestamp(String fileName) {
    try {
      // fileName format: userId-timestamp.jpg
      final parts = fileName.split('-');
      if (parts.length >= 2) {
        final timestampPart = parts[1].split('.')[0]; // remove .jpg
        return int.parse(timestampPart);
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<bool> hasUserProfileImage(String userId) async {
    try {
      // 🔥 البحث في نفس مكان صور الأطفال
      final files = await _supabaseStorageService.client.storage
          .from('baby-photos')
          .list(path: 'babies/photos');

      final userFiles = files.where((file) => file.name.startsWith('$userId-'));
      return userFiles.isNotEmpty;
    } catch (e) {
      log('Error checking if photo exists: $e');
      return false;
    }
  }

  // 🔥 صور الأطفال - نفس المكان والطرق
  @override
  Future<String> uploadBabyPhoto(File imageFile, String userId) async {
    try {
      // 🔥 نفس المكان والطريقة تماماً مثل صور البروفايل
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final String filePath = 'babies/photos/$userId-$timestamp.jpg';

      log('Uploading baby photo for user: $userId to path: $filePath');

      // حذف كل الصور القديمة للمستخدم
      await _deleteAllPhotosForUser(userId);

      // رفع الصورة الجديدة
      await _supabaseStorageService.client.storage
          .from('baby-photos')
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      // جلب الرابط العام
      final String publicUrl = _supabaseStorageService.client.storage
          .from('baby-photos')
          .getPublicUrl(filePath);

      log('Baby photo uploaded successfully. URL: $publicUrl');
      return publicUrl;
    } catch (e) {
      log('Error uploading baby photo: $e');
      throw Exception('Failed to upload baby photo: $e');
    }
  }

  @override
  Future<void> deleteBabyPhoto(String userId) async {
    try {
      // 🔥 نفس دالة حذف صور البروفايل (unified)
      await _deleteAllPhotosForUser(userId);
      log('All photos deleted for user: $userId');
    } catch (e) {
      log('Error deleting photos: $e');
      throw Exception('Failed to delete photos: $e');
    }
  }

  @override
  Future<String?> getBabyPhotoUrl(String userId) async {
    try {
      // 🔥 نفس دالة جلب صور البروفايل (unified)
      return await getUserProfileImageUrl(userId);
    } catch (e) {
      log('Error getting baby photo URL: $e');
      return null;
    }
  }

  @override
  Future<bool> hasBabyPhoto(String userId) async {
    try {
      // 🔥 نفس دالة التحقق من صور البروفايل (unified)
      return await hasUserProfileImage(userId);
    } catch (e) {
      log('Error checking if baby photo exists: $e');
      return false;
    }
  }
}
