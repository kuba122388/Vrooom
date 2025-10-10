import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/pressable_text.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/common/widgets/splash_hero.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/presentation/auth/widgets/social_button.dart';

import '../../../core/common/widgets/divider_with_text.dart';
import '../../../core/common/widgets/custom_text_field.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Stationary Car Rentals',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Note: Hero Widget
              const Center(child: SplashHero()),
              const SizedBox(height: AppSpacing.lg),

              // Note: Login section
              CustomTextField(
                label: "Email",
                hintText: 'hello@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(
                  label: "Password",
                  hintText: 'Your password',
                  isPassword: true,
                  controller: _passwordController),
              const Align(
                alignment: Alignment.centerRight,
                child: PressableText(
                  text: 'Forgot password?',
                  style: TextStyle(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const PrimaryButton(text: "Login"),
              const SizedBox(height: AppSpacing.lg),

              // Note: Social Login section
              _buildSocialLoginSection(),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginSection() {
    return Column(
      children: [
        const DividerWithText(text: "Or Continue With"),
        const SizedBox(height: AppSpacing.md),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialButton(text: "Facebook"),
            SizedBox(width: AppSpacing.md),
            SocialButton(text: "Google"),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: TextStyle(color: AppColors.text.neutral400),
            ),
            const PressableText(
              text: 'Sign Up',
              style: TextStyle(color: AppColors.primary),
            ),
          ],
        ),
      ],
    );
  }
}
