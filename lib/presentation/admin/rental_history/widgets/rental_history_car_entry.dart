import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

import '../../../../core/configs/assets/app_images.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../../core/enums/rental_status.dart';
import '../../widgets/car_card.dart';

class RentalHistoryCarEntry extends StatelessWidget {
  final String rentalID;
  final String carName;
  final String carImage;
  final DateTime startDate;
  final DateTime endDate;
  final RentalStatus rentalStatus;
  final String customerName;
  final Uint8List? customerPicture;

  const RentalHistoryCarEntry({
    super.key,
    required this.rentalID,
    required this.carName,
    required this.carImage,
    required this.startDate,
    required this.endDate,
    required this.rentalStatus,
    required this.customerName,
    required this.customerPicture
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
      carImage: carImage,
      carName: carName,
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
              child: customerPicture == null
                  ? Image.asset(
                AppImages.person,
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              )
                  : Image.memory(
                customerPicture!,
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              )
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(customerName),
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
