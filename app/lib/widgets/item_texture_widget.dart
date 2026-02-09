import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/vanilla_item.dart';

/// Widget that displays an item's texture from the fabrik-library repository
/// with emoji fallback if the image fails to load or doesn't exist.
///
/// Features:
/// - Memory-only caching (cleared on app close)
/// - Emoji fallback on error
/// - Loading indicator while fetching
/// - Customizable size
class ItemTextureWidget extends StatelessWidget {
  final VanillaItem item;
  final double size;
  final BoxFit fit;

  const ItemTextureWidget({
    super.key,
    required this.item,
    this.size = 48.0,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    // If no texture URL, show emoji
    if (!item.hasTexture || item.textureUrl == null) {
      return _buildEmojiFallback();
    }

    return CachedNetworkImage(
      imageUrl: item.textureUrl!,
      width: size,
      height: size,
      fit: fit,
      // Memory-only cache (cleared on app close)
      cacheKey: item.textureUrl,
      memCacheWidth: (size * 2).toInt(), // 2x for retina displays
      memCacheHeight: (size * 2).toInt(),
      // Loading indicator
      placeholder: (context, url) => SizedBox(
        width: size,
        height: size,
        child: Center(
          child: SizedBox(
            width: size * 0.5,
            height: size * 0.5,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      ),
      // Error fallback to emoji
      errorWidget: (context, url, error) => _buildEmojiFallback(),
    );
  }

  /// Build emoji fallback widget
  Widget _buildEmojiFallback() {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Text(
          item.emoji,
          style: TextStyle(
            fontSize: size * 0.6, // 60% of size for emoji
          ),
        ),
      ),
    );
  }
}

/// Simplified version that just shows texture or emoji (no loading state)
/// Useful for smaller icons where loading indicator would be too small
class ItemTextureIconWidget extends StatelessWidget {
  final VanillaItem item;
  final double size;

  const ItemTextureIconWidget({
    super.key,
    required this.item,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    // If no texture URL, show emoji
    if (!item.hasTexture || item.textureUrl == null) {
      return _buildEmojiFallback();
    }

    return CachedNetworkImage(
      imageUrl: item.textureUrl!,
      width: size,
      height: size,
      fit: BoxFit.contain,
      cacheKey: item.textureUrl,
      memCacheWidth: (size * 2).toInt(),
      memCacheHeight: (size * 2).toInt(),
      // No loading indicator for small icons
      placeholder: (context, url) => _buildEmojiFallback(),
      errorWidget: (context, url, error) => _buildEmojiFallback(),
    );
  }

  Widget _buildEmojiFallback() {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Text(
          item.emoji,
          style: TextStyle(
            fontSize: size * 0.7,
          ),
        ),
      ),
    );
  }
}
