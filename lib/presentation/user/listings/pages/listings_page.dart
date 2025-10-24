import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/search_filter_module.dart';
import 'package:vrooom/core/configs/assets/app_images.dart';
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
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          children: [
            SearchFilterModule(),
            SizedBox(
              height: AppSpacing.xl,
            ),
            Row(
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
            SizedBox(height: AppSpacing.md),
            Row(
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
            SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
