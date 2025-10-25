import 'package:flutter/material.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';
import 'package:vrooom/core/configs/theme/app_text_styles.dart';

import '../../../../core/common/widgets/primary_button.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/configs/theme/app_spacing.dart';

class CarTile extends StatelessWidget {
  final String imgPath;
  final String model;
  final String brand;
  final double price;

  const CarTile({
    super.key,
    required this.imgPath,
    required this.model,
    required this.brand,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.container.neutral800,
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
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
                          model,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          brand,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '\$${price.toStringAsFixed(2)}/day',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
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
                    const Text(
                      "Sample text that i wrote here. Sample text that i wrote here. Sample text that i wrote here.",
                      style: TextStyle(fontSize: 12.0),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    PrimaryButton(
                      text: "View Details",
                      textStyle: AppTextStyles.smallButton,
                      height: 40.0,
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.carDetails),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
