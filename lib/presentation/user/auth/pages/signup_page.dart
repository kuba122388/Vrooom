import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/custom_text_field.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';

import '../../../../core/configs/theme/app_spacing.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Create Account"),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Column(
              children: [
                const CustomTextField(hintText: "John", label: "First name"),
                const CustomTextField(hintText: "Doe", label: "Last name"),
                const CustomTextField(hintText: "john.doe@example.com", label: "Email"),
                const CustomTextField(hintText: "••••••••", label: "Password"),
                const CustomTextField(hintText: "+1 (555) 123-4567", label: "Email"),
                const CustomTextField(hintText: "123 Main St", label: "Email"),
                const SizedBox(height: AppSpacing.sm),
                PrimaryButton(
                    text: "Sign Up",
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.verifyEmail)),
                const SizedBox(height: AppSpacing.xs),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
