import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/custom_text_field.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';

import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/configs/theme/app_spacing.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Forgot password"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter email",
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: AppSpacing.md),

            Text(
              "Enter your email address\nwe’ll send a password reset code to it",
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.6, color: AppColors.text.neutral400),
            ),

            const SizedBox(height: AppSpacing.md),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: CustomTextField(
                hintText: "john.doe@example.com"
              ),
            ),

            const SizedBox(height: AppSpacing.xs),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: PrimaryButton(
                text: "Submit",
                onPressed: () => Navigator.pushNamed(context, AppRoutes.verifyEmail),
              ),
            )
          ],
        ),
      ),
    );
  }
}