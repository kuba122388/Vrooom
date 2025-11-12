import 'package:flutter/material.dart';

import '../../configs/theme/app_colors.dart';
import '../../configs/theme/app_spacing.dart';
import 'app_svg.dart';

class FilterTile extends StatelessWidget {
  final String text;
  final String svgPicture;
  final bool isActive;

  const FilterTile({
    super.key,
    required this.text,
    required this.svgPicture,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withValues(alpha: 0.2) : Colors.black,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.container.neutral700,
        ),
      ),
      height: 40,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSvg(
              asset: svgPicture,
              color: isActive ? AppColors.primary : AppColors.svg.neutral400,
              height: 15.0,
            ),
            const SizedBox(width: AppSpacing.xxs),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  letterSpacing: -0.5,
                  color: isActive ? AppColors.primary : Colors.white,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}