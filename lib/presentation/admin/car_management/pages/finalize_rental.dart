import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_app_bar.dart';
import 'package:vrooom/core/common/widgets/custom_text_field.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';

import '../../../../core/configs/theme/app_spacing.dart';

class FinalizeRentalPage extends StatefulWidget {
  const FinalizeRentalPage({super.key});

  @override
  State<FinalizeRentalPage> createState() => _FinalizeRentalPageState();
}

class _FinalizeRentalPageState extends State<FinalizeRentalPage> {
  final ScrollController _scrollController = ScrollController();
  List<String> fuelTypes = ['Petrol', 'Diesel', 'Electric', 'Hybrid', 'Gas', 'LPG'];
  List<String> capacity = ['2', '4', '5', '6', '7', '8', '9', '10', '12', '16'];
  List<String> transmission = ['Automatic', 'Manual', 'Semi-automatic'];
  bool availableForRent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: "Finalize Rental"),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12.0)),
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(color: AppColors.container.neutral700, borderRadius: BorderRadius.circular(12.0)),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mileage Details",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: AppSpacing.md,
                          ),
                          CustomTextField(
                            hintText: '',
                            label: "Start Mileage (km)",
                          ),
                          CustomTextField(
                            hintText: '',
                            label: "End Mileage (km)",
                          ),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.md,),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),

                    decoration: BoxDecoration(color: AppColors.container.neutral700, borderRadius: BorderRadius.circular(12.0)),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Fuel Level",
                          style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: AppSpacing.md,
                        ),
                        CustomTextField(
                          hintText: '',
                          label: "Current Fuel Level (%)",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.md,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(color: AppColors.container.neutral700, borderRadius: BorderRadius.circular(12.0)),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Damages & Comments",
                          style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: AppSpacing.md,
                        ),
                        CustomTextField(
                          hintText: '',
                          label: "Damages or Issues",
                          maxLines: 3,
                        ),
                        CustomTextField(
                          hintText: '',
                          label: "Additional Comments",
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: AppColors.container.neutral700,
                            )
                          ),
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: AppSpacing.xs,
                      ),
                      const Expanded(
                          child: PrimaryButton(
                        text: "Save Finalization",
                        textStyle: TextStyle(fontSize: 16.0),
                      )),
                    ],
                  )
                ])),
          ),
        ));
  }
}
