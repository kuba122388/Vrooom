import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/configs/assets/app_vectors.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';

import '../../../../core/configs/theme/app_spacing.dart';

class SettingsTile extends StatelessWidget {
  final AppSvg icon;
  final String label;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: InkWell(
            onTap: onTap,
            child: Row(
              children: [
                icon,
                const SizedBox(width: AppSpacing.md),
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                  ),
                ),
                const Spacer(),
                const AppSvg(
                  asset: AppVectors.navigateRightIcon,
                  height: 18.0,
                )
              ],
            ),
          ),
        ),
        Divider(
          color: AppColors.container.neutral700,
          height: 1,
        ),
      ],
    );
  }
}
