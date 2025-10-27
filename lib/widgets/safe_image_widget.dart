import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/error_handling_service.dart';

class SafeNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const SafeNetworkImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildErrorWidget();
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[300],
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: width,
          height: height,
          fit: fit,
          placeholder: (context, url) => _buildPlaceholder(),
          errorWidget: (context, url, error) {
            ErrorHandler.logError('Failed to load image: $url', error);
            return _buildErrorWidget();
          },
          memCacheWidth: width?.toInt(),
          memCacheHeight: height?.toInt(),
          maxWidthDiskCache: 800,
          maxHeightDiskCache: 800,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return placeholder ?? Container(
      color: Colors.grey[300],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return errorWidget ?? Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey,
          size: 32,
        ),
      ),
    );
  }
}

class SafeImageWithRetry extends StatefulWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final int maxRetries;

  const SafeImageWithRetry({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.backgroundColor,
    this.maxRetries = 3,
  });

  @override
  State<SafeImageWithRetry> createState() => _SafeImageWithRetryState();
}

class _SafeImageWithRetryState extends State<SafeImageWithRetry> {
  int _retryCount = 0;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      return _buildErrorWidget();
    }

    if (_hasError && _retryCount >= widget.maxRetries) {
      return _buildErrorWidget();
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.grey[300],
        borderRadius: widget.borderRadius,
      ),
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl!,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          placeholder: (context, url) => _buildPlaceholder(),
          errorWidget: (context, url, error) {
            ErrorHandler.logError('Failed to load image (attempt ${_retryCount + 1}): $url', error);
            _retryCount++;
            if (_retryCount < widget.maxRetries) {
              Future.delayed(Duration(seconds: _retryCount), () {
                if (mounted) {
                  setState(() {
                    _hasError = false;
                  });
                }
              });
            } else {
              _hasError = true;
            }
            return _buildErrorWidget();
          },
          memCacheWidth: widget.width?.toInt(),
          memCacheHeight: widget.height?.toInt(),
          maxWidthDiskCache: 800,
          maxHeightDiskCache: 800,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return widget.placeholder ?? Container(
      color: Colors.grey[300],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return widget.errorWidget ?? Container(
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.image_not_supported,
            color: Colors.grey,
            size: 32,
          ),
          if (_retryCount < widget.maxRetries) ...[
            const SizedBox(height: 8),
            Text(
              'Retrying...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ImageLoadingIndicator extends StatelessWidget {
  final double? size;
  final Color? color;

  const ImageLoadingIndicator({
    super.key,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size ?? 24,
        height: size ?? 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Colors.grey[600]!,
          ),
        ),
      ),
    );
  }
}
