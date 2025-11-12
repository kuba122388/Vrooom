import 'package:flutter/material.dart';
import 'package:vrooom/domain/entities/discount_code.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/app_spacing.dart';

enum CodeStatus { active, inactive }

class DiscountCodeEntry extends StatelessWidget {
  final DiscountCode discountCode;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const DiscountCodeEntry({
    super.key,
    required this.discountCode,
    required this.onEditPressed,
    required this.onDeletePressed,
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
    final codeStatus = (discountCode.active ?? false) ? CodeStatus.active : CodeStatus.inactive;
    final type = (discountCode.percentage ?? false) ? "Percentage" : "Fixed";

    return Container(
      decoration: BoxDecoration(
          color: AppColors.container.neutral700, borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Table(
              columnWidths: const {0: FixedColumnWidth(100), 1: FlexColumnWidth()},
              children: [
                TableRow(
                  children: [
                    Text(
                      "CODE:",
                      style: TextStyle(letterSpacing: -0.5, color: AppColors.text.neutral400),
                    ),
                    Text(
                      discountCode.code ?? "",
                      style: const TextStyle(letterSpacing: -0.5, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                      child: Text(
                        "Discount:",
                        style: TextStyle(letterSpacing: -0.5, color: AppColors.text.neutral400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                      child: Text(
                        discountCode.value?.toString() ?? "0.0",
                        style: const TextStyle(letterSpacing: -0.5, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      "Type:",
                      style: TextStyle(letterSpacing: -0.5, color: AppColors.text.neutral400),
                    ),
                    Text(
                      type,
                      style: const TextStyle(letterSpacing: -0.5, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      "Status:",
                      style: TextStyle(letterSpacing: -0.5, color: AppColors.text.neutral400),
                    ),
                    Text(
                      _getStatus(codeStatus),
                      style: const TextStyle(letterSpacing: -0.5, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: onEditPressed,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.container.neutral900,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        padding: EdgeInsets.zero),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 17,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: onDeletePressed,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        padding: EdgeInsets.zero),
                    child: const Icon(
                      Icons.delete_outline,
                      size: 17,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}