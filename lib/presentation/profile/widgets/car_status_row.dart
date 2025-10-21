import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/configs/assets/app_vectors.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';

import '../../../core/configs/theme/app_spacing.dart';

enum RentalStatus {
  active,
  completed,
  cancelled,
  penalty,
}

class CarStatusRow extends StatelessWidget {
  final String carName;
  final RentalStatus status;

  const CarStatusRow({
    super.key,
    required this.carName,
    required this.status,
  });

  Color _getStatusColor() {
    switch (status) {
      case RentalStatus.active:
        return AppColors.container.claret;
      case RentalStatus.penalty:
        return AppColors.primary;
      default:
        return AppColors.container.neutral700;
    }
  }

  String _getStatusText() {
    switch (status) {
      case RentalStatus.active:
        return "Active";
      case RentalStatus.completed:
        return "Completed";
      case RentalStatus.cancelled:
        return "Cancelled";
      case RentalStatus.penalty:
        return "Penalty";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const AppSvg(
                asset: AppVectors.car,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              SizedBox(
                width: 120.0,
                child: Text(
                  carName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                    color: _getStatusColor(),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 3.0,
                  ),
                  child: Text(
                    _getStatusText(),
                    style: const TextStyle(
                      fontSize: 12.0,
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const AppSvg(
                asset: AppVectors.expandIcon,
                width: 18.0,
              ),
            ],
          ),
        ),
        Divider(
          color: AppColors.container.neutral700,
          height: 1,
        )
      ],
    );
  }
}
