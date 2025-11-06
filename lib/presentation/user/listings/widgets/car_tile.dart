import 'package:flutter/material.dart';
import 'package:vrooom/core/configs/theme/app_text_styles.dart';

import '../../../../core/common/widgets/primary_button.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/configs/theme/app_spacing.dart';

class CarTile extends StatelessWidget {
  final String imgPath;
  final String make;
  final String model;
  final double price;
  final String description;
  final VoidCallback? onTap;

  const CarTile({
    super.key,
    required this.imgPath,
    required this.make,
    required this.model,
    required this.price,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.container.neutral800,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Image.network(
                  imgPath,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),

                // Gradient
                Container(
                  width: double.infinity,
                  height: 150,
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
                ),

                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        make,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        model,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '\$${price.toStringAsFixed(2)}/day',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, top: AppSpacing.xxs),
                    child: Text(
                      description,
                      style: const TextStyle(fontSize: 12.0),
                    ),
                  ),
                  PrimaryButton(
                    text: "View Details",
                    textStyle: AppTextStyles.smallButton,
                    height: 40.0,
                    onPressed: onTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
