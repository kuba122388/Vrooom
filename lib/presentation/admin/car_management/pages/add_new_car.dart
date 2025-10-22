import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/custom_dropdown.dart';
import 'package:vrooom/core/common/widgets/custom_text_field.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';

import '../../../../core/common/widgets/app_svg.dart';

class AddNewCar extends StatefulWidget {
  const AddNewCar({super.key});

  @override
  State<AddNewCar> createState() => _AddNewCarState();
}

class _AddNewCarState extends State<AddNewCar> {
  final ScrollController _scrollController = ScrollController();
  List<String> fuelTypes = ['Petrol', 'Diesel', 'Electric', 'Hybrid', 'Gas', 'LPG'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Add New Car",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          backgroundColor: AppColors.primary,
        ),
        body: Container(
          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12.0)),
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              child: Column(children: [
                const Text(
                  "Add a new Vehicle to Your Fleet",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                const Text(
                  "Fill out the details below to add a new car to your rental inventory",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),

                const Text("Basic Car Information",style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),),


                CustomTextField(hintText: 'e.g., Toyota', label: "Make",leadingIcon: AppSvg.car(),),
                const CustomTextField(hintText: 'e.g., Camry SE', label: "Model"),
                const CustomTextField(hintText: 'e.g., Camry SE', label: "Year"),
                const CustomTextField(hintText: 'e.g., Midnight Black', label: "Color"),

                const Text("Detailed Specifications",style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                ),),


                const CustomTextField(hintText: 'e.g., Toyota', label: "Licence Plate"),
                const CustomTextField(hintText: 'e.g., Toyota', label: "Seating Capacity"),
                CustomDropdownMenu(items: fuelTypes, label:"Fuel type",hintText: "Select fuel type",),

                const CustomTextField(hintText: 'e.g., Toyota', label: "Fuel type"),
              ])),
        ));
  }
}
