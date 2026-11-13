import 'package:cached_network_image/cached_network_image.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Category / subcategory image with disk cache + local icon fallback.
/// Never blocks the UI on a live network fetch for already-cached images.
class CategoryLogoImage extends StatelessWidget {
  const CategoryLogoImage({
    super.key,
    this.imageUrl,
    this.width = 32,
    this.height = 32,
    this.fit = BoxFit.cover,
    this.fallbackIcon,
  });

  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final IconData? fallbackIcon;

  static const _placeholderHosts = {
    'https://app.fedhatrac.com/images/categories',
    'https://app.fedhatrac.com/images/categories/',
  };

  bool get _hasUsableUrl {
    final url = imageUrl?.trim() ?? '';
    if (url.isEmpty) return false;
    if (_placeholderHosts.contains(url)) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final icon = fallbackIcon ?? LucideIcons.shapes;
    if (!_hasUsableUrl) {
      return _fallback(icon);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!.trim(),
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholder: (_, __) => _fallback(icon),
      errorWidget: (_, __, ___) => _fallback(icon),
    );
  }

  Widget _fallback(IconData icon) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppColors.primaryColor,
        size: (width * 0.5).clamp(12, 22),
      ),
    );
  }
}
