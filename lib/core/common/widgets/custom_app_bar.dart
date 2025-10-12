import 'package:flutter/material.dart';

import '../../configs/theme/app_colors.dart';
import '../../configs/theme/app_spacing.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const CustomAppBar(
      {super.key, required this.title, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      leading: showBackButton
          ? IconButton(
              onPressed: () => Navigator.of(context).pop(),
              color: AppColors.primary,
              icon: const Icon(Icons.chevron_left, size: 36.0),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + AppSpacing.sm);
}
