import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Widget gambar makanan dari URL jaringan dengan placeholder dan fallback.
class FoodNetworkImage extends StatelessWidget {
  const FoodNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderIcon = Icons.fastfood,
    this.placeholderIconSize = 40,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final IconData placeholderIcon;
  final double placeholderIconSize;

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => _placeholder(),
      errorWidget: (context, url, error) => _placeholder(),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFE8F5EE),
      child: Icon(
        placeholderIcon,
        color: Colors.grey,
        size: placeholderIconSize,
      ),
    );
  }
}
