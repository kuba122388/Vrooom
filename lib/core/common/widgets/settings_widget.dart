import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/data/sources/auth/auth_api_service.dart';
import 'package:vrooom/domain/entities/user.dart';
import 'package:vrooom/domain/usecases/auth/logout_usecase.dart';

import '../../../data/models/user_model.dart';
import '../../../domain/usecases/auth/change_password_usecase.dart';
import '../../../domain/usecases/user/edit_current_user_usecase.dart';
import '../../../domain/usecases/user/get_current_user_information_usecase.dart';
import '../../configs/assets/app_vectors.dart';
import '../../configs/di/service_locator.dart';
import '../../configs/theme/app_colors.dart';
import '../../configs/theme/app_spacing.dart';
import 'app_svg.dart';
import 'custom_text_field.dart';

class SettingsWidget extends StatefulWidget {
  final bool popScreen;
  final String? route;

  const SettingsWidget({super.key, required this.popScreen, this.route});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final EditCurrentUserUseCase _editCurrentUserUseCase = sl();
  final ChangePasswordUseCase _changePasswordUseCase = sl();
  final GetCurrentUserInformationUseCase _getCurrentUserInformationUseCase = sl();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _streetAddressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();

  bool _isLoading = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final result = await _getCurrentUserInformationUseCase();
    result.fold(
          (error) {
        _showError(error);
      },
          (user) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      },
    );
  }

  void _showError(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _validateAndSave() async {
    final changed = _nameController.text.isNotEmpty ||
        _surnameController.text.isNotEmpty ||
        _emailController.text.isNotEmpty ||
        _phoneNumberController.text.isNotEmpty ||
        _streetAddressController.text.isNotEmpty ||
        _cityController.text.isNotEmpty ||
        _postalCodeController.text.isNotEmpty ||
        _countryCodeController.text.isNotEmpty ||
        _currentPasswordController.text.isNotEmpty ||
        _newPasswordController.text.isNotEmpty ||
        _repeatPasswordController.text.isNotEmpty;

    if (widget.route != null) {
      final missingFields = <String>[];

      if (_nameController.text.isEmpty && _user!.name.isEmpty) {
        missingFields.add("Name");
      }
      if (_surnameController.text.isEmpty && _user!.surname.isEmpty) {
        missingFields.add("Surname");
      }
      if (_emailController.text.isEmpty && _user!.email.isEmpty) {
        missingFields.add("Email");
      }
      if (_phoneNumberController.text.isEmpty && _user!.phoneNumber.isEmpty) {
        missingFields.add("Phone number");
      }
      if (_streetAddressController.text.isEmpty && _user!.streetAddress.isEmpty) {
        missingFields.add("Street address");
      }
      if (_cityController.text.isEmpty && _user!.city.isEmpty) {
        missingFields.add("City");
      }
      if (_postalCodeController.text.isEmpty && _user!.postalCode.isEmpty) {
        missingFields.add("Postal code");
      }
      if (_countryCodeController.text.isEmpty && _user!.country.isEmpty) {
        missingFields.add("Country");
      }

      if (missingFields.isNotEmpty) {
        _showError("Please fill all fields: ${missingFields.join(", ")}");
        return;
      }
    }

    if (!changed && widget.route == null) {
      _showError("No changes were made.");
      return;
    }

    if (_emailController.text.isNotEmpty &&
        !RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(_emailController.text.trim())) {
      _showError("Please provide a valid email address.");
      return;
    }

    if (_phoneNumberController.text.isNotEmpty &&
        !RegExp(r'^[0-9+\s\-()]{7,20}$').hasMatch(_phoneNumberController.text.trim())) {
      _showError("Please provide a valid phone number.");
      return;
    }

    if (_postalCodeController.text.isNotEmpty &&
        !RegExp(r'^\d{2}-\d{3}$').hasMatch(_postalCodeController.text.trim())) {
      _showError("Please enter a valid postal code (e.g. 00-123).");
      return;
    }

    final wantsChangePassword = _currentPasswordController.text.isNotEmpty ||
        _newPasswordController.text.isNotEmpty ||
        _repeatPasswordController.text.isNotEmpty;

    if (wantsChangePassword) {
      if (_currentPasswordController.text.isEmpty) {
        _showError("Enter your current password to change it.");
        return;
      }

      final errors = AuthApiService.validatePassword(_newPasswordController.text);

      if (errors.isNotEmpty) {
        _showError(errors.join("\n"));
        return;
      }

      if (_newPasswordController.text != _repeatPasswordController.text) {
        _showError("New passwords must be identical.");
        return;
      }

      try {
        setState(() {
          _isLoading = true;
        });

        final result = await _changePasswordUseCase(
          oldPassword: _currentPasswordController.text.trim(),
          newPassword: _newPasswordController.text.trim(),
        );

        bool isError = false;

        result.fold(
              (error) {
            _showError(error.substring(11));
            setState(() {
              _isLoading = false;
            });
            isError = true;
          },
              (success) {
            _showError("The password has been successfully changed");
          },
        );

        if (isError) return;
      } catch (e) {
        _showError("Update failed: ${e.toString()}");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    final userToUpdate = UserModel(
      customerID: _user!.customerID,
      name: _nameController.text.isNotEmpty ? _nameController.text.trim() : _user!.name,
      surname: _surnameController.text.isNotEmpty ? _surnameController.text.trim() : _user!.surname,
      email: _emailController.text.isNotEmpty ? _emailController.text.trim() : _user!.email,
      phoneNumber: _phoneNumberController.text.isNotEmpty ? _phoneNumberController.text.trim() : _user!.phoneNumber,
      streetAddress: _streetAddressController.text.isNotEmpty ? _streetAddressController.text.trim() : _user!.streetAddress,
      city: _cityController.text.isNotEmpty ? _cityController.text.trim() : _user!.city,
      postalCode: _postalCodeController.text.isNotEmpty ? _postalCodeController.text.trim() : _user!.postalCode,
      country: _countryCodeController.text.isNotEmpty ? _countryCodeController.text.trim() : _user!.country,
      role: _user!.role,
    );

    try {
      setState(() => _isLoading = true);

      await _editCurrentUserUseCase(request: userToUpdate);

      if (!context.mounted) return;
      if (widget.route != null)  Navigator.pushReplacementNamed(context, widget.route as String);
      if (widget.popScreen) Navigator.pop(context, true);
    } catch (e) {
      _showError("Update failed: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              hintText: _user!.name,
              label: "Name",
              leadingIcon: const AppSvg(asset: AppVectors.person),
              controller: _nameController,
            ),
            CustomTextField(
              hintText: _user!.surname,
              label: "Surname",
              leadingIcon: const AppSvg(asset: AppVectors.person),
              controller: _surnameController,
            ),
            CustomTextField(
              hintText: _user!.email,
              label: "Email Address",
              leadingIcon: const AppSvg(asset: AppVectors.mail),
              controller: _emailController,
            ),
            CustomTextField(
              hintText: _user!.phoneNumber,
              label: "Phone Number",
              leadingIcon: const AppSvg(asset: AppVectors.phone),
              controller: _phoneNumberController,
            ),
            CustomTextField(
              hintText: _user!.streetAddress,
              label: "Street Address",
              leadingIcon: const AppSvg(asset: AppVectors.mapPin),
              controller: _streetAddressController,
            ),
            CustomTextField(
              hintText: _user!.city,
              label: "City",
              leadingIcon: const AppSvg(asset: AppVectors.mapPin),
              controller: _cityController,
            ),
            CustomTextField(
              hintText: _user!.postalCode,
              label: "Postal Code",
              leadingIcon: const AppSvg(asset: AppVectors.mapPin),
              controller: _postalCodeController,
            ),
            CustomTextField(
              hintText: _user!.country,
              label: "Country",
              leadingIcon: const AppSvg(asset: AppVectors.mapPin),
              controller: _countryCodeController,
            ),

            if (widget.route == null) ... [
              const SizedBox(height: AppSpacing.md),
              const Text(
                "Change Password",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              CustomTextField(
                hintText: "Current password",
                label: "Current Password",
                leadingIcon: const AppSvg(asset: AppVectors.key),
                isPassword: true,
                controller: _currentPasswordController,
              ),
              CustomTextField(
                hintText: "New password",
                label: "New Password",
                leadingIcon: const AppSvg(asset: AppVectors.key),
                isPassword: true,
                controller: _newPasswordController,
              ),
              CustomTextField(
                hintText: "Repeat Password",
                label: "Repeat Password",
                leadingIcon: const AppSvg(asset: AppVectors.key),
                isPassword: true,
                controller: _repeatPasswordController,
              )
            ],

            PrimaryButton(
                text: "Save",
                onPressed: _validateAndSave
            ),
          ],
        ),
      ),
    );
  }
}