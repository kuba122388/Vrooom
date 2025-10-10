import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';

import '../../configs/assets/app_vectors.dart';

class SplashHero extends StatelessWidget {
  const SplashHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'Splash Hero Widget',
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: SvgPicture.asset(
                        AppVectors.appLogo,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      width: AppSpacing.md,
                    ),
                    const Text(
                      'Vrooom',
                      style: TextStyle(
                          fontSize: 40.0,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                Text(
                  'Step in. Drive away. Simple!',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18.0,
                    color: AppColors.text.neutral400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
