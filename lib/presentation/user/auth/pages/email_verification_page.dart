import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';

// Załóżmy, że masz ten Usecase (musisz go stworzyć i dodać do service_locator.dart)
// Będzie on wywoływał authRepository.verifyEmail(code: code)
import 'package:vrooom/domain/usecases/auth/verify_email_usecase.dart';
import 'package:vrooom/core/configs/di/service_locator.dart';
import 'package:vrooom/domain/entities/role.dart'; // Potrzebne do nawigacji

import '../widgets/pinput_fields.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email; // Odbierz e-mail z argumentów nawigacji

  const EmailVerificationPage({super.key, required this.email});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final VerifyEmailUseCase _verifyEmailUseCase = sl();

  final TextEditingController _pinputController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleVerify() async {
    final code = _pinputController.text;
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kod musi mieć 6 cyfr."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await _verifyEmailUseCase(code: code);

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
    _pinputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const CustomAppBar(title: "Verify Email"),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Verify your email",
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  "Enter code we've sent to your inbox\n${widget.email}", // Użyj dynamicznego e-maila
                  textAlign: TextAlign.center,
                  style:
                  TextStyle(height: 1.6, color: AppColors.text.neutral400),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Przekaż kontroler do Pinput
                PinputFields(controller: _pinputController),
                const SizedBox(height: AppSpacing.lg),
                // Dodaj przycisk do wysłania
                PrimaryButton(
                  text: _isLoading ? "Verifying..." : "Verify",
                  onPressed: _isLoading ? null : _handleVerify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}