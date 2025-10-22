import 'package:flutter/material.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';

import '../../../core/common/widgets/app_svg.dart';
import '../../../core/configs/assets/app_vectors.dart';
import '../../../core/configs/theme/app_spacing.dart';

enum CarStatus { available, maintenance, booked, rented, unavailable }

class CarInventoryEntry extends StatelessWidget {
  final String carImage;
  final String carName;
  final String fuel;
  final int mileage;
  final String transmission;
  final int seats;
  final double price;
  final CarStatus carStatus;

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
    }
  }

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
                child: Image.asset(
                  carImage,
                  width: 140,
                  height: 120,
                  fit: BoxFit.cover,
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
                    Column(
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
                  ],
                ),
              ),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Row(
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
          ],
        ),
      ),
    );
  }
}
