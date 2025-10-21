import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';

class CarFeatureContainer extends StatelessWidget {
  final String iconPath;
  final String label;

  const CarFeatureContainer({
    super.key,
    required this.iconPath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0), color: AppColors.container.neutral750),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSvg(
              asset: iconPath,
              color: AppColors.primary,
              height: 15.0,
            ),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Roboto',
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
