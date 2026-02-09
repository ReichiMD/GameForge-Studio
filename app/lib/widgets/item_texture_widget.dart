import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/vanilla_item.dart';
import '../services/debug_log_service.dart';

/// Widget that displays an item's texture from the fabrik-library repository
/// with emoji fallback if the image fails to load or doesn't exist.
///
/// Features:
/// - Memory-only caching (cleared on app close)
/// - Emoji fallback on error
/// - Loading indicator while fetching
/// - Customizable size
/// - Debug logging for troubleshooting
class ItemTextureWidget extends StatefulWidget {
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
  State<ItemTextureWidget> createState() => _ItemTextureWidgetState();
}

class _ItemTextureWidgetState extends State<ItemTextureWidget> {
  final _debugService = DebugLogService();
  bool _hasLoggedAttempt = false;

  @override
  void initState() {
    super.initState();
    // Log image load attempt if texture exists
    if (widget.item.hasTexture && widget.item.textureUrl != null) {
      _debugService.logImageLoadAttempt(widget.item.textureUrl!);
      _hasLoggedAttempt = true;
    } else {
      _debugService.addLog(
        level: 'INFO',
        category: 'NETWORK',
        message: 'Item has no texture URL, using emoji fallback',
        data: {
          'itemId': widget.item.id,
          'itemName': widget.item.name,
          'emoji': widget.item.emoji,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // If no texture URL, show emoji
    if (!widget.item.hasTexture || widget.item.textureUrl == null) {
      return _buildEmojiFallback();
    }

    return CachedNetworkImage(
      imageUrl: widget.item.textureUrl!,
      width: widget.size,
      height: widget.size,
      fit: widget.fit,
      // Memory-only cache (cleared on app close)
      cacheKey: widget.item.textureUrl,
      memCacheWidth: (widget.size * 4).toInt(), // 4x for high-res displays like Pixel 7
      memCacheHeight: (widget.size * 4).toInt(),
      // Loading indicator
      placeholder: (context, url) {
        _debugService.addLog(
          level: 'INFO',
          category: 'CACHE',
          message: 'Loading image from network',
          data: {
            'url': url,
            'itemId': widget.item.id,
            'itemName': widget.item.name,
          },
        );
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Center(
            child: SizedBox(
              width: widget.size * 0.5,
              height: widget.size * 0.5,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ),
        );
      },
      // Error fallback to emoji
      errorWidget: (context, url, error) {
        _debugService.logImageLoadError(
          url,
          error,
          stackTrace: StackTrace.current,
        );
        return _buildEmojiFallback();
      },
      // Success listener
      imageBuilder: (context, imageProvider) {
        if (_hasLoggedAttempt) {
          _debugService.logImageLoadSuccess(widget.item.textureUrl!);
          _hasLoggedAttempt = false; // Only log success once
        }
        return Image(
          image: imageProvider,
          width: widget.size,
          height: widget.size,
          fit: widget.fit,
          filterQuality: FilterQuality.high, // High-quality image rendering
          isAntiAlias: true, // Smooth edges
        );
      },
    );
  }

  /// Build emoji fallback widget
  Widget _buildEmojiFallback() {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Center(
        child: Text(
          widget.item.emoji,
          style: TextStyle(
            fontSize: widget.size * 0.6, // 60% of size for emoji
          ),
        ),
      ),
    );
  }
}

/// Simplified version that just shows texture or emoji (no loading state)
/// Useful for smaller icons where loading indicator would be too small
class ItemTextureIconWidget extends StatefulWidget {
  final VanillaItem item;
  final double size;

  const ItemTextureIconWidget({
    super.key,
    required this.item,
    this.size = 24.0,
  });

  @override
  State<ItemTextureIconWidget> createState() => _ItemTextureIconWidgetState();
}

class _ItemTextureIconWidgetState extends State<ItemTextureIconWidget> {
  final _debugService = DebugLogService();
  bool _hasLoggedAttempt = false;

  @override
  void initState() {
    super.initState();
    // Log image load attempt if texture exists
    if (widget.item.hasTexture && widget.item.textureUrl != null) {
      _debugService.logImageLoadAttempt(widget.item.textureUrl!);
      _hasLoggedAttempt = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // If no texture URL, show emoji
    if (!widget.item.hasTexture || widget.item.textureUrl == null) {
      return _buildEmojiFallback();
    }

    return CachedNetworkImage(
      imageUrl: widget.item.textureUrl!,
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
      cacheKey: widget.item.textureUrl,
      memCacheWidth: (widget.size * 4).toInt(), // 4x for high-res displays
      memCacheHeight: (widget.size * 4).toInt(),
      // No loading indicator for small icons
      placeholder: (context, url) => _buildEmojiFallback(),
      errorWidget: (context, url, error) {
        _debugService.logImageLoadError(url, error);
        return _buildEmojiFallback();
      },
      // Success listener
      imageBuilder: (context, imageProvider) {
        if (_hasLoggedAttempt) {
          _debugService.logImageLoadSuccess(widget.item.textureUrl!);
          _hasLoggedAttempt = false;
        }
        return Image(
          image: imageProvider,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high, // High-quality image rendering
          isAntiAlias: true, // Smooth edges
        );
      },
    );
  }

  Widget _buildEmojiFallback() {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Center(
        child: Text(
          widget.item.emoji,
          style: TextStyle(
            fontSize: widget.size * 0.7,
          ),
        ),
      ),
    );
  }
}
