import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/image_picker_widget.dart';
import 'package:vrooom/core/common/widgets/info_section_card.dart';
import 'package:vrooom/core/configs/assets/app_images.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/domain/entities/booking.dart';
import 'package:vrooom/domain/entities/user.dart';
import 'package:vrooom/domain/usecases/auth/logout_usecase.dart';
import 'package:vrooom/domain/usecases/booking/get_recent_rentals_for_user_usecase.dart';
import 'package:vrooom/domain/usecases/user/download_user_profile_picture_usecase.dart';
import 'package:vrooom/domain/usecases/user/get_current_user_information_usecase.dart';
import 'package:vrooom/domain/usecases/user/upload_user_profile_picture_usecase.dart';
import 'package:vrooom/presentation/user/profile/widgets/car_status_row.dart';
import 'package:vrooom/presentation/user/profile/widgets/settings_tile.dart';

import '../../../../core/common/widgets/app_svg.dart';
import '../../../../core/common/widgets/primary_button.dart';
import '../../../../core/configs/assets/app_vectors.dart';
import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/enums/rental_status.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final LogoutUseCase _logoutUseCase = sl();
  final GetCurrentUserInformationUseCase _getCurrentUserInformationUseCase = sl();
  final GetRecentRentalsForUserUseCase _getRecentRentalsForUserUseCase = sl();
  final UploadUserProfilePictureUseCase _uploadUserProfilePictureUseCase = sl();
  final DownloadUserProfilePictureUseCase _downloadUserProfilePictureUseCase = sl();

  User? _user;
  List<Booking> _bookings = [];
  bool _isLoading = true;
  Uint8List? _profilePic;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final userResult = await _getCurrentUserInformationUseCase();
    userResult.fold(
      (error) {},
      (user) {
        setState(() {
          _user = user;
        });
      },
    );

    final profileResult = await _downloadUserProfilePictureUseCase(userId: _user!.customerID);
    profileResult.fold(
      (error) {},
      (profilePic) {
        setState(() {
          _profilePic = profilePic;
        });
      },
    );

    final bookingResult = await _getRecentRentalsForUserUseCase();
    bookingResult.fold(
      (error) {},
      (bookingList) {
        setState(() {
          _bookings = bookingList;
          _isLoading = false;
        });
      },
    );
  }

  RentalStatus _getRentalStatus(Booking booking) {
    switch (booking.bookingStatus) {
      case "Pending":
        return RentalStatus.pending;
      case "Cancelled":
        return RentalStatus.cancelled;
      default:
        return RentalStatus.completed;
    }
  }

  void _showError(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _updateProfilePicture() async {
    try {
      final File? image = await ImagePickerWidget.pickImage();

      if (image == null) return;

      setState(() => _isLoading = true);

      final uploadResult = await _uploadUserProfilePictureUseCase(
        userId: _user!.customerID,
        imageFile: image,
      );

      final uploadError = uploadResult.fold((error) => error, (_) => null);
      if (uploadError != null) {
        _showError("Upload failed: $uploadError");
        setState(() => _isLoading = false);
        return;
      }

      final downloadResult = await _downloadUserProfilePictureUseCase(
        userId: _user!.customerID,
      );

      downloadResult.fold(
        (error) {
          _showError("Failed to load profile picture: $error");
        },
        (imageFile) {
          setState(() {
            _profilePic = imageFile;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile picture updated successfully")),
          );
        },
      );
    } catch (e) {
      _showError("Unexpected error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    final result = await _logoutUseCase();

    if (!mounted) return;

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully logged out!"),
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.signin,
          (route) => false,
        );
      },
    );
  }

  Future<void> _showLogoutConfirmation() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Text('Log Out'),
            Spacer(),
            AppSvg(
              asset: AppVectors.close,
              color: Colors.white,
            )
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to log out?'),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              onPressed: () => Navigator.pop(context, true),
              text: 'Log Out',
            ),
          ],
        ),
      ),
    );

    if (shouldLogout == true) {
      await _handleLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
      : SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            InfoSectionCard(
              child: Row(
                children: [
                  SizedBox(
                    height: 60.0,
                    width: 60.0,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: _profilePic == null
                            ? Image.asset(
                                AppImages.person,
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                              )
                            : Image.memory(
                                _profilePic!,
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                              )
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _updateProfilePicture,
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_user?.name} ${_user?.surname}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        _user!.email,
                        style: TextStyle(
                          color: AppColors.text.neutral400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            InfoSectionCard(
              title: "Rental History",
              child: _bookings.isNotEmpty
                ? Column(
                  children: _bookings
                      .map((booking) => CarStatusRow(carName: "${booking.vehicleMake} ${booking.vehicleModel}", status: _getRentalStatus(booking)))
                      .toList(),
                )
                : const Center(
                  child: Text(
                    "You don't have rental history",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  )
                ),
            ),
            const SizedBox(height: AppSpacing.md),
            InfoSectionCard(
              title: "Settings",
              child: Column(
                children: [
                  SettingsTile(
                    icon: const AppSvg(asset: AppVectors.settings),
                    label: "Edit profile details",
                    onTap: () async {
                      final updated = await Navigator.pushNamed(context, AppRoutes.editProfileDetails);
                      if (updated == true) {
                        _load();
                      }
                    },
                  ),
                  SettingsTile(
                    icon: const AppSvg(asset: AppVectors.privacyPolicy),
                    label: "Privacy Policy",
                    onTap: () => Navigator.pushNamed(context, AppRoutes.privacyPolicy),
                  ),
                  SettingsTile(
                    icon: const AppSvg(asset: AppVectors.contact),
                    label: "Contact",
                    onTap: () => Navigator.pushNamed(context, AppRoutes.contact),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              text: "Log Out",
              onPressed: () => _showLogoutConfirmation(),
            ),
          ],
        ),
      ),
    );
  }
}
