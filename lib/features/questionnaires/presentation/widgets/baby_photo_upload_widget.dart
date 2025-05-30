import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BabyPhotoUploadWidget extends StatelessWidget {
  final File? selectedImage;
  final String? uploadedImageUrl;
  final bool isUploading;
  final bool isUploaded;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const BabyPhotoUploadWidget({
    super.key,
    required this.selectedImage,
    required this.isUploading,
    required this.isUploaded,
    required this.onTap,
    this.uploadedImageUrl,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: isUploading ? null : onTap,
          child: Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE0E0E0),
              border: Border.all(color: const Color(0xFFD3D3D3), width: 2.0),
              boxShadow: [
                if (_hasImage() && !isUploading)
                  BoxShadow(
                    color: Colors.green.withValues(alpha: .3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: _buildImageContent(),
          ),
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getStatusText(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: _getStatusColor(),
              ),
            ),
            if (_hasImage() && onDelete != null && !isUploading) ...[
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _showDeleteConfirmation(context),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade50,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildImageContent() {
    if (isUploading) {
      return Stack(
        alignment: Alignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Uploading...',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      );
    }

    // Priority: Local selected image > Uploaded image URL > Placeholder
    if (selectedImage != null) {
      return ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              selectedImage!,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const _EmptyPhotoPlaceholder(),
            ),
            // تأثير بصري للصورة المختارة محلياً
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2),
              ),
            ),
          ],
        ),
      );
    }

    if (uploadedImageUrl != null && uploadedImageUrl!.isNotEmpty) {
      return ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: uploadedImageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => const _LoadingImagePlaceholder(),
              errorWidget:
                  (context, url, error) => const _EmptyPhotoPlaceholder(),
            ),
            // علامة التأكيد للصورة المرفوعة
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),
            ),
          ],
        ),
      );
    }

    return const _EmptyPhotoPlaceholder();
  }

  String _getStatusText() {
    if (isUploading) {
      return 'Uploading to profile...';
    }

    if (uploadedImageUrl != null && uploadedImageUrl!.isNotEmpty) {
      return 'Photo saved to profile';
    }

    if (selectedImage != null) {
      return 'Photo selected, tap to upload';
    }

    return 'Add photo (optional)';
  }

  Color _getStatusColor() {
    if (isUploading) {
      return Colors.orange;
    } else if (uploadedImageUrl != null && uploadedImageUrl!.isNotEmpty) {
      return Colors.green;
    } else if (selectedImage != null) {
      return Colors.blue;
    } else {
      return Colors.black87;
    }
  }

  bool _hasImage() {
    return selectedImage != null ||
        (uploadedImageUrl != null && uploadedImageUrl!.isNotEmpty);
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Photo'),
          content: const Text(
            'Are you sure you want to delete this photo? This will also remove it from your profile.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete?.call();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyPhotoPlaceholder extends StatelessWidget {
  const _EmptyPhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(
          Icons.camera_alt_outlined,
          size: 60.0,
          color: Color(0xFF999da3),
        ),
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: Container(
            width: 30.0,
            height: 30.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFD3D3D3),
            ),
            child: const Icon(Icons.add, color: Color(0xFF757575), size: 18.0),
          ),
        ),
      ],
    );
  }
}

class _LoadingImagePlaceholder extends StatelessWidget {
  const _LoadingImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      color: Colors.grey.shade200,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      ),
    );
  }
}
