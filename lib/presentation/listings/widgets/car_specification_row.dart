import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';

class CarSpecRow extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;

  const CarSpecRow({
    super.key,
    required this.iconPath,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          AppSvg(
            asset: iconPath,
            color: AppColors.primary,
            height: 18.0,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(label),
          const Spacer(),
          Text(value),
        ],
      ),
    );
  }
}
