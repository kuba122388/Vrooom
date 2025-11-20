import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/custom_dropdown.dart';
import 'package:vrooom/core/common/widgets/custom_text_field.dart';
import 'package:vrooom/core/common/widgets/image_picker_widget.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/domain/entities/equipment.dart';
import 'package:vrooom/domain/entities/vehicle.dart';
import 'package:vrooom/domain/usecases/vehicle/add_new_vehicle_usecase.dart';
import 'package:vrooom/domain/usecases/vehicle/get_rental_locations_usecase.dart';

import '../../../../core/common/widgets/app_svg.dart';
import '../../../../core/configs/assets/app_vectors.dart';
import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/routes/app_routes.dart';
import '../../../../core/configs/theme/app_spacing.dart';

class AddNewCar extends StatefulWidget {
  const AddNewCar({super.key});

  @override
  State<AddNewCar> createState() => _AddNewCarState();
}

class _AddNewCarState extends State<AddNewCar> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();

  final AddNewVehiclesUseCase _addNewVehiclesUseCase = sl();
  final GetRentalLocationsUseCase _getRentalLocationsUseCase = sl();

  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _depositController = TextEditingController();
  final TextEditingController _engineCapacityController = TextEditingController();
  final TextEditingController _horsePowerController = TextEditingController();
  final TextEditingController _consumptionController = TextEditingController();
  final TextEditingController _wheelSizeController = TextEditingController();
  final TextEditingController _numberOfDoorsController = TextEditingController();
  final TextEditingController _brandLogoController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _productionYearController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  File? _selectedImage;

  // Dropdown options
  List<String> fuelTypes = ['Petrol', 'Diesel', 'Electric', 'Hybrid', 'Gas', 'LPG'];
  List<String> seatsOptions = ['2', '4', '5', '6', '7', '8', '9', '10', '12', '16'];
  List<String> transmissionOptions = ['Automatic', 'Manual', 'Semi-automatic'];
  bool availableForRent = true;
  List<String> bodyTypes = [
    'Hatchback',
    'Sedan',
    'SUV',
    'Coupe',
    'Minivan',
    'Truck',
    'Wagon',
    'Convertible'
  ];
  List<String> driveTypes = ['Front-wheel drive', 'Rear-wheel drive', 'All-wheel drive (4x4)'];

  List<String> equipmentList = [
    'Air Conditioning',
    'GPS',
    'Heated Seats',
    'Sunroof',
    'Parking Sensors',
    'Apple CarPlay/Android Auto',
    'Front and Rear Sensors',
    'Rear Sensor',
    'Rear View Camera',
    'Cruise Control',
    'Heated Steering Wheel',
    'LED Headlights',
    'Xenon Headlights',
    'Android Auto',
    'Apple CarPlay',
    'Navigation System (GPS)',
    'Bluetooth',
    'Parking Assistant',
    'Blind Spot Monitor',
    'Keyless Entry'
  ];

  List<String> rentalLocations = [];

  // Selected Dropdown Values
  String? _selectedBodyType;
  String? _selectedFuelType;
  String? _selectedTransmission;
  String? _selectedDriveType;
  String? _selectedSeats;
  String? _selectedCarLocation;
  final List<String> _selectedEquipment = [];

  @override
  initState() {
    _fetchRentalLocations();
    super.initState();
  }

  Future<void> _fetchRentalLocations() async {
    final result = await _getRentalLocationsUseCase();

    result.fold((error) {
      print(error);
    }, (locations) {
      setState(() {
        rentalLocations = locations;
      });
    });
  }

  // Validators
  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required.';
    }
    return null;
  }

  String? _validateNumber(String? value, {bool allowDecimal = false}) {
    if (value == null || value.isEmpty) {
      return 'A numeric value is required.';
    }
    if (allowDecimal) {
      if (double.tryParse(value) == null) {
        return 'Please enter a valid number.';
      }
    } else {
      if (int.tryParse(value) == null) {
        return 'Please enter a valid integer.';
      }
    }
    return null;
  }

  Future<void> _addVehicle() async {
    final isFormValid = _formKey.currentState!.validate();

    if (!isFormValid ||
        _selectedBodyType == null ||
        _selectedFuelType == null ||
        _selectedTransmission == null ||
        _selectedSeats == null) {
      setState(() {
        _errorMessage = "Please fill in all required fields and select all options.";
        _isLoading = false;
      });
      return;
    }

    if (_selectedImage == null) {
      setState(() {
        _errorMessage = "Please select a car image.";
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final pricePerDay = double.tryParse(_priceController.text) ?? 0.0;
      final deposit = int.tryParse(_depositController.text) ?? 0;
      final engineCapacity = double.tryParse(_engineCapacityController.text) ?? 0.0;
      final horsePower = int.tryParse(_horsePowerController.text) ?? 0;
      final averageConsumption = double.tryParse(_consumptionController.text) ?? 0.0;
      final numberOfSeats = int.tryParse(_selectedSeats!) ?? 0;
      final numberOfDoors = int.tryParse(_numberOfDoorsController.text) ?? 0;
      final wheelSize = int.tryParse(_wheelSizeController.text) ?? 0;
      final productionYear = int.tryParse(_productionYearController.text) ?? 0;
      final mileage = int.tryParse(_mileageController.text) ?? 0;

      List<Equipment> equipment = [];
      for (String name in _selectedEquipment) {
        equipment.add(Equipment(equipmentID: 0, equipmentName: name));
      }

      final Vehicle newVehicle = Vehicle(0,
          make: _makeController.text,
          model: _modelController.text,
          type: _selectedBodyType!,
          pricePerDay: pricePerDay,
          deposit: deposit,
          gearShift: _selectedTransmission!,
          driveType: _selectedDriveType ?? 'Front-wheel drive',
          fuelType: _selectedFuelType!,
          engineCapacity: engineCapacity,
          horsePower: horsePower,
          averageConsumption: averageConsumption,
          numberOfSeats: numberOfSeats,
          numberOfDoors: numberOfDoors,
          productionYear: productionYear,
          description: _descriptionController.text,
          mileage: mileage,
          vehicleImage: "",
          availabilityStatus: availableForRent ? 'Available' : 'Not Available',
          wheelSize: wheelSize,
          equipmentList: equipment,
          vehicleLocation: _selectedCarLocation!);

      final result = await _addNewVehiclesUseCase(
        vehicle: newVehicle,
        imageFile: _selectedImage!,
      );

      result.fold(
        (error) {
          setState(() {
            _errorMessage = "An error occurred: $error";
            _isLoading = false;
          });
        },
        (addedVehicle) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushReplacementNamed(AppRoutes.carManagement);
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = "An unknown error occurred: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _depositController.dispose();
    _engineCapacityController.dispose();
    _horsePowerController.dispose();
    _consumptionController.dispose();
    _wheelSizeController.dispose();
    _numberOfDoorsController.dispose();
    _brandLogoController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    _plateController.dispose();
    _productionYearController.dispose();
    _mileageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).pop(false);
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: "Add New Car"),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColors.container.neutral700, borderRadius: BorderRadius.circular(12.0)),
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.md),
                    const Text(
                      "Add a new Vehicle to Your Fleet",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    CustomDropdownMenu(
                      items: rentalLocations,
                      label: "Car Location",
                      hintText: "Select Car Location",
                      initialValue: _selectedCarLocation,
                      onSelected: (newValue) => setState(() => _selectedCarLocation = newValue),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Text(
                      "Basic Car Information",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _makeController,
                      hintText: 'e.g., Toyota',
                      label: "Make",
                      validator: _validateRequired,
                    ),
                    CustomTextField(
                      controller: _modelController,
                      hintText: 'e.g., Camry SE',
                      label: "Model",
                      validator: _validateRequired,
                    ),
                    CustomTextField(
                      controller: _productionYearController,
                      hintText: 'e.g., 2021',
                      label: "Production year",
                      validator: _validateNumber,
                    ),
                    CustomTextField(
                      controller: _mileageController,
                      hintText: 'e.g., 6592',
                      label: "Mileage (km)",
                      validator: _validateNumber,
                    ),
                    CustomDropdownMenu(
                      items: bodyTypes,
                      label: "Body Type",
                      hintText: "Select body type",
                      initialValue: _selectedBodyType,
                      onSelected: (newValue) => setState(() => _selectedBodyType = newValue),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Text(
                      "Detailed Specifications",
                      style: TextStyle(
                          color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    CustomTextField(
                      controller: _engineCapacityController,
                      hintText: 'e.g., 2.0',
                      label: "Engine Capacity (L)",
                      keyboardType: TextInputType.number,
                      validator: (value) => _validateNumber(value, allowDecimal: true),
                    ),
                    CustomTextField(
                      controller: _horsePowerController,
                      hintText: 'e.g., 188',
                      label: "Horse Power (HP)",
                      keyboardType: TextInputType.number,
                      validator: _validateNumber,
                    ),
                    CustomTextField(
                      controller: _consumptionController,
                      hintText: 'e.g., 6.5',
                      label: "Average Consumption (L/100km)",
                      keyboardType: TextInputType.number,
                      validator: (value) => _validateNumber(value, allowDecimal: true),
                    ),
                    CustomTextField(
                      controller: _wheelSizeController,
                      hintText: 'e.g., 17',
                      label: "Wheel Size (Inches)",
                      keyboardType: TextInputType.number,
                      validator: _validateNumber,
                    ),
                    CustomTextField(
                      controller: _numberOfDoorsController,
                      hintText: 'e.g., 4',
                      label: "Number of Doors",
                      keyboardType: TextInputType.number,
                      validator: _validateNumber,
                    ),
                    CustomDropdownMenu(
                      items: seatsOptions,
                      label: "Seating Capacity",
                      hintText: "Select seats",
                      initialValue: _selectedSeats,
                      leadingIcon: const AppSvg(asset: AppVectors.usersRound),
                      onSelected: (newValue) => setState(() => _selectedSeats = newValue),
                    ),
                    CustomDropdownMenu(
                      items: fuelTypes,
                      label: "Fuel type",
                      hintText: "Select fuel type",
                      initialValue: _selectedFuelType,
                      leadingIcon: const AppSvg(asset: AppVectors.fuel),
                      onSelected: (newValue) => setState(() => _selectedFuelType = newValue),
                    ),
                    CustomDropdownMenu(
                      items: transmissionOptions,
                      label: "Transmission (Gear Shift)",
                      hintText: "Select transmission",
                      initialValue: _selectedTransmission,
                      leadingIcon: const AppSvg(asset: AppVectors.gitFork),
                      onSelected: (newValue) => setState(() => _selectedTransmission = newValue),
                    ),
                    CustomDropdownMenu(
                      items: driveTypes,
                      label: "Drive Type",
                      hintText: "Select drive type",
                      initialValue: _selectedDriveType,
                      onSelected: (newValue) => setState(() => _selectedDriveType = newValue),
                    ),
                    CustomTextField(
                      controller: _descriptionController,
                      hintText: 'Provide a detailed description of the car...',
                      label: "Car Description",
                      maxLines: 4,
                      validator: _validateRequired,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Text(
                      "Equipment List",
                      style:
                          TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: equipmentList.map((equipmentName) {
                        final bool isSelected = _selectedEquipment.contains(equipmentName);

                        return FilterChip(
                          label: Text(equipmentName),
                          selected: isSelected,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.black : Colors.white70,
                          ),
                          backgroundColor: AppColors.container.neutral800,
                          selectedColor: AppColors.primary,
                          showCheckmark: false,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _selectedEquipment.add(equipmentName);
                              } else {
                                _selectedEquipment.remove(equipmentName);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Text(
                      "Car Images",
                      style:
                          TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    GestureDetector(
                      onTap: () async {
                        File? image = await ImagePickerWidget.pickImage();

                        if (image != null) {
                          setState(() {
                            _selectedImage = image;
                            _errorMessage = null;
                          });
                        }
                      },
                      child: DottedBorder(
                        color: AppColors.container.neutral800,
                        strokeWidth: 2,
                        dashPattern: const [8, 4],
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.container.neutral800,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppSvg(asset: AppVectors.upload, height: 40, width: 40),
                                    SizedBox(height: AppSpacing.md),
                                    Text("Upload a car image",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Text(
                      "Pricing & Availability",
                      style:
                          TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    CustomTextField(
                      controller: _priceController,
                      hintText: 'e.g., 75.00',
                      label: "Rental Price Per Day",
                      leadingIcon: const AppSvg(asset: AppVectors.dollarSign),
                      keyboardType: TextInputType.number,
                      validator: (value) => _validateNumber(value, allowDecimal: true),
                    ),
                    CustomTextField(
                      controller: _depositController,
                      hintText: 'e.g., 500',
                      label: "Deposit Amount",
                      leadingIcon: const AppSvg(asset: AppVectors.dollarSign),
                      keyboardType: TextInputType.number,
                      validator: _validateNumber,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white24),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Available For Rent", style: TextStyle(fontSize: 16.0)),
                            Switch(
                              value: availableForRent,
                              activeThumbColor: AppColors.background,
                              inactiveThumbColor: AppColors.container.neutral900,
                              activeTrackColor: AppColors.primary,
                              inactiveTrackColor: AppColors.container.neutral700,
                              onChanged: (newValue) {
                                setState(() {
                                  availableForRent = newValue;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Cancel",
                              style: TextStyle(color: Colors.white, fontSize: 16.0)),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        PrimaryButton(
                          width: 200,
                          text: _isLoading ? "Adding..." : "Save Car",
                          onPressed: _isLoading ? null : _addVehicle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
