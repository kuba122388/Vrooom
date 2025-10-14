import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppSvg extends StatelessWidget {
  final String asset;
  final double? height;
  final double? width;
  final Color color;

  const AppSvg({
    super.key,
    required this.asset,
    this.height,
    this.width,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
      height: height,
      width: width,
    );
  }
}
