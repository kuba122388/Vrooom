import 'package:flutter/material.dart';

import '../../configs/theme/app_colors.dart';

class PressableText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final VoidCallback? onTap;

  const PressableText({
    super.key,
    required this.text,
    this.style,
    this.onTap,
  });

  @override
  State<PressableText> createState() => _PressableTextState();
}

class _PressableTextState extends State<PressableText> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () async {
        setState(() => _isPressed = true);
        await Future.delayed(const Duration(milliseconds: 10));
        if (mounted) setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      child: Text(
        widget.text,
        style: widget.style?.copyWith(
              color: _isPressed
                  ? (widget.style?.color ?? AppColors.primary).withValues(alpha: 0.7)
                  : (widget.style?.color ?? AppColors.primary),
            ) ??
            TextStyle(
              color: _isPressed ? AppColors.primary.withValues(alpha: 0.7) : AppColors.primary,
            ),
      ),
    );
  }
}
