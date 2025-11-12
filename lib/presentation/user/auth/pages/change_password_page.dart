import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';

import '../../../../core/common/widgets/custom_text_field.dart';
import '../../../../core/common/widgets/primary_button.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/configs/theme/app_spacing.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Change password"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Change password",
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: AppSpacing.md),

            Text(
              "Type your new password\nthen confirm it by entering it again",
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.6, color: AppColors.text.neutral400),
            ),

            const SizedBox(height: AppSpacing.md),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: CustomTextField(
                label: "Password",
                hintText: "Password"
              ),
            ),

            const SizedBox(height: AppSpacing.xs),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: CustomTextField(
                  label: "Repeat password",
                  hintText: "Password"
              ),
            ),

            const SizedBox(height: AppSpacing.xs),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: PrimaryButton(
                text: "Submit",
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.signin)
              ),
            )
          ],
        ),
      ),
    );
  }
}