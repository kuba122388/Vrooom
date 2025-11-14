import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vrooom/core/common/widgets/animated_button_wrapper.dart';
import 'dart:typed_data';

import '../../../../core/configs/assets/app_images.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../../core/enums/rental_status.dart';
import '../../../../domain/entities/booking.dart';
import '../../widgets/car_card.dart';

class RentalHistoryCarEntry extends StatelessWidget {
  final Booking booking;
  final Uint8List? customerPicture;
  final VoidCallback? onTap;
  final double customerPictureSize;
  final double vehicleImageSize;

  const RentalHistoryCarEntry({
    super.key,
    this.onTap,
    required this.booking,
    required this.customerPicture,
    this.customerPictureSize = 60,
    this.vehicleImageSize = 120
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
    final rentalStatus = RentalStatus.getRentalStatus(booking.bookingStatus as String);

    return AnimatedButtonWrapper(
      borderRadius: BorderRadius.circular(10.0),
      onTap: onTap,
      child: CarCard(
        carImageSize: vehicleImageSize,
        carImage: booking.vehicleImage as String,
        carName: "${booking.vehicleMake} ${booking.vehicleModel}",
        rightSide: Table(
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
          },
          children: [
            _buildRow("Rental ID", booking.bookingID.toString()),
            _buildRow("Start date", DateFormat("dd-MM-yyyy").format(booking.startDate as DateTime)),
            _buildRow("End date", DateFormat("dd-MM-yyyy").format(booking.endDate as DateTime)),
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
                  width: customerPictureSize,
                  height: customerPictureSize,
                )
                    : Image.memory(
                  customerPicture!,
                  fit: BoxFit.cover,
                  width: customerPictureSize,
                  height: customerPictureSize,
                )
              ),
              const SizedBox(width: AppSpacing.xs),
              Text("${booking.customerName} ${booking.customerSurname}"),
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
      ),
    );
  }
}
