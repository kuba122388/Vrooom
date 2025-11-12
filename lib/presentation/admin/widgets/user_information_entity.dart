import 'package:flutter/material.dart';
import 'package:vrooom/core/common/utils/email_launcher.dart';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/configs/assets/app_images.dart';
import 'package:vrooom/core/configs/assets/app_vectors.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/domain/entities/user.dart';
import 'package:vrooom/domain/usecases/user/download_user_profile_picture_usecase.dart';
import 'dart:typed_data';

import '../../../core/configs/di/service_locator.dart';
import '../../../core/configs/theme/app_spacing.dart';
import '../../../domain/usecases/user/delete_user_by_id_usecase.dart';

class UserInformationEntity extends StatefulWidget {
  final User user;
  final Future<void> Function() callback;

  const UserInformationEntity({super.key, required this.user, required this.callback});

  @override
  State<UserInformationEntity> createState() => _UserInformationEntityState();
}

class _UserInformationEntityState extends State<UserInformationEntity> {
  final DeleteUserByIdUseCase _deleteUserByIdUseCase = sl();
  final DownloadUserProfilePictureUseCase _downloadUserProfilePictureUseCase = sl();

  bool _isLoading = false;
  Uint8List? _profilePic;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _downloadUserProfilePictureUseCase(userId: widget.user.customerID);

      result.fold(
        (error) {},
        (profilePic) {
          setState(() {
            _profilePic = profilePic;
          });
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.container.neutral700, borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: _isLoading
        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
        : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: _profilePic == null
                    ? Image.asset(
                        AppImages.person,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      )
                    : Image.memory(
                        _profilePic!,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      )
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    "${widget.user.name} ${widget.user.surname}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => EmailLauncher.open(widget.user.email),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.container.neutral750,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        padding: EdgeInsets.zero),
                    child: const Icon(
                      Icons.chat_bubble_outline_sharp,
                      size: 17,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Confirmation",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: const AppSvg(
                                    asset: AppVectors.close,
                                    color: AppColors.primary,
                                  ),
                                )
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Do you really want to delete:",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  "${widget.user.name} ${widget.user.surname}",
                                  style:
                                      const TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0),
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await _deleteUserByIdUseCase(widget.user.customerID);
                                  widget.callback();
                                  Navigator.of(context).pop();
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(AppColors.primary),
                                ),
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        padding: EdgeInsets.zero),
                    child: const Icon(
                      Icons.person_remove_outlined,
                      size: 17,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Table(
                    columnWidths: const {0: FixedColumnWidth(60), 1: FlexColumnWidth()},
                    children: [
                      TableRow(
                        children: [
                          Text(
                            "Email:",
                            style: TextStyle(letterSpacing: -0.5, color: AppColors.text.neutral400),
                          ),
                          Text(
                            widget.user.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                const TextStyle(letterSpacing: -0.5, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      _singleRow("Phone: ", widget.user.phoneNumber),
                      _singleRow("Street: ", widget.user.streetAddress),
                      _singleRow("Postal: ", widget.user.postalCode),
                      _singleRow("City: ", widget.user.city),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.userRentalHistory, arguments: widget.user),
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.container.neutral900,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0)),
                  child: const Text(
                    "View History",
                    style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _singleRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xxs),
          child: Text(
            label,
            style: TextStyle(letterSpacing: -0.5, color: AppColors.text.neutral400),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xxs),
          child: Text(
            value,
            style: const TextStyle(letterSpacing: -0.5, fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }
}
