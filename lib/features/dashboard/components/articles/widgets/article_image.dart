import 'package:cached_network_image/cached_network_image.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';

/// Branded cover image with a polished fallback when the URL fails.
class ArticleImage extends StatelessWidget {
  const ArticleImage({
    super.key,
    required this.url,
    required this.height,
    this.width,
    this.borderRadius = 14,
    this.heroTag,
  });

  final String url;
  final double height;
  final double? width;
  final double borderRadius;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: url,
        height: height,
        width: width ?? double.infinity,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 220),
        placeholder: (_, __) => _ShimmerBox(height: height, width: width),
        errorWidget: (_, __, ___) => ArticleImagePlaceholder(
          height: height,
          width: width,
          borderRadius: 0,
        ),
      ),
    );

    if (heroTag == null) return image;
    return Hero(tag: heroTag!, child: image);
  }
}

class ArticleImagePlaceholder extends StatelessWidget {
  const ArticleImagePlaceholder({
    super.key,
    required this.height,
    this.width,
    this.borderRadius = 14,
  });

  final double height;
  final double? width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkBlueColor,
            AppColors.darkGreenColor,
            AppColors.primaryColor.withValues(alpha: 0.85),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -18,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            left: -10,
            bottom: -20,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white.withValues(alpha: 0.92),
                  size: height < 90 ? 22 : 30,
                ),
                if (height >= 100) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Fedha',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({required this.height, this.width});
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      color: AppColors.darkBlueColor.withValues(alpha: 0.06),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryColor.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
