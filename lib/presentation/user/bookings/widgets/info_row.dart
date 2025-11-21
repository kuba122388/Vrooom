import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';

class InfoRow extends StatelessWidget {
  final String title;
  final String? icon;
  final double iconSize;
  final String? text;
  final Color color;
  final TextAlign? textAlign;

  const InfoRow({
    super.key,
    required this.title,
    this.icon,
    this.text,
    this.color = Colors.white,
    this.textAlign,
    this.iconSize = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: TextStyle(color: color)),
        const Spacer(),
        if (icon != null) ...{
          AppSvg(
            asset: icon as String,
            color: color,
            height: iconSize,
          )
        },
        const SizedBox(width: AppSpacing.xs),
        if (text != null) ...{
          Text(
            text as String,
            style: TextStyle(
              color: color,
            ),
            textAlign: textAlign,
          )
        }
      ],
    );
  }
}
