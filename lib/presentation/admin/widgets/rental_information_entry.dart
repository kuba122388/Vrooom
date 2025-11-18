import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/domain/usecases/booking/accept_booking_usecase.dart';
import 'package:vrooom/domain/usecases/booking/cancel_booking_usecase.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/assets/app_vectors.dart';
import '../../../core/configs/di/service_locator.dart';
import '../../../core/configs/theme/app_spacing.dart';
import '../../../core/enums/rental_status.dart';

class RentalInformationEntry extends StatelessWidget {
  final Uint8List? profileImage;
  final String firstName;
  final String surname;
  final int reservationID;
  final DateTime pickupDate;
  final DateTime returnDate;
  final RentalStatus rentalStatus;
  final String carImage;
  final String model;
  final int productionYear;
  final String phoneNumber;
  final VoidCallback? onBookingChanged;

  RentalInformationEntry({
    super.key,
    required this.profileImage,
    required this.firstName,
    required this.surname,
    required this.reservationID,
    required this.pickupDate,
    required this.returnDate,
    required this.rentalStatus,
    required this.carImage,
    required this.model,
    required this.productionYear,
    required this.phoneNumber,
    this.onBookingChanged,
  });

  final CancelBookingUseCase _cancelBookingUseCase = sl();
  final AcceptBookingUseCase _acceptBookingUseCase = sl();

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.container.neutral700, borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(128.0),
                  child: profileImage == null
                      ? Image.asset(
                          AppImages.person,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                        )
                      : Image.memory(
                          profileImage!,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                        ),
                ),
                const SizedBox(width: 10.0),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "$firstName\n$surname",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          InkWell(
                            onTap: () => _makePhoneCall(phoneNumber),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: AppSvg(
                                asset: AppVectors.phone,
                                color: AppColors.primary,
                                width: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    carImage,
                    width: 80,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Table(
                    columnWidths: const {0: FixedColumnWidth(100), 1: FlexColumnWidth()},
                    children: [
                      TableRow(
                        children: [
                          Text(
                            "Reservation ID:",
                            style: TextStyle(letterSpacing: -0.5, color: AppColors.text.neutral400),
                          ),
                          Text(
                            reservationID.toString(),
                            style:
                                const TextStyle(letterSpacing: -0.5, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                            child: Text(
                              "Pickup date:",
                              style:
                                  TextStyle(letterSpacing: -0.5, color: AppColors.text.neutral400),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                            child: Text(
                              pickupDate.toString().split(' ').first,
                              style:
                                  const TextStyle(letterSpacing: -0.5, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text(
                            "Return Date:",
                            style: TextStyle(letterSpacing: -0.5, color: AppColors.text.neutral400),
                          ),
                          Text(
                            returnDate.toString().split(' ').first,
                            style:
                                const TextStyle(letterSpacing: -0.5, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      model,
                      style: const TextStyle(letterSpacing: -0.5, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      "($productionYear)",
                      style: const TextStyle(letterSpacing: -0.5),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: rentalStatus.color, borderRadius: BorderRadius.circular(64.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: Text(
                      rentalStatus.displayText,
                      style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.5),
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _showCancelDialog(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0)),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.5),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                ElevatedButton(
                  onPressed: () => _showConfirmDialog(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.container.progress200,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0)),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.5),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Cancel Reservation",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to cancel the reservation for $firstName $surname\n(ID: $reservationID)?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "No, Go Back",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _cancelBookingUseCase(reservationID);
                Navigator.of(context).pop();
                onBookingChanged?.call();
              },
              child: const Text(
                "Yes, Cancel",
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Confirm Reservation",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to confirm the reservation for $firstName $surname\n(ID: $reservationID)?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Not Yet",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _acceptBookingUseCase(reservationID);
                Navigator.of(context).pop();
                onBookingChanged?.call();
              },
              child: const Text(
                "Yes, Confirm",
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}
