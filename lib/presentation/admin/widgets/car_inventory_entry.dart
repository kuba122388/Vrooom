import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/animated_button_wrapper.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/presentation/admin/widgets/car_card.dart';

import '../../../core/common/widgets/app_svg.dart';
import '../../../core/configs/assets/app_vectors.dart';
import '../../../core/configs/theme/app_spacing.dart';

enum CarStatus { available, maintenance, booked, rented, unavailable, archived }

class CarInventoryEntry extends StatelessWidget {
  final String carImage;
  final String carName;
  final String fuel;
  final int mileage;
  final String transmission;
  final int seats;
  final double price;
  final CarStatus carStatus;
  final VoidCallback? onTap;

  const CarInventoryEntry({
    super.key,
    required this.carImage,
    required this.carName,
    required this.fuel,
    required this.mileage,
    required this.transmission,
    required this.seats,
    required this.price,
    required this.carStatus,
    this.onTap
  });

  Color _getStatusColor(CarStatus status) {
    switch (status) {
      case CarStatus.available:
        return AppColors.container.complete200;
      case CarStatus.maintenance:
        return AppColors.container.warning500;
      case CarStatus.unavailable:
        return AppColors.container.neutral800;
      case CarStatus.booked:
        return AppColors.container.progress200;
      case CarStatus.rented:
        return AppColors.container.danger500;
      case CarStatus.archived:
        return AppColors.container.claret;
    }
  }

  String _getStatusText(CarStatus status) {
    switch (status) {
      case CarStatus.available:
        return "Available";
      case CarStatus.maintenance:
        return "Maintenance";
      case CarStatus.booked:
        return "Booked";
      case CarStatus.rented:
        return "Rented";
      case CarStatus.unavailable:
        return "Unavailable";
      case CarStatus.archived:
        return "Archived";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedButtonWrapper(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.0),
      child: CarCard(
        carName: carName,
        carImage: carImage,
        rightSide: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const AppSvg(
                  asset: AppVectors.fuel,
                  color: AppColors.primary,
                  height: 18.0,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(fuel),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            Row(
              children: [
                const AppSvg(
                  asset: AppVectors.carFront,
                  color: AppColors.primary,
                  height: 18.0,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text("$mileage km"),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            Row(
              children: [
                const AppSvg(
                  asset: AppVectors.gauge,
                  color: AppColors.primary,
                  height: 18.0,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(transmission),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            Row(
              children: [
                const AppSvg(
                  asset: AppVectors.seats,
                  color: AppColors.primary,
                  height: 18.0,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text("$seats seats"),
              ],
            ),
          ],
        ),
        bottom: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: _getStatusColor(carStatus),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Text(_getStatusText(carStatus)),
              ),
            ),
            const Spacer(),
            RichText(
              text: TextSpan(
                text: "\$${price.toStringAsFixed(2)}",
                children: const [
                  TextSpan(
                    text: " per day",
                    style: TextStyle(fontSize: 10.0),
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
