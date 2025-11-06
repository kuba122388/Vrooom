import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/primary_button.dart';
import 'package:vrooom/core/common/widgets/search_filter_module.dart';
import 'package:vrooom/core/configs/routes/app_routes.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:vrooom/presentation/admin/widgets/admin_app_bar.dart';
import 'package:vrooom/presentation/admin/widgets/admin_drawer.dart';
import 'package:vrooom/presentation/admin/widgets/car_inventory_entry.dart';

import '../../../../core/configs/assets/app_images.dart';

class CarManagementPage extends StatelessWidget {
  const CarManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<CarInventoryEntry> carInventory = [
      const CarInventoryEntry(
          carImage: AppImages.mercedes,
          carName: "Mercedes-Benz C-Class",
          carStatus: CarStatus.available,
          fuel: "Petrol",
          mileage: 15000,
          seats: 5,
          transmission: "Automatic",
          price: 55),
      const CarInventoryEntry(
          carImage: AppImages.mercedes,
          carName: "Mercedes-Benz C-Class",
          carStatus: CarStatus.maintenance,
          fuel: "Petrol",
          mileage: 15000,
          seats: 5,
          transmission: "Automatic",
          price: 55),
      const CarInventoryEntry(
          carImage: AppImages.mercedes,
          carName: "Mercedes-Benz C-Class",
          carStatus: CarStatus.unavailable,
          fuel: "Petrol",
          mileage: 15000,
          seats: 5,
          transmission: "Automatic",
          price: 55),
      const CarInventoryEntry(
          carImage: AppImages.mercedes,
          carName: "Mercedes-Benz C-Class",
          carStatus: CarStatus.booked,
          fuel: "Petrol",
          mileage: 15000,
          seats: 5,
          transmission: "Automatic",
          price: 55),
      const CarInventoryEntry(
          carImage: AppImages.mercedes,
          carName: "Mercedes-Benz C-Class",
          carStatus: CarStatus.rented,
          fuel: "Petrol",
          mileage: 15000,
          seats: 5,
          transmission: "Automatic",
          price: 55),
    ];

    return Scaffold(
      appBar: const AdminAppBar(
        title: "Manage cars",
      ),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SearchFilterModule(),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                "Car Inventory",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              ...carInventory.map((entry) {
                return CarInventoryEntry(
                    carImage: entry.carImage,
                    carName: entry.carName,
                    carStatus: entry.carStatus,
                    fuel: entry.fuel,
                    mileage: entry.mileage,
                    seats: entry.seats,
                    transmission: entry.transmission,
                    price: entry.price);
              }).expand(
                (widget) => [widget, const SizedBox(height: AppSpacing.sm)],
              ),
              PrimaryButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.addNewCar);
                },
                text: "Add New Car",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
