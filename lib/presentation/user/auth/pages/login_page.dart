import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/pressable_text.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/common/widgets/splash_hero.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';

import '../../../../core/configs/di/service_locator.dart';
import '../../../../domain/entities/role.dart';
import '../../../../domain/usecases/auth/login_usecase.dart';
import '../widgets/divider_with_text.dart';
import '../../../../core/common/widgets/custom_text_field.dart';
import '../../../../core/configs/routes/app_routes.dart';
import '../widgets/social_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginUseCase _loginUseCase = sl();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    final result = await _loginUseCase(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      },
      (user) {
        if (user.role == Role.admin) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.carManagement,
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.main,
            (route) => false,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
          title: "Stationary Car Rentals", showBackButton: false),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
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
                Align(
                  alignment: Alignment.centerRight,
                  child: PressableText(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    text: 'Forgot password?',
                    style: const TextStyle(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  text: _isLoading == false ? "Login" : "Logging in...",
                  onPressed: () => _handleLogin(),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Note: Social Login section
                _buildSocialLoginSection(),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
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
            PressableText(
              text: 'Sign Up',
              style: const TextStyle(color: AppColors.primary),
              onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
            ),
          ],
        ),
      ],
    );
  }
}
