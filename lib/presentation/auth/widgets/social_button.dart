import 'package:flutter/material.dart';

import '../../../../core/configs/theme/app_colors.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const SocialButton({super.key, required this.text, this.onTap});

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
          child: Center(child: Text(text)),
        ),
      ),
    );
  }
}
