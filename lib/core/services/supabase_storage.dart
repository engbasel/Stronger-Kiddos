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

  static Future<void> createBuckets(String bucketName) async {
    try {
      // Check if bucket already exists
      if (await _bucketExists(bucketName)) {
        log('Bucket $bucketName already exists, skipping creation');
        return;
      }
      await _supabaseStorageService.client.storage.createBucket(bucketName);
      log('Bucket $bucketName created successfully');
    } on StorageException catch (e) {
      if (e.message.contains('Duplicate') || e.statusCode == '409') {
        log('Bucket $bucketName already exists');
      } else {
        log('Error creating bucket $bucketName: $e');
        // Optionally rethrow for critical errors
        // rethrow;
      }
    } catch (e) {
      log('Unexpected error creating bucket $bucketName: $e');
    }
  }

  @override
  Future<String> uploadFile(File file, String path) async {
    try {
      String fileName = b.basename(file.path);
      String extensionName = b.extension(file.path);
      final String filePath = '$path/$fileName$extensionName';

      // Upload file
      await _supabaseStorageService.client.storage
          .from('baby-photos')
          .upload(filePath, file);

      // Get public URL
      final String publicUrl = _supabaseStorageService.client.storage
          .from('baby-photos')
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }
}
