import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/custom_text_field.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/assets/app_vectors.dart';

import '../../../../core/configs/theme/app_spacing.dart';

class EditProfileDetails extends StatelessWidget {
  const EditProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Edit Profile Details"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomTextField(
                hintText: "John Doe",
                label: "Full Name",
                leadingIcon: AppSvg(asset: AppVectors.person),
              ),
              const CustomTextField(
                hintText: "john.doe@example.com",
                label: "Email Address",
                leadingIcon: AppSvg(asset: AppVectors.mail),
              ),
              const CustomTextField(
                hintText: "123-456-7890",
                label: "Phone Number",
                leadingIcon: AppSvg(asset: AppVectors.phone),
              ),
              const CustomTextField(
                hintText: "123 Main St., Anytown, USA",
                label: "Address",
                leadingIcon: AppSvg(asset: AppVectors.mapPin),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                "Change Password",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const CustomTextField(
                hintText: "Current password",
                label: "Current Password",
                leadingIcon: AppSvg(asset: AppVectors.key),
                isPassword: true,
              ),
              const CustomTextField(
                hintText: "New password",
                label: "New Password",
                leadingIcon: AppSvg(asset: AppVectors.key),
                isPassword: true,
              ),
              const CustomTextField(
                hintText: "Repeat Password",
                label: "Repeat Password",
                leadingIcon: AppSvg(asset: AppVectors.key),
                isPassword: true,
              ),
              PrimaryButton(
                text: "Save",
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
