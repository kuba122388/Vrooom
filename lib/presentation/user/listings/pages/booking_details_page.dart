import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/custom_text_field.dart';
import 'package:vrooom/core/common/widgets/date_picker_field.dart';
import 'package:vrooom/core/common/widgets/info_row.dart';
import 'package:vrooom/core/common/widgets/info_section_card.dart';
import 'package:vrooom/core/common/widgets/loading_widget.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/assets/app_vectors.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/core/configs/theme/app_text_styles.dart';
import 'package:vrooom/domain/entities/booked_date.dart';
import 'package:vrooom/domain/entities/booking_request.dart';
import 'package:vrooom/domain/entities/discount_code.dart';
import 'package:vrooom/domain/usecases/booking/create_booking_usecase.dart';
import 'package:vrooom/domain/usecases/booking/get_all_insurances_usecase.dart';
import 'package:vrooom/domain/usecases/booking/get_booked_dates_for_vehicle_usecase.dart';
import 'package:vrooom/domain/usecases/discount_codes/get_all_discount_codes_usecase.dart';
import 'package:vrooom/domain/usecases/payment/create_stripe_session_usecase.dart';
import 'package:vrooom/domain/usecases/vehicle/get_rental_locations_usecase.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/common/utils/card_input_formatters.dart';
import '../../../../core/common/widgets/custom_checkbox.dart';
import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/routes/app_routes.dart';
import '../../../../data/sources/auth/auth_storage.dart';
import '../../../../domain/entities/insurance.dart';

class BookingDetailsPage extends StatefulWidget {
  final String location;
  final int deposit;
  final double pricePerDay;
  final DateTimeRange? dateTimeRange;
  final int vehicleId;

  const BookingDetailsPage({
    super.key,
    this.dateTimeRange,
    required this.location,
    required this.deposit,
    required this.pricePerDay,
    required this.vehicleId,
  });

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

enum PaymentMethod { creditCard, stripe }

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  final GetAllInsurancesUseCase _getAllInsurancesUseCase = sl();
  final GetRentalLocationsUseCase _getRentalLocationsUseCase = sl();
  final CreateStripeSessionUseCase _createStripeSessionUseCase = sl();
  final GetAllDiscountCodesUseCase _getAllDiscountCodesUseCase = sl();
  final GetBookedDatesForVehicleUseCase _getBookedDatesForVehicleUseCase = sl();
  final CreateBookingUseCase _createBookingUseCase = sl();
  final authStorage = sl<AuthStorage>();

  bool haveRabatCode = false;

  bool _isConfirmingBooking = false;
  bool _isLoading = true;
  String? _errorMessage;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  final TextEditingController _discountController = TextEditingController();

  late final _userId;

  Insurance? _selectedInsurance;
  String? _selectedLocation;
  DateTime? _startDate;
  DateTime? _endDate;

  double? fixedDiscount;
  double? percentageDiscount;

  double totalPrice = 499.0;

  List<Insurance> _insuranceOptions = [];
  List<String> _rentalLocations = [];
  List<DiscountCode> _discountCodes = [];
  List<BookedDate> _bookedDates = [];

  PaymentMethod selectedPayment = PaymentMethod.creditCard;

  @override
  void initState() {
    super.initState();
    loadData();

    _selectedLocation = widget.location;

    _startDate = widget.dateTimeRange?.start ??
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    _endDate = widget.dateTimeRange?.end ??
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _userId = await authStorage.getUserId();

      final results = await Future.wait([
        _getAllInsurancesUseCase(),
        _getAllDiscountCodesUseCase(),
        _getBookedDatesForVehicleUseCase(widget.vehicleId),
        _getRentalLocationsUseCase(),
      ]);

      results[0].fold(
        (error) {
          setState(() => _errorMessage = "An error occurred: $error");
        },
        (insuranceList) {
          setState(() => _insuranceOptions = insuranceList as List<Insurance>);
        },
      );

      results[1].fold(
        (error) {
          setState(() => _errorMessage = "An error occurred: $error");
        },
        (discountCodes) {
          setState(() => _discountCodes = discountCodes as List<DiscountCode>);
        },
      );

      results[2].fold(
        (error) {
          setState(() => _errorMessage = "An error occurred: $error");
        },
        (bookedDates) {
          setState(() {
            _bookedDates = bookedDates as List<BookedDate>;

            if (widget.dateTimeRange == null) {
              _startDate = _findFirstAvailableStartDate();
              _endDate = _startDate;
            }
          });
        },
      );

      results[3].fold(
        (error) => setState(() {
          _errorMessage = "An error occurred: $error";
          _isLoading = false;
        }),
        (rentalLocations) => setState(() {
          _errorMessage = null;
          _rentalLocations = rentalLocations as List<String>;
          _isLoading = false;
        }),
      );
    } catch (e) {
      setState(() {
        _errorMessage = "An unknown error occurred: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  DateTime _findFirstAvailableStartDate() {
    DateTime checkDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final maxDate = checkDate.add(const Duration(days: 365));

    while (checkDate.isBefore(maxDate)) {
      bool isAvailable = true;

      for (final booked in _bookedDates) {
        if (checkDate.isAfter(booked.startDate.subtract(const Duration(days: 1))) &&
            checkDate.isBefore(booked.endDate.add(const Duration(days: 1)))) {
          isAvailable = false;
          break;
        }
      }

      if (isAvailable) {
        return checkDate;
      }

      checkDate = checkDate.add(const Duration(days: 1));
    }

    return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Booking Details",
      ),
      body: LoadingWidget(
        isLoading: _isLoading,
        errorMessage: _errorMessage,
        emptyResultMsg: "Unexpected error occured. Try again later.",
        futureResultObj: _insuranceOptions,
        futureBuilder: _buildBookingScreen,
      ),
    );
  }

  Widget _buildBookingScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
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
                    initialDate: _startDate,
                    bookedDates: _bookedDates,
                    isEndDate: false,
                    onDateSelected: (date) {
                      setState(() {
                        _startDate = date;
                        _endDate = _startDate;
                      });
                    },
                  ),
                  DatePickerField(
                    label: "Drop-off Date",
                    hintText: "Select drop-off date",
                    initialDate: _endDate,
                    bookedDates: _bookedDates,
                    isEndDate: true,
                    startDate: _startDate,
                    onDateSelected: (date) {
                      setState(() {
                        _endDate = date;
                      });
                    },
                  ),
                  InfoRow(
                    label: "Total Duration:",
                    value: "${_calculateDateDifference()} day(s)",
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
                  const Row(
                    children: [
                      AppSvg(
                        asset: AppVectors.mapPin,
                        color: AppColors.primary,
                        height: 20.0,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        "Pick-up location",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      DropdownMenu<String>(
                        width: 250,
                        initialSelection:
                            widget.location.isEmpty ? "Error fetching city" : widget.location,
                        enabled: false,
                        dropdownMenuEntries: [
                          DropdownMenuEntry<String>(
                            value: widget.location,
                            label: widget.location,
                          )
                        ],
                        trailingIcon: const SizedBox.shrink(),
                        onSelected: (value) {
                          _selectedLocation = value!;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Row(
                    children: [
                      AppSvg(
                        asset: AppVectors.mapPin,
                        color: AppColors.primary,
                        height: 20.0,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        "Drop-off location",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  DropdownMenu<String>(
                    width: 250,
                    initialSelection: _rentalLocations.isNotEmpty ? widget.location : null,
                    dropdownMenuEntries: _rentalLocations
                        .map((location) => DropdownMenuEntry<String>(
                              value: location,
                              label: location,
                            ))
                        .toList(),
                    onSelected: (value) {
                      _selectedLocation = value!;
                    },
                  ),
                ],
              ),
            ),

            // Insurance
            const SizedBox(height: AppSpacing.md),
            InfoSectionCard(
              title: "Insurance",
              child: Column(children: [
                DropdownButtonFormField<Insurance>(
                  isExpanded: true,
                  initialValue: _selectedInsurance,
                  hint: const Text("Select insurance type"),
                  items: _insuranceOptions.map((Insurance option) {
                    return DropdownMenuItem<Insurance>(
                      value: option,
                      child: Text(
                        "${option.insuranceType} (\$${option.insuranceCost})",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    );
                  }).toList(),
                  onChanged: (Insurance? newValue) {
                    setState(() {
                      _selectedInsurance = newValue;
                      // TODO update with insurance
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an insurance option.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: AppColors.container.neutral700,
                    prefixIcon: const Icon(
                      Icons.shield_outlined,
                      color: AppColors.primary,
                    ),
                    filled: true,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: AppSpacing.md),

            // PAYMENT INFORMATION
            Form(
              key: _formKey,
              child: InfoSectionCard(
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
                        controller: _cardNumberController,
                        label: "Card Number",
                        hintText: "4242 4242 4242 4242",
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CardNumberInputFormatter(),
                        ],
                        leadingIcon: const AppSvg(
                          asset: AppVectors.creditCard,
                          color: AppColors.primary,
                        ),
                        fillColor: AppColors.container.neutral700,
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Card number required";
                          if (value.replaceAll(" ", "").length < 16) return "Invalid card number";
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _expiryController,
                              label: "Expiry Date",
                              hintText: "MM/YY",
                              fillColor: AppColors.container.neutral700,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                ExpiryDateInputFormatter(),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) return "Required";
                                final regex = RegExp(r"^(0[1-9]|1[0-2])\/\d{2}$");
                                if (!regex.hasMatch(value)) return "Invalid date";
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: CustomTextField(
                              controller: _cvvController,
                              keyboardType: TextInputType.number,
                              // ADD THIS
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CvvInputFormatter(),
                              ],
                              label: "CVV",
                              hintText: "123",
                              fillColor: AppColors.container.neutral700,
                              validator: (value) {
                                if (value == null || value.isEmpty) return "Required";
                                if (value.length != 3) return "Invalid CVV";
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ] else if (selectedPayment == PaymentMethod.stripe) ...[
                      const Text(
                        "You will be redirected to Stripe to finalize payment.",
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    const Divider(),
                    const SizedBox(height: AppSpacing.sm),
                    CustomCheckbox(
                        value: haveRabatCode,
                        onChanged: (newValue) {
                          setState(() {
                            haveRabatCode = newValue;
                            if (haveRabatCode == false) {
                              fixedDiscount = null;
                              percentageDiscount = null;
                            }
                          });
                        },
                        label: "Have a rabat code?"),
                    const SizedBox(
                      height: AppSpacing.xs,
                    ),
                    if (haveRabatCode == true) ...[
                      const SizedBox(
                        height: AppSpacing.sm,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            flex: 2,
                            child: TextField(
                              controller: _discountController,
                              decoration: InputDecoration(
                                hintText: "Enter promo code",
                                fillColor: AppColors.container.neutral700,
                                hintStyle: const TextStyle(fontSize: 14.0),
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
                                  _applyPromoCode(_discountController.text);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    InfoRow(
                      label: "Price per day",
                      value: "\$${widget.pricePerDay.toStringAsFixed(2)}",
                    ),
                    const SizedBox(
                      height: AppSpacing.xxs,
                    ),
                    InfoRow(
                      label: "Rental days",
                      value: "${_calculateDateDifference().toString()} day(s)",
                    ),
                    const SizedBox(
                      height: AppSpacing.xxs,
                    ),
                    InfoRow(
                      label: "In Total",
                      value: "\$${_calculateDateDifference() * widget.pricePerDay}",
                    ),
                    const SizedBox(
                      height: AppSpacing.sm,
                    ),
                    InfoRow(
                      label: "Deposit",
                      value: "\$${widget.deposit.toStringAsFixed(2)}",
                    ),
                    if (_selectedInsurance != null) ...[
                      const SizedBox(
                        height: AppSpacing.xxs,
                      ),
                      InfoRow(
                        label: "Insurance",
                        value: "\$${_selectedInsurance!.insuranceCost.toStringAsFixed(2)}",
                      ),
                    ],
                    const SizedBox(
                      height: AppSpacing.sm,
                    ),
                    if (fixedDiscount != null) ...[
                      InfoRow(
                        label: "Discount:",
                        value: "-\$${fixedDiscount!.toStringAsFixed(2)}",
                      ),
                      const SizedBox(
                        height: AppSpacing.sm,
                      ),
                    ],
                    if (percentageDiscount != null) ...[
                      InfoRow(
                        label: "Discount:",
                        value: "${percentageDiscount!.toStringAsFixed(0)}% off",
                      ),
                      const SizedBox(
                        height: AppSpacing.sm,
                      ),
                    ],
                    InfoRow(
                      label: "Total Cost:",
                      value: "\$${(_calculateTotalPrice()).toStringAsFixed(2)}",
                      fontSize: 22.0,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            PrimaryButton(
              text: _isConfirmingBooking ? "Processing..." : "Confirm booking",
              onPressed: () async {
                if (_isConfirmingBooking) return;

                setState(() {
                  _isConfirmingBooking = true;
                });

                if (selectedPayment == PaymentMethod.stripe) {
                  await _openStripeCheckout();
                } else {
                  await _handleCreditCardPayment();
                }
                setState(() {
                  if (mounted) _isConfirmingBooking = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _applyPromoCode(String promoCode) {
    try {
      final discountCode = _discountCodes.firstWhere((d) => d.code == promoCode);

      if (discountCode.active == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This promo code is expired.')),
        );
        return;
      }

      setState(() {
        if (discountCode.percentage == true) {
          percentageDiscount = discountCode.value;
          fixedDiscount = null;
        } else {
          fixedDiscount = discountCode.value;
          percentageDiscount = null;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Promo code applied!')),
      );
    } on StateError {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Promo code not found')),
      );
      fixedDiscount = null;
      percentageDiscount = null;
    }
  }

  double _calculateTotalPrice() {
    double daysPrice = _calculateDateDifference() * widget.pricePerDay;
    double insurance = _selectedInsurance?.insuranceCost ?? 0.0;
    double deposit = widget.deposit.toDouble();

    double basePrice = daysPrice + insurance + deposit;

    double percentValue = 0.0;
    if (percentageDiscount != null) {
      percentValue = basePrice * (percentageDiscount! / 100);
    }

    double fixedValue = fixedDiscount ?? 0.0;

    return basePrice - percentValue - fixedValue;
  }

  int _calculateDateDifference() {
    return (_endDate!.difference(_startDate!).inDays + 1);
  }

  Future<void> _openStripeCheckout() async {
    if (_selectedInsurance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select an insurance option",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
        ),
      );
      return;
    }

    if (_selectedLocation == null || _selectedLocation!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select a drop-off location",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
        ),
      );
      return;
    }

    try {
      final double finalAmount = _calculateTotalPrice();

      final sessionResponse = await _createStripeSessionUseCase(finalAmount);

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
                    await _createBookingUseCase(
                      BookingRequest(
                        startDate: _startDate!,
                        endDate: _endDate!,
                        vehicleId: widget.vehicleId,
                        pickupAddress: widget.location,
                        dropOffAddress: _selectedLocation!,
                        insuranceId: _selectedInsurance!.insuranceID,
                        totalPrice: finalAmount,
                        userId: _userId,
                      ),
                    );
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.paymentSuccess);
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

  Future<void> _handleCreditCardPayment() async {
    if (_selectedInsurance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select an insurance option",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
        ),
      );
      return;
    }

    if (_selectedLocation == null || _selectedLocation!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select a drop-off location",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final result = await _createBookingUseCase(
        BookingRequest(
          startDate: _startDate!,
          endDate: _endDate!,
          vehicleId: widget.vehicleId,
          pickupAddress: _selectedLocation!,
          dropOffAddress: _selectedLocation!,
          insuranceId: _selectedInsurance!.insuranceID,
          totalPrice: _calculateTotalPrice(),
          userId: _userId,
        ),
      );
      result.fold(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Unexpected error occured: $error}",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.primary,
            ),
          );
        },
        (result) => Navigator.pushNamed(context, AppRoutes.paymentSuccess),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please correct the errors above.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }
}
