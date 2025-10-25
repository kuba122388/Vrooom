import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';

import '../../../core/configs/assets/app_vectors.dart';
import '../../../core/configs/theme/app_spacing.dart';
import '../../../core/enums/rental_status.dart';

class RentalInformationEntry extends StatelessWidget {
  final String profileImage;
  final String firstName;
  final String surname;
  final String reservationID;
  final DateTime pickupDate;
  final DateTime returnDate;
  final RentalStatus rentalStatus;
  final String carImage;
  final String model;
  final int productionYear;

  const RentalInformationEntry(
      {super.key,
      required this.profileImage,
      required this.firstName,
      required this.surname,
      required this.reservationID,
      required this.pickupDate,
      required this.returnDate,
      required this.rentalStatus,
      required this.carImage,
      required this.model,
      required this.productionYear});

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
                  child: Image.asset(
                    profileImage,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
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
                          const AppSvg(
                            asset: AppVectors.phone,
                            color: AppColors.primary,
                            width: 20.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
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
                            reservationID,
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
                  onPressed: () {},
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
                  onPressed: () {},
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
}
