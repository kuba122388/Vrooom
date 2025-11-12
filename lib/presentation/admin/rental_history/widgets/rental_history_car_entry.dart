import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  const RentalHistoryCarEntry({
    super.key,
    this.onTap,
    required this.booking,
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

  @override
  Widget build(BuildContext context) {
    final rentalStatus = _getRentalStatus(booking);

    return GestureDetector(
      onTap: onTap,
      child: CarCard(
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
