import 'package:flutter/material.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';

import '../../configs/assets/app_vectors.dart';
import '../../configs/theme/app_spacing.dart';
import 'app_svg.dart';
import 'filter_tile.dart';

class SearchUserModule extends StatelessWidget {
  const SearchUserModule({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.container.neutral900, borderRadius: BorderRadius.circular(10.0)),
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
                  hintText: "Search users...",
                  hintStyle: const TextStyle(letterSpacing: -0.5),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            const Center(
              child: SizedBox(
                width: 150,
                child: FilterTile(text: "More Filters", svgPicture: AppVectors.filter),
              ),
            )
          ],
        ),
      ),
    );
  }
}
