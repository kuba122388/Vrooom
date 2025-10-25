import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/app_spacing.dart';

class CarCard extends StatelessWidget {
  final String carImage;
  final String carName;
  final Column rightSide;
  final Row bottom;

  const CarCard({
    super.key,
    required this.carImage,
    required this.carName,
    required this.rightSide,
    required this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.container.neutral700,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Column(
                  children: [
                    Image.asset(
                      carImage,
                      width: 140,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      carName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    rightSide,
                  ],
                ),
              ),
            ]),
            const SizedBox(height: AppSpacing.sm),
            bottom
          ],
        ),
      ),
    );
  }
}
