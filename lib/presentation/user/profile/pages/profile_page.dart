import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/info_section_card.dart';
import 'package:vrooom/core/configs/assets/app_images.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/domain/usecases/auth/logout_usecase.dart';
import 'package:vrooom/presentation/user/profile/widgets/car_status_row.dart';
import 'package:vrooom/presentation/user/profile/widgets/settings_tile.dart';

import '../../../../core/common/widgets/app_svg.dart';
import '../../../../core/common/widgets/primary_button.dart';
import '../../../../core/configs/assets/app_vectors.dart';
import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/enums/rental_status.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final LogoutUseCase _logoutUseCase = sl();

  Future<void> _handleLogout() async {
    final result = await _logoutUseCase();

    if (!mounted) return;

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully logged out!"),
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.signin,
          (route) => false,
        );
      },
    );
  }

  Future<void> _showLogoutConfirmation() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Text('Log Out'),
            Spacer(),
            AppSvg(
              asset: AppVectors.close,
              color: Colors.white,
            )
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to log out?'),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              onPressed: () => Navigator.pop(context, true),
              text: 'Log Out',
            ),
          ],
        ),
      ),
    );

    if (shouldLogout == true) {
      await _handleLogout();
    }
  }

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
                      child: Image.asset(
                        AppImages.person,
                        fit: BoxFit.cover,
                      ),
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const InfoSectionCard(
              title: "Rental History",
              child: Column(
                children: [
                  CarStatusRow(
                    carName: "Mercedes C-Class",
                    status: RentalStatus.active,
                  ),
                  CarStatusRow(
                    carName: "Tesla Model 3",
                    status: RentalStatus.completed,
                  ),
                  CarStatusRow(
                    carName: "Ford Mustang",
                    status: RentalStatus.cancelled,
                  ),
                  CarStatusRow(
                    carName: "Opel Astra",
                    status: RentalStatus.penalty,
                  ),
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
                  SettingsTile(
                    icon: const AppSvg(asset: AppVectors.contact),
                    label: "Contact",
                    onTap: () => Navigator.pushNamed(context, AppRoutes.contact),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              text: "Log Out",
              onPressed: () => _showLogoutConfirmation(),
            ),
          ],
        ),
      ),
    );
  }
}
