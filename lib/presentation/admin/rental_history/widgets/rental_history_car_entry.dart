import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/configs/assets/app_images.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../../core/enums/rental_status.dart';
import '../../widgets/car_card.dart';

class RentalHistoryCarEntry extends StatelessWidget {
  final String rentalID;
  final DateTime startDate;
  final DateTime endDate;
  final RentalStatus rentalStatus;

  const RentalHistoryCarEntry({
    super.key,
    required this.rentalID,
    required this.startDate,
    required this.endDate,
    required this.rentalStatus,
  });

  TableRow _buildRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: AppSpacing.xxs,
            right: AppSpacing.xxs,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.text.neutral500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
          child: Text(value),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CarCard(
      carImage: AppImages.mercedes,
      carName: "Mercedes-Benz C-Class",
      rightSide: Table(
        columnWidths: const {
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth(),
        },
        children: [
          _buildRow("Rental ID", rentalID),
          _buildRow("Start date", DateFormat("dd-MM-yyyy").format(startDate)),
          _buildRow("End date", DateFormat("dd-MM-yyyy").format(endDate)),
        ],
      ),
      bottom: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.asset(
                AppImages.person,
                height: 50.0,
                width: 50.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Text("John Doe"),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: rentalStatus.color,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Text(rentalStatus.displayText),
              ),
            )
          ],
        ),
      ),
    );
  }
}
