import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/app_spacing.dart';

enum CodeStatus { active, inactive }

class DiscountCodeEntry extends StatelessWidget {
  final String code;
  final int discount;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final CodeStatus codeStatus;

  const DiscountCodeEntry({
    super.key,
    required this.code,
    required this.discount,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.codeStatus
  });

  String _getStatus(CodeStatus status) {
    switch (status) {
      case CodeStatus.active:
        return "Active";
      case CodeStatus.inactive:
        return "Inactive";
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Table(
              columnWidths: const {
                0: FixedColumnWidth(100),
                1: FlexColumnWidth()
              },

              children: [
                TableRow(
                    children: [
                      Text(
                        "CODE:",
                        style: TextStyle(
                            letterSpacing: -0.5,
                            color: AppColors.text.neutral400
                        ),
                      ),

                      Text(
                        code,
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
                          "Discount:",
                          style: TextStyle(
                              letterSpacing: -0.5,
                              color: AppColors.text.neutral400
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                        child: Text(
                          discount.toString(),
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
                        "Type:",
                        style: TextStyle(
                            letterSpacing: -0.5,
                            color: AppColors.text.neutral400
                        ),
                      ),

                      Text(
                        type,
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
                          "Validity:",
                          style: TextStyle(
                              letterSpacing: -0.5,
                              color: AppColors.text.neutral400
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                        child: Text(
                          "${startDate.toString().split(' ').first} - ${endDate.toString().split(' ').first}",
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
                        _getStatus(codeStatus),
                        style: const TextStyle(
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.w600
                        ),
                      )
                    ]
                )
              ],
            ),

            const SizedBox(width: AppSpacing.xs),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.container.neutral900,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)
                      ),
                      padding: EdgeInsets.zero
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 17,
                    )
                  ),
                ),

                const SizedBox(width: AppSpacing.xs),

                SizedBox(
                  width: 30,
                  height: 30,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          padding: EdgeInsets.zero
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 17,
                      )
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}