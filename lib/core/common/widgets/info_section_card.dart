import 'package:flutter/material.dart';

import '../../configs/theme/app_colors.dart';
import '../../configs/theme/app_spacing.dart';

class InfoSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const InfoSectionCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.container.neutral800,
            borderRadius: BorderRadius.circular(15.0),
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text.neutral200,
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                child
              ],
            ),
          ),
        ),
      ],
    );
  }
}
