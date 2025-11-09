
import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';

class InfoRow extends StatelessWidget {
  final String title;
  final String? icon;
  final String? text;
  final Color color;

  const InfoRow({super.key, required this.title, this.icon, this.text, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: color
          )
        ),

        const Spacer(),

        if (icon != null) ... {
          AppSvg(
            asset: icon as String,
            color: color,
            height: 10,
          )
        },

        const SizedBox(width: AppSpacing.xxs),

        if (text != null) ... {
          Text(
            text as String,
            style: TextStyle(
                color: color
            )
          )
        }
      ],
    );
  }
}