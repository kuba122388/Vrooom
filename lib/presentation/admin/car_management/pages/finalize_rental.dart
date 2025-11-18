import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/custom_text_field.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/domain/entities/booking.dart';
import 'package:vrooom/domain/usecases/booking/finalize_booking_usecase.dart';
import 'package:vrooom/domain/usecases/vehicle/get_vehicle_by_id_usecase.dart';

import '../../../../core/common/widgets/loading_widget.dart';
import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../../core/configs/theme/app_text_styles.dart';
import '../../../../domain/entities/vehicle.dart';

class FinalizeRentalPage extends StatefulWidget {
  final Booking booking;

  const FinalizeRentalPage({super.key, required this.booking});

  @override
  State<FinalizeRentalPage> createState() => _FinalizeRentalPageState();
}

class _FinalizeRentalPageState extends State<FinalizeRentalPage> {
  final GetVehicleByIdUseCase _getVehicleByIdUseCase = sl();
  final FinalizeBookingUseCase _finalizeBookingUseCase = sl();

  final TextEditingController _startMileageController = TextEditingController();
  final TextEditingController _endMileageController = TextEditingController();
  final TextEditingController _damageDescriptionController = TextEditingController();
  final TextEditingController _additionalCommentsController = TextEditingController();
  final TextEditingController _penaltyAmountController = TextEditingController();
  final TextEditingController _penaltyDescriptionController = TextEditingController();

  Vehicle? _vehicle;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadVehicle();
  }

  Future<void> _loadVehicle() async {
    setState(() => _loading = true);

    final result = await _getVehicleByIdUseCase(widget.booking.vehicleID!);

    result.fold(
      (error) {
        setState(() {
          _error = error;
          _loading = false;
        });
      },
      (vehicle) {
        setState(() {
          _vehicle = vehicle;
          _startMileageController.text = _vehicle!.mileage.toString();
          _loading = false;
        });
      },
    );
  }

  Future<void> _saveFinalization() async {
    final double penaltyAmount = double.tryParse(_penaltyAmountController.text.trim()) ?? 0.0;

    final String mergedNotes = [
      if (_damageDescriptionController.text.isNotEmpty)
        "Damages: ${_damageDescriptionController.text}",
      if (_additionalCommentsController.text.isNotEmpty)
        "Comments: ${_additionalCommentsController.text}",
      if (_penaltyDescriptionController.text.isNotEmpty)
        "Penalty Reason: ${_penaltyDescriptionController.text}",
    ].join("\n");

    final updated = widget.booking.copyWith(
      penalty: penaltyAmount,
      notes: mergedNotes,
      actualReturnDate: DateTime.now(),
    );

    if (_endMileageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter the end mileage.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      return;
    }

    final int? endMileage = int.tryParse(_endMileageController.text.trim());

    if (endMileage != null && endMileage < _vehicle!.mileage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "End mileage can't be lower than start mileage.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      return;
    }

    await _finalizeBookingUseCase(updated, endMileage!);
    Navigator.of(context).pop("refresh");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Finalize Rental"),
      body: LoadingWidget(
        isLoading: _loading,
        errorMessage: _error,
        futureResultObj: _vehicle,
        emptyResultMsg: "Vehicle not found.",
        futureBuilder: _buildScreen,
      ),
    );
  }

  Widget _buildScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMileageCard(),
            const SizedBox(height: AppSpacing.md),
            _buildDamageCard(),
            const SizedBox(height: AppSpacing.md),
            _buildPenaltyCard(),
            const SizedBox(height: AppSpacing.lg),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildMileageCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.container.neutral700,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mileage Details",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            controller: _startMileageController,
            hintText: '',
            label: "Start Mileage (km)",
          ),
          CustomTextField(
            controller: _endMileageController,
            keyboardType: TextInputType.number,
            hintText: '',
            label: "End Mileage (km)",
          ),
        ],
      ),
    );
  }

  Widget _buildDamageCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.container.neutral700,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Damages & Comments",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            controller: _damageDescriptionController,
            label: "Damages or Issues",
            hintText: "",
            maxLines: 3,
          ),
          CustomTextField(
            controller: _additionalCommentsController,
            label: "Additional Comments",
            hintText: "",
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildPenaltyCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.container.neutral700,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Penalty",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            controller: _penaltyAmountController,
            hintText: "0.00",
            label: "Penalty Amount (\$)",
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          CustomTextField(
            controller: _penaltyDescriptionController,
            hintText: "Reason for penalty",
            label: "Penalty Description",
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: AppColors.container.neutral700,
              ),
            ),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: AppTextStyles.button,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: PrimaryButton(
            text: "Save",
            onPressed: () async => _saveFinalization(),
          ),
        ),
      ],
    );
  }
}
