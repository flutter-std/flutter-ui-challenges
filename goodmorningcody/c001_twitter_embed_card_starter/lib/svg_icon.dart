import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_embed_card/svg_asset.dart';

/// Helper widget to render a SVG picture from a given asset
class SvgIcon extends StatelessWidget {
  const SvgIcon({super.key, required this.asset, this.width, this.height});
  final SvgAsset asset;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset.path,
      colorFilter: ColorFilter.mode(asset.color, BlendMode.srcIn),
      width: width,
      height: height,
    );
  }
}
