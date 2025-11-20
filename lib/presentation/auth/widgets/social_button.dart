import 'package:flutter/material.dart';

import '../../../../core/configs/theme/app_colors.dart';
import '../../../core/common/widgets/app_svg.dart';
import '../../../core/configs/theme/app_spacing.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback? onTap;

  const SocialButton({super.key, required this.text, this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: AppColors.container.neutral900,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: AppColors.container.neutral700),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppSvg(
                asset: icon,
                color: Colors.transparent,
                height: 24,
              ),
              const SizedBox(
                width: AppSpacing.xs,
              ),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
