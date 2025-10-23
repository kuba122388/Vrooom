import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/search_user_module.dart';
import 'package:vrooom/core/configs/assets/app_images.dart';
import 'package:vrooom/presentation/admin/widgets/user_information_entity.dart';

import '../../../../core/configs/theme/app_spacing.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<UserInformationEntity> userInformation = [
      const UserInformationEntity(
        profileImage: AppImages.person,
        firstName: "Andrzej",
        surname: "Musiał",
        email: "maciej.musial@example.com",
        phone: "622-012-775",
        userStatus: UserStatus.active,
      ),

      const UserInformationEntity(
        profileImage: AppImages.person,
        firstName: "Cezary",
        surname: "Pazura",
        email: "cezary@example.com",
        phone: "623-123-991",
        userStatus: UserStatus.offline,
      ),

      const UserInformationEntity(
        profileImage: AppImages.person,
        firstName: "Robert",
        surname: "Burnejka",
        email: "robur@test.com",
        phone: "091-881-321",
        userStatus: UserStatus.active,
      ),

      const UserInformationEntity(
        profileImage: AppImages.person,
        firstName: "Cezary",
        surname: "Pazura",
        email: "cezary@example.com",
        phone: "623-123-991",
        userStatus: UserStatus.offline,
      )
    ];

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Manage Users"
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SearchUserModule(),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                "Users",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              ...userInformation.map((entry) {
                return UserInformationEntity(
                  profileImage: entry.profileImage,
                  firstName: entry.firstName,
                  surname: entry.surname,
                  email: entry.email,
                  phone: entry.phone,
                  userStatus: entry.userStatus,
                );
              }).expand(
                (widget) => [widget, const SizedBox(height: AppSpacing.sm)],
              )
            ],
          ),
        ),
      ),
    );
  }
}