import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/custom_text_field.dart';
import 'package:vrooom/core/common/widgets/date_picker_field.dart';
import 'package:vrooom/core/common/widgets/info_row.dart';
import 'package:vrooom/core/common/widgets/info_section_card.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/assets/app_vectors.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/core/configs/theme/app_text_styles.dart';

import '../../../../core/common/widgets/custom_checkbox.dart';

class BookingDetailsPage extends StatefulWidget {
  const BookingDetailsPage({super.key});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

enum PaymentMethod { creditCard, stripe }

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  bool isSameLocation = false;
  bool savePaymentInfo = false;

  bool haveRabatCode = false;
  double discountAmount = 0.0;
  double totalPrice = 499.0;

  DateTime startDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime endDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  PaymentMethod selectedPayment = PaymentMethod.creditCard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Booking Details",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              // RENTAL DURATION - PICKUP DATE - DROPOFF DATE
              InfoSectionCard(
                title: "Rental Duration",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: AppSpacing.xs,
                    ),
                    DatePickerField(
                      label: "Pick-up Date",
                      hintText: "Select pick-up date",
                      initialDate: startDate,
                      onDateSelected: (date) {
                        setState(() {
                          startDate = date;
                          if (endDate.isBefore(startDate)) {
                            endDate = startDate.add(const Duration(days: 1));
                          }
                        });
                      },
                    ),
                    DatePickerField(
                      label: "Drop-off Date",
                      hintText: "Select pick-up date",
                      initialDate: endDate,
                      onDateSelected: (date) {
                        setState(() {
                          endDate = date;
                          if (endDate.isBefore(startDate)) {
                            startDate = endDate.subtract(const Duration(days: 1));
                          }
                        });
                      },
                    ),
                    InfoRow(
                      label: "Total Duration:",
                      value: "${endDate.difference(startDate).inDays + 1} day(s)",
                    )
                  ],
                ),
              ),

              // PICKUP AND DROP OFF LOCATIONS
              const SizedBox(height: AppSpacing.md),
              InfoSectionCard(
                title: "Pick-up & Drop-off",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownMenu<String>(
                      initialSelection: "Warsaw",
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: "Warsaw", label: "Warsaw"),
                        DropdownMenuEntry(value: "Berlin", label: "Berlin"),
                        DropdownMenuEntry(value: "Paris", label: "Paris"),
                      ],
                      onSelected: (value) {
                        print("Selected: $value");
                      },
                    ),
                    const SizedBox(
                      height: AppSpacing.sm,
                    ),
                    CustomCheckbox(
                      label: "Drop-off same as pick-up",
                      value: isSameLocation,
                      onChanged: (newValue) {
                        setState(() {
                          isSameLocation = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Opacity(
                      opacity: isSameLocation ? 0.5 : 1.0,
                      child: IgnorePointer(
                        ignoring: isSameLocation,
                        child: DropdownMenu<String>(
                          initialSelection: "Warsaw",
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(value: "Warsaw", label: "Warsaw"),
                            DropdownMenuEntry(value: "Berlin", label: "Berlin"),
                            DropdownMenuEntry(value: "Paris", label: "Paris"),
                          ],
                          onSelected: (value) {
                            print("Selected: $value");
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PAYMENT INFORMATION - CREDIT CARD - STRIPE
              const SizedBox(height: AppSpacing.md),
              InfoSectionCard(
                title: "Payment Information",
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPayment = PaymentMethod.creditCard;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: selectedPayment == PaymentMethod.creditCard
                                    ? AppColors.primary
                                    : AppColors.container.neutral700,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: const Text(
                                "Credit Card",
                                style: AppTextStyles.smallButton,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPayment = PaymentMethod.stripe;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: selectedPayment == PaymentMethod.stripe
                                    ? AppColors.primary
                                    : AppColors.container.neutral700,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: const Text(
                                "Stripe",
                                style: AppTextStyles.smallButton,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (selectedPayment == PaymentMethod.creditCard) ...[
                      CustomTextField(
                        label: "Card Number",
                        hintText: "4242 4242 4242 4242",
                        leadingIcon: const AppSvg(
                          asset: AppVectors.creditCard,
                          color: AppColors.primary,
                        ),
                        fillColor: AppColors.container.neutral700,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: "Expiry Date",
                              hintText: "e.g. 12/15",
                              fillColor: AppColors.container.neutral700,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: CustomTextField(
                              label: "CVV",
                              hintText: "e.g. 123",
                              fillColor: AppColors.container.neutral700,
                            ),
                          ),
                        ],
                      ),
                      CustomCheckbox(
                        label: "Save payment information",
                        value: savePaymentInfo,
                        onChanged: (newValue) {
                          setState(() {
                            savePaymentInfo = newValue;
                          });
                        },
                      ),
                    ] else if (selectedPayment == PaymentMethod.stripe) ...[
                      const Text("Confirm booking and finalize payment."),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    const Divider(),
                    const SizedBox(height: AppSpacing.sm),
                    CustomCheckbox(
                        value: haveRabatCode,
                        onChanged: (newValue) {
                          setState(() {
                            haveRabatCode = newValue;
                            if (newValue == false) discountAmount = 0.0;
                          });
                        },
                        label: "Have a rabat code?"),
                    SizedBox(
                      height: AppSpacing.xs,
                    ),
                    if (haveRabatCode == true) ...[
                      SizedBox(
                        height: AppSpacing.sm,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            flex: 2,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Enter promo code",
                                fillColor: AppColors.container.neutral700,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: AppSpacing.md,
                          ),
                          Flexible(
                            flex: 1,
                            child: PrimaryButton(
                              text: "Enter",
                              onPressed: () {
                                setState(() {
                                  discountAmount = 200.0;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    if (discountAmount != 0.0) ...[
                      InfoRow(
                        label: "Initial cost:",
                        value: "\$${totalPrice.toStringAsFixed(2)}",
                      ),
                      SizedBox(height: AppSpacing.xxs),
                      InfoRow(
                        label: "Discount:",
                        value: "-\$${discountAmount.toStringAsFixed(2)}",
                      ),
                      SizedBox(height: AppSpacing.sm),
                    ],
                    InfoRow(
                      label: "Total Cost:",
                      value: "\$${(totalPrice - discountAmount).toStringAsFixed(2)}",
                      fontSize: 22.0,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const PrimaryButton(text: "Confirm booking"),
            ],
          ),
        ),
      ),
    );
  }
}
