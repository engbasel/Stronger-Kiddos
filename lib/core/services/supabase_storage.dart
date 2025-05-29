import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as b;
import 'package:strongerkiddos/core/services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SupabaseStorageService implements StorageService {
  static late Supabase _supabaseStorageService;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

      // Create bucket with public access (easier for initial setup)
      await _supabaseStorageService.client.storage.createBucket(
        bucketName,
        const BucketOptions(public: true, allowedMimeTypes: ['image/*']),
      );
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

  @override
  Future<String> uploadFile(File file, String path) async {
    try {
      // Get current Firebase user
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      String fileName = b.basename(file.path);
      String extensionName = b.extension(file.path);
      final String filePath = '$path/$fileName$extensionName';

      log('Uploading file to: $filePath');

      // Read file as bytes
      final bytes = await file.readAsBytes();

      // Upload file with proper options
      await _supabaseStorageService.client.storage
          .from('baby-photos')
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(
              contentType: _getContentType(extensionName),
              upsert: true, // Allow overwriting
            ),
          );

      // Get public URL (since we made bucket public)
      final String publicUrl = _supabaseStorageService.client.storage
          .from('baby-photos')
          .getPublicUrl(filePath);

      log('File uploaded successfully. URL: $publicUrl');
      return publicUrl;
    } catch (e) {
      log('Upload error: $e');
      throw Exception('Failed to upload file: $e');
    }
  }

  // Helper method to get content type
  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  // Alternative method for private bucket with signed URLs
  Future<String> uploadFilePrivate(File file, String path) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      String fileName = b.basename(file.path);
      String extensionName = b.extension(file.path);
      final String filePath = 'private/$path/$fileName$extensionName';

      final bytes = await file.readAsBytes();

      await _supabaseStorageService.client.storage
          .from('baby-photos')
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(
              contentType: _getContentType(extensionName),
              upsert: true,
            ),
          );

      // Return the file path for private files
      return filePath;
    } catch (e) {
      log('Private upload error: $e');
      throw Exception('Failed to upload private file: $e');
    }
  }

  // Get signed URL for private files
  Future<String> getSignedUrl(String filePath, {int expiresIn = 3600}) async {
    try {
      final signedUrl = await _supabaseStorageService.client.storage
          .from('baby-photos')
          .createSignedUrl(filePath, expiresIn);
      return signedUrl;
    } catch (e) {
      log('Error creating signed URL: $e');
      throw Exception('Failed to create signed URL: $e');
    }
  }

  // Delete file
  Future<void> deleteFile(String filePath) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      await _supabaseStorageService.client.storage.from('baby-photos').remove([
        filePath,
      ]);

      log('File deleted successfully: $filePath');
    } catch (e) {
      log('Error deleting file: $e');
      throw Exception('Failed to delete file: $e');
    }
  }
}
