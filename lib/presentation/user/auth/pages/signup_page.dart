import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/custom_text_field.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';
import 'package:vrooom/domain/usecases/auth/register_usecase.dart';

import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/theme/app_spacing.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final RegisterUseCase _registerUseCase = sl();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _streetAddressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    _streetAddressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  String? _validateInputs() {
    if (_firstNameController.text.trim().isEmpty) {
      return 'First name is required';
    }
    if (_lastNameController.text.trim().isEmpty) {
      return 'Last name is required';
    }
    if (_emailController.text.trim().isEmpty) {
      return 'Email is required';
    }
    if (!_isValidEmail(_emailController.text.trim())) {
      return 'Please enter a valid email';
    }
    if (_passwordController.text.isEmpty) {
      return 'Password is required';
    }
    if (_passwordController.text.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      return 'Passwords do not match';
    }
    if (_phoneNumberController.text.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (_streetAddressController.text.trim().isEmpty) {
      return 'Street address is required';
    }
    if (_cityController.text.trim().isEmpty) {
      return 'City is required';
    }
    if (_postalCodeController.text.trim().isEmpty) {
      return 'Postal code is required';
    }
    return null;
  }

  Future<void> _handleRegister() async {
    final validationError = _validateInputs();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final result = await _registerUseCase(
        name: _firstNameController.text,
        surname: _lastNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        phoneNumber: _phoneNumberController.text,
        streetAddress: _streetAddressController.text,
        city: _cityController.text,
        postalCode: _postalCodeController.text,
        country: "Poland" // NOTE: CONST VALUE FOR NOW
        );

    setState(() => _isLoading = false);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      },
      (message) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.verifyEmail,
              (newPage) => false,
          arguments: _emailController.text.trim(),
        );
      },
    );
  }

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
                CustomTextField(
                  hintText: "John",
                  label: "First name",
                  controller: _firstNameController,
                ),
                CustomTextField(
                    hintText: "Doe", label: "Last name", controller: _lastNameController),
                CustomTextField(
                    hintText: "john.doe@example.com", label: "Email", controller: _emailController),
                CustomTextField(
                  hintText: "••••••••",
                  label: "Password",
                  controller: _passwordController,
                  isPassword: true,
                ),
                CustomTextField(
                  hintText: "••••••••",
                  label: "Confirm Password",
                  controller: _confirmPasswordController,
                  isPassword: true,
                ),
                CustomTextField(
                    hintText: "+1 (555) 123-4567",
                    label: "Phone",
                    controller: _phoneNumberController),
                CustomTextField(
                    hintText: "ul. 3 maja",
                    label: "Street Address",
                    controller: _streetAddressController),
                CustomTextField(hintText: "Gdansk", label: "City", controller: _cityController),
                CustomTextField(
                    hintText: "98-200", label: "Postal Code", controller: _postalCodeController),
                const SizedBox(height: AppSpacing.sm),
                PrimaryButton(
                  text: _isLoading == false ? "Sign up" : "Signing up...",
                  onPressed: () => _handleRegister(),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
