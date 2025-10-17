import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/info_section_card.dart';
import 'package:vrooom/core/configs/assets/app_images.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/presentation/profile/widgets/car_status_row.dart';
import 'package:vrooom/presentation/profile/widgets/settings_tile.dart';

import '../../../core/common/widgets/app_svg.dart';
import '../../../core/common/widgets/primary_button.dart';
import '../../../core/configs/assets/app_vectors.dart';
import '../../../core/configs/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            InfoSectionCard(
              child: Row(
                children: [
                  SizedBox(
                    height: 60.0,
                    width: 60.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Image.asset(AppImages.person, fit: BoxFit.cover,),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "John Doe",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        "john.doe@exmaple.com",
                        style: TextStyle(
                          color: AppColors.text.neutral400,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const InfoSectionCard(
              title: "Rental History",
              child: Column(
                children: [
                  CarStatusRow(carName: "Mercedes C-Class", status: RentalStatus.active,),
                  CarStatusRow(carName: "Tesla Model 3", status: RentalStatus.completed,),
                  CarStatusRow(carName: "Ford Mustang", status: RentalStatus.cancelled,),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            InfoSectionCard(
              title: "Settings",
              child: Column(
                children: [
                  SettingsTile(
                    icon: const AppSvg(asset: AppVectors.settings),
                    label: "Account Settings",
                    onTap: () => Navigator.pushNamed(context, AppRoutes.editProfileDetails),
                  ),
                  const SettingsTile(
                    icon: AppSvg(asset: AppVectors.privacyPolicy),
                    label: "Privacy Policy",
                  ),
                  const SettingsTile(
                    icon: AppSvg(asset: AppVectors.contact),
                    label: "Contact",
                  )
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              text: "Log Out",
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.signin,
                  (route) => false
              ),
            ),
          ],
        ),
      ),
    );
  }
}
