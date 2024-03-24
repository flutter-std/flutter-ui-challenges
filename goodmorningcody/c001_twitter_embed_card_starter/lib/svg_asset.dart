import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// All the SVG assets needed for this challenge
enum SvgAsset {
  comment('assets/icon_comment.svg', Color(0xFF4999E9)),
  heartBlue('assets/icon_heart_blue.svg', Color(0xFF70ABE6)),
  heartRed('assets/icon_heart_red.svg', Color(0xFFE5387F)),
  info('assets/icon_info.svg', Color(0xFF566370)),
  link('assets/icon_link.svg', Color(0xFF566370)),
  verified('assets/icon_verified.svg', Color(0xFF4999E9)),
  x('assets/icon_x.svg', Color(0xFF101419));

  const SvgAsset(this.path, this.color);
  final String path;
  final Color color;

  /// Helper method to preload all the SVGs (call this before runApp)
  static Future<void> preloadSVGs() async {
    for (final asset in values) {
      final loader = SvgAssetLoader(asset.path);
      await svg.cache.putIfAbsent(
        loader.cacheKey(null),
        () => loader.loadBytes(null),
      );
    }
  }
}
