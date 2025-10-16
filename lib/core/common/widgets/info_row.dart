import 'package:flutter/material.dart';

import '../../configs/theme/app_colors.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final double? fontSize;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
