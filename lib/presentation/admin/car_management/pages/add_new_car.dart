import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/custom_dropdown.dart';
import 'package:vrooom/core/common/widgets/custom_text_field.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';

import '../../../../core/common/widgets/app_svg.dart';
import '../../../../core/configs/assets/app_vectors.dart';
import '../../../../core/configs/theme/app_spacing.dart';

class AddNewCar extends StatefulWidget {
  const AddNewCar({super.key});

  @override
  State<AddNewCar> createState() => _AddNewCarState();
}

class _AddNewCarState extends State<AddNewCar> {
  final ScrollController _scrollController = ScrollController();
  List<String> fuelTypes = ['Petrol', 'Diesel', 'Electric', 'Hybrid', 'Gas', 'LPG'];
  List<String> capacity = ['2', '4', '5', '6', '7', '8', '9', '10', '12', '16'];
  List<String> transmission = ['Automatic', 'Manual', 'Semi-automatic'];
  bool availableForRent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: "Add New Car"),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.container.neutral700, borderRadius: BorderRadius.circular(12.0)),
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(
                    height: AppSpacing.md,
                  ),
                  const Text(
                    "Add a new Vehicle to Your Fleet",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: AppSpacing.md,
                  ),
                  const Text(
                    "Fill out the details below to add a new car to your rental inventory",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 13.0),
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  const Text(
                    "Basic Car Information",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const CustomTextField(
                    hintText: 'e.g., Toyota',
                    label: "Make",
                  ),
                  const CustomTextField(
                    hintText: 'e.g., Camry SE',
                    label: "Model",
                  ),
                  const CustomTextField(
                    hintText: 'e.g., 2003',
                    label: "Year",
                  ),
                  const CustomTextField(hintText: 'e.g., Midnight Black', label: "Color"),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  const Text(
                    "Detailed Specifications",
                    style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  const CustomTextField(hintText: 'e.g., XYZ-123', label: "Licence Plate", leadingIcon: AppSvg(asset: AppVectors.car)),
                  CustomDropdownMenu(
                    items: capacity,
                    label: "Seating Capacity",
                    hintText: "Select capacity",
                    leadingIcon: const AppSvg(asset: AppVectors.usersRound),
                  ),
                  CustomDropdownMenu(
                    items: fuelTypes,
                    label: "Fuel type",
                    hintText: "Select fuel type",
                    leadingIcon: const AppSvg(asset: AppVectors.fuel),
                  ),
                  CustomDropdownMenu(
                    items: transmission,
                    label: "Transmission",
                    hintText: "Select transmission",
                    leadingIcon: const AppSvg(asset: AppVectors.gitFork),
                  ),
                  const CustomTextField(
                    hintText: 'Provide a detailed description of the car, its features, and condition',
                    label: "Car Description",
                    maxLines: 4,
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  const Text(
                    "Car Images",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.md,
                  ),
                  DottedBorder(
                    color: AppColors.container.neutral800,
                    // border color
                    strokeWidth: 2,
                    // border thickness
                    dashPattern: const [8, 4],
                    // pattern: [length, gap]
                    borderType: BorderType.RRect,
                    // rounded rectangle
                    radius: const Radius.circular(12),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.container.neutral800,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppSvg(
                            asset: AppVectors.upload,
                            height: 40,
                            width: 40,
                          ),
                          SizedBox(height: AppSpacing.md,),
                          Text("Upload a car image", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  const Text(
                    "Pricing & Availability",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const CustomTextField(
                    hintText: 'e.g., 75.00',
                    label: "Rental Price Per Day",
                    leadingIcon: AppSvg(asset: AppVectors.dollarSign),
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(border: Border.all(color: Colors.white24,),
                    borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Available For Rent",style: TextStyle(fontSize: 16.0),),
                          Switch(
                              value: availableForRent,
                              activeThumbColor: AppColors.background,
                              inactiveThumbColor: AppColors.container.neutral900,
                              activeTrackColor: AppColors.primary,
                              inactiveTrackColor: AppColors.container.neutral700,
                              onChanged: (availableForRent) {
                                setState(() {
                                  availableForRent = !availableForRent;
                                });
                              })
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white,fontSize: 16.0),
                        ),
                      ),
                      SizedBox(
                        width: AppSpacing.xs,
                      ),
                      const SizedBox(
                          child: PrimaryButton(
                        text: "Save Car",
                        fontSize: 16,
                      )),
                    ],
                  )
                ])),
          ),
        ));
  }
}
