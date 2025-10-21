import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/configs/assets/app_images.dart';
import 'package:vrooom/core/configs/assets/app_vectors.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';

import '../widgets/car_tile.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({super.key});

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          children: [
            _searchModule(),
            const SizedBox(
              height: AppSpacing.xl,
            ),
            const Row(
              children: [
                CarTile(
                  imgPath: AppImages.mercedes,
                  model: "Mercedes-Benz",
                  brand: "C-Class",
                  price: 85.00,
                ),
                SizedBox(
                  width: AppSpacing.sm,
                ),
                CarTile(
                  imgPath: AppImages.mercedes,
                  model: "Mercedes-Benz",
                  brand: "C-Class",
                  price: 85.00,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Row(
              children: [
                CarTile(
                  imgPath: AppImages.mercedes,
                  model: "Mercedes-Benz",
                  brand: "C-Class",
                  price: 85.00,
                ),
                SizedBox(
                  width: AppSpacing.sm,
                ),
                CarTile(
                  imgPath: AppImages.mercedes,
                  model: "Mercedes-Benz",
                  brand: "C-Class",
                  price: 85.00,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Container _searchModule() {
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
            Row(
              children: [
                _customTile("Location", AppVectors.mapPin),
                const SizedBox(width: AppSpacing.xs),
                _customTile("Dates", AppVectors.calendar),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                _customTile("Car Type", AppVectors.car),
                const SizedBox(width: AppSpacing.xs),
                _customTile("Filters", AppVectors.filter),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Flexible _customTile(String text, String svgPicture) {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: AppColors.container.neutral700)),
        height: 40,
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSvg(
              asset: svgPicture,
              color: AppColors.svg.neutral400,
              height: 15.0,
            ),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              text,
              style: const TextStyle(fontFamily: 'Roboto', letterSpacing: -0.5),
            ),
          ],
        )),
      ),
    );
  }
}
