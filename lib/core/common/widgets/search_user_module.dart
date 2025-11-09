import 'package:flutter/material.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';

import '../../configs/assets/app_vectors.dart';
import 'app_svg.dart';

class SearchUserModule extends StatelessWidget {
  final void Function(String)? onSearchChanged;

  const SearchUserModule({
    super.key,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.container.neutral900,
          borderRadius: BorderRadius.circular(10.0)),
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
                onChanged: onSearchChanged,
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
          ],
        ),
      ),
    );
  }
}