import 'dart:io';
import 'package:flutter/material.dart';

class BabyPhotoUploadWidget extends StatelessWidget {
  final File? selectedImage;
  final bool isUploading;
  final bool isUploaded;
  final VoidCallback onTap;

  const BabyPhotoUploadWidget({
    super.key,
    required this.selectedImage,
    required this.isUploading,
    required this.isUploaded,
    required this.onTap,
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
        Text(
          _getStatusText(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: _getStatusColor(),
          ),
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
    } else if (selectedImage != null) {
      return ClipOval(child: Image.file(selectedImage!, fit: BoxFit.cover));
    } else {
      return const _EmptyPhotoPlaceholder();
    }
  }

  String _getStatusText() {
    if (isUploading) {
      return 'Uploading...';
    } else if (selectedImage != null) {
      return 'Photo selected';
    } else {
      return 'Add photo (optional)';
    }
  }

  Color _getStatusColor() {
    if (isUploading) {
      return Colors.orange;
    } else if (isUploaded) {
      return Colors.green;
    } else {
      return Colors.black87;
    }
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
