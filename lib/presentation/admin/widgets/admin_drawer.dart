import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/configs/assets/app_vectors.dart';

import '../../../core/configs/routes/app_routes.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/app_spacing.dart';
import 'admin_menu_item.dart';

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({super.key});

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.md),
            const Center(
              child: Text(
                "Admin panel",
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            Text(
              "Manage your rental business",
              style: TextStyle(
                fontSize: 12.0,
                color: AppColors.text.neutral400,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                itemCount: AdminMenuConfig.menuItems.length,
                itemBuilder: (context, index) {
                  final item = AdminMenuConfig.menuItems[index];
                  return ListTile(
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: AppSvg(
                      asset: item.svgVector,
                    ),
                    onTap: () async {
                      await Future.delayed(const Duration(milliseconds: 50));
                      if (mounted) Navigator.pushReplacementNamed(context, item.route);
                    },
                  );
                },
              ),
            ),
            ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: const Text(
                "Log out",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
              leading: const AppSvg(
                asset: AppVectors.logout,
                color: AppColors.primary,
              ),
              onTap: () async {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signin, (_) => false);
              },
            ),
            const SizedBox(
              height: AppSpacing.md,
            ),
          ],
        ),
      ),
    );
  }
}
