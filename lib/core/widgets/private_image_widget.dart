import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PrivateImageWidget extends StatelessWidget {
  final String? signedUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const PrivateImageWidget({
    super.key,
    required this.signedUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (signedUrl == null || signedUrl!.isEmpty) {
      return errorWidget ??
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image_not_supported),
          );
    }

    return CachedNetworkImage(
      imageUrl: signedUrl!,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      placeholder:
          (context, url) =>
              placeholder ??
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
      errorWidget:
          (context, url, error) =>
              errorWidget ??
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.error),
              ),
    );
  }
}
