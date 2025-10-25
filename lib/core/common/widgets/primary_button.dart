import 'package:flutter/material.dart';
import '../../configs/theme/app_colors.dart';
import '../../configs/theme/app_text_styles.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final double height;
  final double width;
  final double horizontalPadding;
  final double backgroundOpacity;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.textStyle = AppTextStyles.button,
    this.height = 45.0,
    this.width = double.infinity,
    this.horizontalPadding = 12,
    this.backgroundOpacity = 1,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
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
        widget.onPressed?.call();
      },
      child: Container(
        padding: EdgeInsets.only(left: widget.horizontalPadding, right: widget.horizontalPadding),
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: _isPressed
              ? AppColors.primary.withValues(alpha: (0.7 * widget.backgroundOpacity))
              : AppColors.primary.withValues(alpha: widget.backgroundOpacity),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: widget.textStyle,
          ),
        ),
      ),
    );
  }
}
