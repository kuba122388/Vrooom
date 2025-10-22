import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/filter_tile.dart';

import '../../configs/assets/app_vectors.dart';
import '../../configs/theme/app_colors.dart';
import '../../configs/theme/app_spacing.dart';
import 'app_svg.dart';

class SearchFilterModule extends StatelessWidget {
  const SearchFilterModule({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.container.neutral900,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.container.neutral700,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppSvg(
                          asset: AppVectors.search,
                          width: 20,
                          color: AppColors.svg.neutral400,
                        ),
                      ],
                    ),
                  ),
                  hintText: "Search cars, locations...",
                  hintStyle: const TextStyle(letterSpacing: -0.5),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            const Row(
              children: [
                FilterTile(text: "Location", svgPicture: AppVectors.mapPin),
                SizedBox(width: AppSpacing.xs),
                FilterTile(text: "Dates", svgPicture: AppVectors.calendar),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            const Row(
              children: [
                FilterTile(text: "Car Type", svgPicture: AppVectors.car),
                SizedBox(width: AppSpacing.xs),
                FilterTile(text: "Filters", svgPicture: AppVectors.filter),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
