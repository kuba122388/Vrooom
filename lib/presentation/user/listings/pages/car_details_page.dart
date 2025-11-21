import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/dark_gradient_overlay.dart';
import 'package:vrooom/core/common/widgets/info_row.dart';
import 'package:vrooom/core/common/widgets/info_section_card.dart';
import 'package:vrooom/core/common/widgets/loading_widget.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/assets/app_vectors.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/domain/usecases/vehicle/get_vehicle_details_usecase.dart';
import 'package:vrooom/presentation/user/listings/widgets/car_feature_container.dart';
import 'package:vrooom/presentation/user/listings/widgets/car_specification_row.dart';

import '../../../../core/configs/di/service_locator.dart';
import '../../../../domain/entities/vehicle.dart';

class CarDetailsPage extends StatefulWidget {
  final int vehicleId;
  final DateTimeRange? dateTimeRange;

  const CarDetailsPage({super.key, required this.vehicleId, this.dateTimeRange});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  final GetVehicleDetailsUseCase _getVehicleDetailsUseCase = sl();
  bool _isLoading = true;
  Vehicle? _vehicle;
  String? _errorMessage;

  Future<void> _loadVehicle() async {
    final result = await _getVehicleDetailsUseCase(widget.vehicleId);
    if (!mounted) return;

    result.fold((error) {
      setState(() {
        _errorMessage = error;
        _isLoading = false;
      });
    }, (vehicle) {
      setState(() {
        _vehicle = vehicle;
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadVehicle();
  }

  _calculatePrice(int days) {
    Vehicle vehicle = _vehicle!;
    return (vehicle.deposit + vehicle.pricePerDay * days).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Car Details",
      ),
      body: LoadingWidget(
        isLoading: _isLoading,
        emptyResultMsg: "No Vehicle data found.",
        refreshFunction: _loadVehicle,
        errorMessage: _errorMessage,
        futureResultObj: _vehicle,
        futureBuilder: _buildVehicleDetails,
        shouldHavePadding: false,
      ),
    );
  }

  Widget _buildVehicleDetails() {
    final Vehicle vehicle = _vehicle!;
    int days = ((widget.dateTimeRange?.duration.inDays) ?? 0) + 1;

    final List<CarSpecRow> generalInfo = [
      CarSpecRow(iconPath: AppVectors.car, label: "Car Type", value: vehicle.type),
      CarSpecRow(
          iconPath: AppVectors.odometer, label: "Mileage", value: vehicle.mileage.toString()),
      CarSpecRow(
          iconPath: AppVectors.calendar,
          label: "Production Year",
          value: vehicle.productionYear.toString()),
      CarSpecRow(
          iconPath: AppVectors.seats, label: "Seats", value: "${vehicle.numberOfSeats} seats"),
      CarSpecRow(
          iconPath: AppVectors.carDoorsLeft,
          label: "Number of Doors",
          value: "${vehicle.numberOfDoors} doors"),
    ];

    final List<CarSpecRow> performanceInfo = [
      CarSpecRow(
          iconPath: AppVectors.engine,
          label: "Engine Capacity",
          value: "${vehicle.engineCapacity} L"),
      CarSpecRow(
          iconPath: AppVectors.horsePower, label: "Horse Power", value: "${vehicle.horsePower} HP"),
      CarSpecRow(iconPath: AppVectors.gitFork, label: "Gear", value: vehicle.gearShift),
      CarSpecRow(iconPath: AppVectors.gauge, label: "Drive Type", value: vehicle.driveType),
    ];

    final List<CarSpecRow> economyInfo = [
      CarSpecRow(iconPath: AppVectors.fuel, label: "Fuel Type", value: vehicle.fuelType),
      CarSpecRow(
          iconPath: AppVectors.milestone,
          label: "Avg Consumption",
          value: "${vehicle.averageConsumption} L/100km"),
    ];

    return Column(
      children: [
        Stack(
          children: [
            Image.network(
              vehicle.vehicleImage,
              width: double.infinity,
              height: 220.0,
              fit: BoxFit.cover,
            ),
            const DarkGradientOverlay(height: 220.0),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Text(
                "${vehicle.make} ${vehicle.model}",
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 28.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: Column(
            children: [
              InfoSectionCard(
                title: "${vehicle.make} ${vehicle.model}",
                child: Text(
                  vehicle.description,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.0,
                    color: AppColors.text.neutral400,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              InfoSectionCard(
                  title: "Location",
                  child: CarSpecRow(
                      iconPath: AppVectors.mapPin, label: vehicle.vehicleLocation, value: "")),
              const SizedBox(height: AppSpacing.md),
              InfoSectionCard(
                title: "General",
                child: Column(
                  children: generalInfo.map((spec) {
                    return CarSpecRow(
                      iconPath: spec.iconPath,
                      label: spec.label,
                      value: spec.value,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              InfoSectionCard(
                title: "Performance",
                child: Column(
                  children: performanceInfo.map((spec) {
                    return CarSpecRow(
                      iconPath: spec.iconPath,
                      label: spec.label,
                      value: spec.value,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              InfoSectionCard(
                title: "Economy",
                child: Column(
                  children: economyInfo.map((spec) {
                    return CarSpecRow(
                      iconPath: spec.iconPath,
                      label: spec.label,
                      value: spec.value,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              InfoSectionCard(
                title: "Features",
                child: Wrap(
                  spacing: AppSpacing.xxs,
                  runSpacing: AppSpacing.xs,
                  children: vehicle.equipmentList.map((entry) {
                    return CarFeatureContainer(
                        iconPath: AppVectors.snowflake, label: entry.equipmentName);
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              InfoSectionCard(
                title: "Pricing",
                child: Column(
                  children: [
                    InfoRow(
                      label: "Deposit",
                      value: "\$${vehicle.deposit.toStringAsFixed(2)}",
                    ),
                    const SizedBox(
                      height: AppSpacing.xxs,
                    ),
                    InfoRow(
                      label: "Daily Rate",
                      value: "\$${vehicle.pricePerDay.toStringAsFixed(2)} /day",
                    ),
                    const SizedBox(
                      height: AppSpacing.xxs,
                    ),
                    if (widget.dateTimeRange != null)
                      InfoRow(
                        label: "Rental days",
                        value: days.toString(),
                      ),
                    const SizedBox(
                      height: AppSpacing.xxs,
                    ),
                    const Divider(),
                    InfoRow(
                      label: "Estimated Total",
                      value: "\$${_calculatePrice(days)}",
                      fontSize: 20.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                text: "Rent Now",
                onPressed: () => Navigator.pushNamed(context, AppRoutes.bookingDetails, arguments: {
                  "dateTimeRange": widget.dateTimeRange,
                  "location": vehicle.vehicleLocation,
                  "deposit": vehicle.deposit,
                  "dailyRate": vehicle.pricePerDay,
                  "vehicleId": vehicle.vehicleID,
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
