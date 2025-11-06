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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
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
                hintText: "${_user?.name} ${_user?.surname}",
                label: "Full Name",
                leadingIcon: const AppSvg(asset: AppVectors.person),
                controller: _nameController,
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
                hintText: "${_user?.streetAddress}, ${_user?.postalCode} ${_user?.city}",
                label: "Address",
                leadingIcon: const AppSvg(asset: AppVectors.mapPin),
                controller: _addressController,
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
                onPressed: () async {
                  final user = UserModel(
                      customerID: _user!.customerID,
                      name: _nameController.text.isNotEmpty ? _nameController.text.split(' ').first : _user!.name,
                      surname: _nameController.text.isNotEmpty ? _nameController.text.split(' ').last : _user!.surname,
                      email: _emailController.text.isNotEmpty ? _emailController.text.trim() : _user!.email,
                      phoneNumber: _phoneNumberController.text.isNotEmpty ? _phoneNumberController.text.trim() : _user!.phoneNumber,
                      streetAddress: _addressController.text.isNotEmpty ? _addressController.text.split(',').first : _user!.streetAddress,
                      city: _addressController.text.isNotEmpty ? extractCity(_addressController.text.trim()) : _user!.city,
                      postalCode: _addressController.text.isNotEmpty ? extractPostalCode(_addressController.text.trim()) : _user!.postalCode,
                      country: _user!.country,
                      role: _user!.role
                  );

                  await _editCurrentUserUseCase(request: user);

                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String extractPostalCode(String address) {
    final regex = RegExp(r'\b\d{2}-\d{3}\b');
    final match = regex.firstMatch(address);
    return match?.group(0) ?? '';
  }

  String extractCity(String address) {
    final regex = RegExp(r'\d{2}-\d{3}\s+([A-Za-zÀ-Żà-ż\s\-]+)$');
    final match = regex.firstMatch(address);
    return match?.group(1)?.trim() ?? '';
  }
}
