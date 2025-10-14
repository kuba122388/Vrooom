import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/assets/app_vectors.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';

class VerificationSuccessPage extends StatelessWidget {
  const VerificationSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Email Verified",
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppVectors.circleCheck,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcATop,
                ),
                height: 100.0,
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                "Your email has been\nsuccessfully verified!",
                style: TextStyle(fontSize: 24.0, fontFamily: 'Roboto'),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                text: "Continue",
                onPressed: () => Navigator.pushNamed(context, AppRoutes.listings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
