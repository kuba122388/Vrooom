import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';

import '../../../core/configs/theme/app_spacing.dart';

enum UserStatus { active, offline }

class UserInformationEntity extends StatelessWidget {
  final String profileImage;
  final String firstName;
  final String surname;
  final String email;
  final String phone;
  final UserStatus userStatus;

  const UserInformationEntity({
    super.key,
    required this.profileImage,
    required this.firstName,
    required this.surname,
    required this.email,
    required this.phone,
    required this.userStatus
  });

  String _getStatus(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return "Active";
      case UserStatus.offline:
        return "Offline";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.container.neutral700,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(128.0),
                  child: Image.asset(
                    profileImage,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 10.0),

                Expanded(
                  child: Text(
                    "$firstName $surname",
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.container.neutral750,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      padding: EdgeInsets.zero
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline_sharp,
                      size: 17,
                    )
                  ),
                ),

                const SizedBox(width: AppSpacing.xs),

                SizedBox(
                  width: 40,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          padding: EdgeInsets.zero
                      ),
                      child: const Icon(
                        Icons.person_remove_outlined,
                        size: 17,
                      )
                  ),
                )
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Table(
                    columnWidths: const {
                      0: FixedColumnWidth(60),
                      1: FlexColumnWidth()
                    },

                    children: [
                      TableRow(
                          children: [
                            Text(
                              "Email:",
                              style: TextStyle(
                                  letterSpacing: -0.5,
                                  color: AppColors.text.neutral400
                              ),
                            ),

                            Text(
                              email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  letterSpacing: -0.5,
                                  fontWeight: FontWeight.w600
                              ),
                            )
                          ]
                      ),

                      TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                              child: Text(
                                "Phone:",
                                style: TextStyle(
                                    letterSpacing: -0.5,
                                    color: AppColors.text.neutral400
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                              child: Text(
                                phone,
                                style: const TextStyle(
                                    letterSpacing: -0.5,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            )
                          ]
                      ),

                      TableRow(
                          children: [
                            Text(
                              "Status:",
                              style: TextStyle(
                                  letterSpacing: -0.5,
                                  color: AppColors.text.neutral400
                              ),
                            ),

                            Text(
                              _getStatus(userStatus),
                              style: const TextStyle(
                                  letterSpacing: -0.5,
                                  fontWeight: FontWeight.w600
                              ),
                            )
                          ]
                      )
                    ],
                  ),
                ),

                const SizedBox(width: AppSpacing.sm),

                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.container.neutral900,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0)
                  ),
                  child: const Text(
                    "View History",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5
                    ),
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}