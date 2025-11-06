import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/custom_text_field.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/assets/app_vectors.dart';
import 'package:vrooom/data/models/user_model.dart';
import 'package:vrooom/domain/usecases/user/edit_current_user_usecase.dart';

import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/usecases/user/get_current_user_information_usecase.dart';

class EditProfileDetails extends StatefulWidget {
  const EditProfileDetails({super.key});

  @override
  State<EditProfileDetails> createState() => _EditProfileDetailsState();
}

class _EditProfileDetailsState extends State<EditProfileDetails> {
  final GetCurrentUserInformationUseCase _getCurrentUserInformationUseCase = sl();
  final EditCurrentUserUseCase _editCurrentUserUseCase = sl();
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
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final result = await _getCurrentUserInformationUseCase();
    result.fold(
          (error) {},
          (user) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      },
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

    if (!changed) {
      _showError("Nie wprowadzono żadnych zmian.");
      return;
    }

    if (_emailController.text.isNotEmpty &&
        !RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(_emailController.text.trim())) {
      _showError("Podaj poprawny adres e-mail.");
      return;
    }

    if (_phoneNumberController.text.isNotEmpty &&
        !RegExp(r'^[0-9+\s\-()]{7,20}$').hasMatch(_phoneNumberController.text.trim())) {
      _showError("Podaj poprawny numer telefonu.");
      return;
    }

    if (_postalCodeController.text.isNotEmpty &&
        !RegExp(r'^\d{2}-\d{3}$').hasMatch(_postalCodeController.text.trim())) {
      _showError("Podaj poprawny kod pocztowy (np. 00-123).");
      return;
    }

    final wantsChangePassword = _currentPasswordController.text.isNotEmpty ||
        _newPasswordController.text.isNotEmpty ||
        _repeatPasswordController.text.isNotEmpty;

    if (wantsChangePassword) {
      if (_currentPasswordController.text.isEmpty) {
        _showError("Podaj obecne hasło, aby je zmienić.");
        return;
      }
      if (_newPasswordController.text.length < 6) {
        _showError("Nowe hasło musi mieć co najmniej 6 znaków.");
        return;
      }
      if (_newPasswordController.text != _repeatPasswordController.text) {
        _showError("Nowe hasła muszą być identyczne.");
        return;
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
      Navigator.pop(context);
    } catch (e) {
      _showError("Aktualizacja nie powiodła się: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Edit Profile Details"),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
        : SingleChildScrollView(
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
              ),
              PrimaryButton(
                text: "Save",
                onPressed: _validateAndSave
              ),
            ],
          ),
        ),
      ),
    );
  }
}
