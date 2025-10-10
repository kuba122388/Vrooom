import 'package:flutter/material.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/core/configs/theme/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    this.label,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.label,
          ),
          const SizedBox(height: AppSpacing.xs)
        ],
        TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}
