import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';

import '../../../../core/common/widgets/info_section_card.dart';
import '../../../../core/configs/assets/app_images.dart';
import '../../../../core/configs/assets/app_vectors.dart';
import '../../../../core/configs/theme/app_spacing.dart';

class BookingCarTile extends StatelessWidget {
  final String title;

  final DateTime startDate;
  final DateTime finishDate;

  final String startPoint;
  final String finishPoint;

  final String? penalty;

  const BookingCarTile({
    super.key,
    required this.title,
    required this.startDate,
    required this.finishDate,
    required this.startPoint,
    required this.finishPoint,
    this.penalty,
  });

  @override
  Widget build(BuildContext context) {
    return InfoSectionCard(
      title: title,
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                AppImages.mercedes,
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
                  const Text(
                    "Mercedes-Benz C-Class",
                    style: TextStyle(
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxs),

                  // DATE
                  Row(
                    children: [
                      const AppSvg(
                        asset: AppVectors.start,
                        height: 14.0,
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(DateFormat("dd.MM.yyyy").format(startDate)),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxs / 2),
                  Row(
                    children: [
                      const AppSvg(
                        asset: AppVectors.finish,
                        height: 14.0,
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(DateFormat("dd.MM.yyyy").format(finishDate)),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // PLACE
                  Row(
                    children: [
                      const AppSvg(
                        asset: AppVectors.locationStart,
                        height: 14.0,
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(startPoint),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxs / 2),
                  Row(
                    children: [
                      const AppSvg(
                        asset: AppVectors.locationFinish,
                        height: 14.0,
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Text(finishPoint),
                      const Spacer(),
                    ],
                  ),

                  // PENALTY,
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (penalty != null)
                        Text(
                          penalty!,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const Spacer(),
                      const AppSvg(
                        asset: AppVectors.arrowRight,
                        height: 20.0,
                      ),
                    ],
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
