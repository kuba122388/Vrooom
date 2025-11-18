import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vrooom/core/common/widgets/animated_button_wrapper.dart';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/common/widgets/custom_container.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/domain/entities/booking.dart';

import '../../configs/assets/app_vectors.dart';
import '../../configs/theme/app_spacing.dart';

class BookingCarTile extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onTap;

  const BookingCarTile({
    super.key,
    required this.booking,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedButtonWrapper(
      onTap: onTap,
      child: CustomContainer(
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  booking.vehicleImage as String,
                  height: 140.0,
                  width: 100.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${booking.vehicleMake} ${booking.vehicleModel}",
                      style: const TextStyle(
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxs),

                    // DATE
                    Row(
                      children: [
                        const AppSvg(asset: AppVectors.start, height: 14.0),
                        const SizedBox(width: AppSpacing.xxs),
                        Text(DateFormat("dd.MM.yyyy").format(booking.startDate as DateTime)),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs / 2),
                    Row(
                      children: [
                        const AppSvg(asset: AppVectors.finish, height: 14.0),
                        const SizedBox(width: AppSpacing.xxs),
                        Text(DateFormat("dd.MM.yyyy").format(booking.endDate as DateTime)),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // PLACE
                    Row(
                      children: [
                        const AppSvg(asset: AppVectors.locationStart, height: 14.0),
                        const SizedBox(width: AppSpacing.xxs),
                        Text(booking.pickupAddress?.split(", ").last as String),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs / 2),
                    Row(
                      children: [
                        const AppSvg(asset: AppVectors.locationFinish, height: 14.0),
                        const SizedBox(width: AppSpacing.xxs),
                        Text(booking.dropOffAddress?.split(", ").last as String),
                        const Spacer(),
                      ],
                    ),

                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (booking.penalty != 0)
                          Text(
                            booking.penalty.toString(),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        const Spacer(),
                        const AppSvg(asset: AppVectors.arrowRight, height: 20.0),
                      ],
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
