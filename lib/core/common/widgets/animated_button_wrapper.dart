import 'package:flutter/material.dart';
import 'custom_container.dart';

class AnimatedButtonWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  final BorderRadius? borderRadius;

  const AnimatedButtonWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
  });

  @override
  State<AnimatedButtonWrapper> createState() => _AnimatedButtonWrapperState();
}

class _AnimatedButtonWrapperState extends State<AnimatedButtonWrapper> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (!mounted) return;
    setState(() => _pressed = value);
  }

  BorderRadiusGeometry? _detectBorderRadiusGeometry() {
    final child = widget.child;

    if (child is CustomContainer) {
      return BorderRadius.circular(15);
    }

    if (child is Container && child.decoration is BoxDecoration) {
      return (child.decoration as BoxDecoration).borderRadius;
    }

    if (child is ClipRRect) return child.borderRadius;

    return null;
  }

  BorderRadius? _resolveBorderRadius(BorderRadiusGeometry? geo) {
    if (geo == null) return null;
    if (geo is BorderRadius) return geo;

    final direction = Directionality.maybeOf(context) ?? TextDirection.ltr;
    return geo.resolve(direction);
  }

  @override
  Widget build(BuildContext context) {
    final detectedGeo =
        widget.borderRadius ?? _detectBorderRadiusGeometry();
    final resolvedBR = _resolveBorderRadius(detectedGeo);

    return AnimatedScale(
      scale: _pressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: _pressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 120),

        child: Stack(
          children: [
            widget.child,

            Positioned.fill(
              child: ClipRRect(
                borderRadius: resolvedBR ?? BorderRadius.zero,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTapDown: (_) => _setPressed(true),
                    onTapUp: (_) => _setPressed(false),
                    onTapCancel: () => _setPressed(false),
                    onTap: () async {
                      _setPressed(true);
                      await Future.delayed(const Duration(milliseconds: 180));
                      _setPressed(false);
                      await Future.delayed(const Duration(milliseconds: 80));

                      if (widget.onTap != null) widget.onTap!();
                    },
                    borderRadius: resolvedBR,
                    splashColor: const Color(0x80FFFFFF),
                    highlightColor: Colors.transparent,
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
