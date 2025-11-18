import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/custom_text_field.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';

import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../core/configs/di/service_locator.dart';
import '../../../domain/usecases/auth/reset_password_usecase.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  final ResetPasswordUseCase _resetPasswordUseCase = sl();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }


  Future<void> _handleResetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email address is required."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await _resetPasswordUseCase(email: email);

    setState(() => _isLoading = false);

    result.fold(
          (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      },
          (successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Forgot password"),
      body: Center(
        child: SingleChildScrollView(
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: CustomTextField(
                  controller: _emailController,
                  hintText: "john.doe@example.com",
                  keyboardType: TextInputType.emailAddress,
                ),
              ),

              const SizedBox(height: AppSpacing.xs),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: PrimaryButton(
                  text: _isLoading ? "Sending..." : "Submit",
                  onPressed: _isLoading ? null : _handleResetPassword,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}