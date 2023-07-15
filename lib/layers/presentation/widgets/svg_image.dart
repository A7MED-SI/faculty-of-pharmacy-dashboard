import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgImage extends StatelessWidget {
  const SvgImage(
    this.assetName, {
    super.key,
    this.color,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.semanticLabel,
  });

  final String assetName;
  final Color? color;
  final double? height;
  final double? width;
  final BoxFit fit;
  final String? semanticLabel;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      color: color,
      height: height,
      width: width,
      fit: fit,
    );
  }
}
