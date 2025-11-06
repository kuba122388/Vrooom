import 'package:flutter/material.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/core/configs/theme/app_text_styles.dart';

import 'app_svg.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final AppSvg? leadingIcon;
  final Color? fillColor;
  final int maxLines;
  final String? Function(String?)? validator;

  const CustomTextField(
      {super.key,
      this.label,
      required this.hintText,
      this.isPassword = false,
      this.controller,
      this.keyboardType,
      this.leadingIcon,
      this.fillColor,
      this.maxLines = 1,
      this.validator});

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
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 12,
              maxWidth: 48,
              minHeight: 12,
              maxHeight: 48,
            ),
            prefixIcon: Padding(
              padding: leadingIcon == null ? EdgeInsets.zero : const EdgeInsets.all(12.0),
              child: leadingIcon,
            ),
            fillColor: fillColor,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}
