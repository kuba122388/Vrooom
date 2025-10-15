import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/dark_gradient_overlay.dart';
import 'package:vrooom/core/common/widgets/info_section_card.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/assets/app_images.dart';
import 'package:vrooom/core/configs/assets/app_vectors.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/presentation/listings/widgets/car_feature_container.dart';
import 'package:vrooom/presentation/listings/widgets/car_specification_row.dart';

class CarDetailsPage extends StatelessWidget {
  const CarDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CarSpecification> specifications = [
      CarSpecification(iconPath: AppVectors.car, label: "Model Year", value: "2023"),
      CarSpecification(iconPath: AppVectors.fuel, label: "Fuel Type", value: "Petrol"),
      CarSpecification(iconPath: AppVectors.gauge, label: "Transmission", value: "Automatic"),
      CarSpecification(iconPath: AppVectors.seats, label: "Seats", value: "5"),
      CarSpecification(iconPath: AppVectors.milestone, label: "Mileage", value: "15,000 km"),
    ];
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Car Details",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  AppImages.mercedes,
                  width: double.infinity,
                  height: 220.0,
                  fit: BoxFit.cover,
                ),
                const DarkGradientOverlay(height: 220.0),
                const Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Text(
                    "Mercedes-Benz C-Class",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 28.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5),
                  ),
                )
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            InfoSectionCard(
              title: "Mercedes-Benz C-Class",
              child: Text(
                "A perfect blend of style, comfort, and performance, ideal for city commutes and long drives.",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14.0,
                  color: AppColors.text.neutral400,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            InfoSectionCard(
              title: "Specifications",
              child: Column(
                children: specifications.map((spec) {
                  return CarSpecRow(
                    iconPath: spec.iconPath,
                    label: spec.label,
                    value: spec.value,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const InfoSectionCard(
              title: "Features",
              child: Wrap(
                spacing: AppSpacing.xxs,
                runSpacing: AppSpacing.xs,
                children: [
                  CarFeatureContainer(
                    label: "Air Conditioning",
                    iconPath: AppVectors.snowflake,
                  ),
                  CarFeatureContainer(
                    label: "Bluetooth Audio",
                    iconPath: AppVectors.snowflake,
                  ),
                  CarFeatureContainer(
                    label: "GPS Navigation",
                    iconPath: AppVectors.snowflake,
                  ),
                  CarFeatureContainer(
                    label: "Cruise Control",
                    iconPath: AppVectors.snowflake,
                  ),
                  CarFeatureContainer(
                    label: "Keyless Entry",
                    iconPath: AppVectors.snowflake,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const InfoSectionCard(
              title: "Pricing",
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Daily Rate",
                        style: TextStyle(fontSize: 14.0),
                      ),
                      Spacer(),
                      Text(
                        "\$99.00/day",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppSpacing.xxs,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Rental days",
                        style: TextStyle(fontSize: 14.0),
                      ),
                      Spacer(),
                      Text(
                        "3 days",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppSpacing.xxs,
                  ),
                  Divider(),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Estimated Total",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "\$297.00",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: PrimaryButton(
                text: "Rent Now",
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

class CarSpecification {
  final String iconPath;
  final String label;
  final String value;

  CarSpecification({
    required this.iconPath,
    required this.label,
    required this.value,
  });
}
