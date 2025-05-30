import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/utils/app_colors.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final VoidCallback? onTap;
  final bool showEditIcon;
  final Color? borderColor;
  final double borderWidth;

  const ProfileImageWidget({
    super.key,
    this.imageUrl,
    this.size = 60,
    this.onTap,
    this.showEditIcon = false,
    this.borderColor,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor ?? AppColors.fabBackgroundColor,
                width: borderWidth,
              ),
            ),
            child: ClipOval(child: _buildImageContent()),
          ),
          if (showEditIcon)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: size * 0.3,
                height: size * 0.3,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.fabBackgroundColor,
                ),
                child: Icon(Icons.edit, color: Colors.white, size: size * 0.15),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildLoadingWidget(),
        errorWidget: (context, url, error) => _buildPlaceholderIcon(),
      );
    }

    return _buildPlaceholderIcon();
  }

  Widget _buildLoadingWidget() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: SizedBox(
          width: size * 0.3,
          height: size * 0.3,
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      color: Colors.grey.shade200,
      child: Icon(Icons.person, size: size * 0.5, color: Colors.grey.shade400),
    );
  }
}

// Helper class for different sizes
class ProfileImageSizes {
  static const double small = 40;
  static const double medium = 60;
  static const double large = 80;
  static const double extraLarge = 120;
}
