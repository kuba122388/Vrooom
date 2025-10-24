import 'package:flutter/material.dart';

import '../../configs/theme/app_colors.dart';
import '../../configs/theme/app_spacing.dart';
import 'app_svg.dart';

class FilterTile extends StatelessWidget {
  final String text;
  final String svgPicture;

  const FilterTile({super.key, required this.text, required this.svgPicture});

  @override
  Widget build(BuildContext context) {
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
