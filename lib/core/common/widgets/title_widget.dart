import 'package:flutter/cupertino.dart';

import '../../configs/theme/app_colors.dart';
import '../../configs/theme/app_spacing.dart';

class TitleWidget extends StatelessWidget {
  final String title;

  const TitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        )
      ],
    );
  }
}