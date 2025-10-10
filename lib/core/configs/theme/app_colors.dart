import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor

  // Main colors
  static const primary = Color(0xFFE00000);
  static const background = Color(0xFF000000);

  static const _ContainerColors container = _ContainerColors();
  static const _TextColors text = _TextColors();
}

// Classes with '_' prefix are only visible within this file
class _ContainerColors {
  const _ContainerColors();

  final neutral700 = const Color(0xFF323743);
  final neutral750 = const Color(0xFF262a33);
  final neutral800 = const Color(0xFF1e2128);
  final neutral900 = const Color(0xFF171a1f);
  final claret = const Color(0xFF3D0000);
}

class _TextColors {
  const _TextColors();

  final neutral200 = const Color(0xFFf3f4f6);
  final neutral400 = const Color(0xFFbdc1ca);
  final red750 = const Color(0xC0E00000);
}
