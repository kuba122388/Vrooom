import 'package:flutter/material.dart';

class DarkGradientOverlay extends StatelessWidget {
  final double height;

  const DarkGradientOverlay({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.5),
            Colors.black.withValues(alpha: 0.5),
          ],
        ),
      ),
    );
  }
}
