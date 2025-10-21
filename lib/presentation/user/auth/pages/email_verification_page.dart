import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';

import '../widgets/pinput_fields.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const CustomAppBar(title: "Verify Email"),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Verify your email",
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                "Enter code we've sent to your inbox\njohn.doe@example.com",
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.6, color: AppColors.text.neutral400),
              ),
              const PinputFields(),
            ],
          ),
        ),
      ),
    );
  }
}
