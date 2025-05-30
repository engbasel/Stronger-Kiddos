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
                onTap: onDelete,
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
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      );
    }

    // Priority: Local selected image > Uploaded image URL > Placeholder
    if (selectedImage != null) {
      return ClipOval(
        child: Image.file(
          selectedImage!,
          fit: BoxFit.cover,
          width: 120,
          height: 120,
        ),
      );
    }

    if (uploadedImageUrl != null && uploadedImageUrl!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: uploadedImageUrl!,
          fit: BoxFit.cover,
          width: 120,
          height: 120,
          placeholder: (context, url) => const _LoadingImagePlaceholder(),
          errorWidget: (context, url, error) => const _EmptyPhotoPlaceholder(),
        ),
      );
    }

    return const _EmptyPhotoPlaceholder();
  }

  String _getStatusText() {
    if (isUploading) {
      return 'Uploading...';
    }

    if (uploadedImageUrl != null && uploadedImageUrl!.isNotEmpty) {
      return 'Photo uploaded';
    }

    if (selectedImage != null) {
      return 'Photo selected';
    }

    return 'Add photo (optional)';
  }

  Color _getStatusColor() {
    if (isUploading) {
      return Colors.orange;
    } else if (isUploaded ||
        (uploadedImageUrl != null && uploadedImageUrl!.isNotEmpty)) {
      return Colors.green;
    } else {
      return Colors.black87;
    }
  }

  bool _hasImage() {
    return selectedImage != null ||
        (uploadedImageUrl != null && uploadedImageUrl!.isNotEmpty);
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
