import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/info_section_card.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/common/widgets/title_widget.dart';
import 'package:vrooom/core/configs/assets/app_vectors.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/domain/entities/booking.dart';
import 'package:vrooom/domain/usecases/booking/cancel_booking_usecase.dart';
import 'package:vrooom/domain/usecases/booking/finish_booking_usecase.dart';
import 'package:vrooom/domain/usecases/booking/pay_penalty_usecase.dart';
import 'package:vrooom/domain/usecases/payment/create_stripe_session_usecase.dart';
import 'package:vrooom/presentation/user/bookings/widgets/info_row.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../configs/di/service_locator.dart';
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
  final CancelBookingUseCase _cancelBookingUseCase = sl();
  final FinishBookingUseCase _finishBookingUseCase = sl();
  final CreateStripeSessionUseCase _createStripeSessionUseCase = sl();
  final PayPenaltyUsecase _payPenaltyUsecase = sl();

  @override
  Widget build(BuildContext context) {
    final status = RentalStatus.fromString(widget.booking.bookingStatus!);

    List<InfoRow> data = [
      InfoRow(
        title: "Pickup Location",
        icon: AppVectors.mapPin,
        text: widget.booking.pickupAddress?.split(", ").join(",\n") as String,
        textAlign: TextAlign.right,
        iconSize: 16.0,
      ),
      InfoRow(
        title: "Drop-off Location",
        icon: AppVectors.mapPin,
        text: widget.booking.dropOffAddress?.split(", ").join(",\n") as String,
        textAlign: TextAlign.right,
        iconSize: 16.0,
      ),
      InfoRow(
        title: "Pickup Date",
        icon: AppVectors.calendar,
        text: DateFormat('dd-MM-yyyy').format(widget.booking.startDate as DateTime),
        iconSize: 16.0,
      ),
      InfoRow(
        title: "Planned Drop-off Date",
        icon: AppVectors.calendar,
        text: DateFormat('dd-MM-yyyy').format(widget.booking.endDate as DateTime),
        iconSize: 16.0,
      ),
      if (widget.booking.actualReturnDate != null) ...{
        InfoRow(
          title: "Real Drop-off Date",
          icon: AppVectors.calendar,
          text: DateFormat('dd-MM-yyyy').format(widget.booking.actualReturnDate as DateTime),
          color: AppColors.primary,
          iconSize: 16.0,
        ),
      }
    ];

    void openStripeCheckout() async {
      try {
        final sessionResponse = await _createStripeSessionUseCase(widget.booking.penalty!);

        if (!mounted) return;

        sessionResponse.fold(
          (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Payment error: $error")),
            );
          },
          (stripeSession) async {
            final WebViewController controller = WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setNavigationDelegate(
                NavigationDelegate(
                  onNavigationRequest: (NavigationRequest request) async {
                    if (request.url.contains("vrooom-app.com/?success=true")) {
                      Navigator.pushNamed(context, AppRoutes.paymentSuccess);
                      await _payPenaltyUsecase(widget.booking.bookingID!);
                      return NavigationDecision.prevent;
                    }

                    if (request.url.contains("vrooom-app.com/?canceled=true")) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Payment cancelled")),
                      );
                      return NavigationDecision.prevent;
                    }

                    return NavigationDecision.navigate;
                  },
                ),
              )
              ..loadRequest(Uri.parse(stripeSession.url));

            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: const Text("Complete Payment")),
                  body: WebViewWidget(controller: controller),
                ),
              ),
            );
          },
        );
      } catch (e) {
        debugPrint("Error creating payment: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unexpected error occurred")),
        );
      }
    }

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
                    child: TitleWidget(
                        title: "${widget.booking.vehicleMake} ${widget.booking.vehicleModel}"),
                  ),
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
                        decoration: BoxDecoration(
                            color: status.color, borderRadius: BorderRadius.circular(10.0)),
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
                  if (widget.booking.notes!.isNotEmpty) ...[
                    InfoSectionCard(
                        title: "Notes from Staff",
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.booking.notes as String),
                            if (widget.booking.penalty != 0) ...[
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                children: [
                                  Text(
                                    "Penalty: \$${widget.booking.penalty!.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (status == RentalStatus.penalty)
                                    PrimaryButton(
                                      text: "Pay penalty",
                                      width: 140,
                                      height: 40,
                                      onPressed: () => openStripeCheckout(),
                                    )
                                ],
                              )
                            ],
                          ],
                        )),
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
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  InfoSectionCard(
                    title: "Payment & Insurance",
                    child: Column(
                      children: [
                        InfoRow(
                            title: "Insurance",
                            text: "\$${widget.booking.insuranceCost?.toStringAsFixed(2)}"),
                        const SizedBox(height: AppSpacing.xs),
                        InfoRow(
                            title: "Total Price",
                            text: "\$${widget.booking.totalAmount?.toStringAsFixed(2)}",
                            color: AppColors.primary)
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (status == RentalStatus.pending || status == RentalStatus.confirmed) ...{
                    PrimaryButton(
                      text: "Cancel Booking",
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                "Cancel Booking",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: const Text(
                                "Are you sure you want to cancel this booking? This action cannot be undone.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "No, Keep Booking",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await _cancelBookingUseCase(widget.booking.bookingID!);
                                    Navigator.pop(context);
                                    Navigator.pop(context, 'refresh');
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
                      },
                    )
                  },
                  if (status == RentalStatus.active || status == RentalStatus.overdue) ...{
                    PrimaryButton(
                      text: "Return vehicle",
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                "Return vehicle",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: const Text(
                                "Did you leave your vehicle at your selected drop-off location? This action cannot be undone.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "No, Not yet",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await _finishBookingUseCase(widget.booking.bookingID!);
                                    Navigator.pop(context);
                                    Navigator.pop(context, 'refresh');
                                  },
                                  child: const Text(
                                    "Yes, I put vehicle away",
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    )
                  }
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
