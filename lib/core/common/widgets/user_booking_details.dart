import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/info_section_card.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/common/widgets/title_widget.dart';
import 'package:vrooom/core/configs/assets/app_vectors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/domain/entities/booking.dart';
import 'package:vrooom/presentation/user/bookings/widgets/info_row.dart';

import '../../configs/theme/app_colors.dart';
import '../../enums/rental_status.dart';

class UserBookingDetails extends StatefulWidget {
  final Booking booking;
  final String title;

  const UserBookingDetails({super.key, required this.booking, required this.title});

  @override
  State<UserBookingDetails> createState() => _UserBookingDetailsState();
}

class _UserBookingDetailsState extends State<UserBookingDetails> {
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
    final status = _getRentalStatus(widget.booking);

    List<InfoRow> data = [
      InfoRow(title: "Pickup Location", icon: AppVectors.mapPin, text: widget.booking.pickupAddress?.split(", ").last as String),
      InfoRow(title: "Drop-off Location", icon: AppVectors.mapPin, text: widget.booking.dropOffAddress?.split(", ").last as String),
      InfoRow(title: "Pickup Date", icon: AppVectors.calendar, text: DateFormat('dd-MM-yyyy').format(widget.booking.startDate as DateTime)),
      InfoRow(title: "Planned Drop-off Date", icon: AppVectors.calendar, text: DateFormat('dd-MM-yyyy').format(widget.booking.endDate as DateTime)),

      if (widget.booking.actualReturnDate != null) ... {
        InfoRow(title: "Real Drop-off Date", icon: AppVectors.calendar, text: DateFormat('dd-MM-yyyy').format(widget.booking.actualReturnDate as DateTime), color: AppColors.primary),
      }
    ];

    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  widget.booking.vehicleImage as String,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),

                Positioned(
                  left: 15,
                  bottom: -5,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: TitleWidget(title: "${widget.booking.vehicleMake} ${widget.booking.vehicleModel}")
                  )
                ),
              ],
            ),

            const PreferredSize(
              preferredSize: Size.fromHeight(1.0),
              child: Divider(
                height: 1,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Rental ID: ${widget.booking.bookingID}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const Spacer(),

                      Container(
                        decoration: BoxDecoration(color: status.color, borderRadius: BorderRadius.circular(10.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 3.0,
                          ),
                          child: Text(
                            status.displayText,
                            style: const TextStyle(
                              fontSize: 12.0,
                              letterSpacing: -0.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  if (widget.booking.notes!.isNotEmpty) ... [
                    InfoSectionCard(
                      title: "Notes from Staff",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.booking.notes as String),

                          if (widget.booking.penalty != 0) ... [
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              children: [
                                Text(
                                  "Penalty: \$${widget.booking.penalty}",
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),

                                const Spacer(),

                                const PrimaryButton(text: "Pay penalty", width: 140, height: 40)
                              ],
                            )
                          ],
                        ],
                      )
                    ),

                    const SizedBox(height: AppSpacing.md),
                  ],

                  InfoSectionCard(
                      title: "Dates & Locations",
                      child: Column(
                        children: List.generate(
                          data.length * 2 - 1,
                              (index) {
                            if (index.isEven) {
                              return data[index ~/ 2];
                            } else {
                              return const SizedBox(height: AppSpacing.xs);
                            }
                          },
                        ),
                      )
                  ),

                  const SizedBox(height: AppSpacing.md),

                  InfoSectionCard(
                    title: "Payment & Insurance",
                    child: Column(
                      children: [
                        InfoRow(title: "Insurance", text: "\$${widget.booking.insuranceCost?.toStringAsFixed(2)}"),
                        const SizedBox(height: AppSpacing.xs),
                        InfoRow(title: "Total Price", text: "\$${widget.booking.totalAmount?.toStringAsFixed(2)}", color: AppColors.primary)
                      ],
                    )
                  ),

                  const SizedBox(height: AppSpacing.md),

                  if (widget.booking.bookingStatus == 'Pending') ... {
                    const PrimaryButton(text: "Cancel Booking")
                  }
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}