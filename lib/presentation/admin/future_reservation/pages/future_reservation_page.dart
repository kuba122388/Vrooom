import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/search_car_module/search_filter_module.dart';
import 'package:vrooom/presentation/admin/widgets/admin_app_bar.dart';
import 'package:vrooom/presentation/admin/widgets/admin_drawer.dart';
import 'package:vrooom/presentation/admin/widgets/rental_information_entry.dart';

import '../../../../core/common/widgets/search_car_module/filter_state.dart';
import '../../../../core/configs/assets/app_images.dart';
import '../../../../core/configs/di/service_locator.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../../core/enums/rental_status.dart';
import '../../../../domain/usecases/vehicle/get_rental_locations_usecase.dart';
import '../../../../domain/usecases/vehicle/get_vehicle_equipment_usecase.dart';

class FutureReservation extends StatelessWidget {
  final FilterState _filterState = FilterState(
    getRentalLocationsUseCase: sl<GetRentalLocationsUseCase>(),
    getVehicleEquipmentUseCase: sl<GetVehicleEquipmentUseCase>(),
  );


  FutureReservation({super.key});

  @override
  Widget build(BuildContext context) {
    List<RentalInformationEntry> rentalInformation = [
      RentalInformationEntry(
        profileImage: AppImages.person,
        firstName: "Marek",
        surname: "Mostowiak",
        reservationID: "RENT001",
        pickupDate: DateTime.now(),
        returnDate: DateTime.now().add(const Duration(days: 5)),
        rentalStatus: RentalStatus.pending,
        carImage: AppImages.mercedes,
        model: "Mercedes-Benz",
        productionYear: 2022,
      ),
      RentalInformationEntry(
        profileImage: AppImages.person,
        firstName: "Kacper",
        surname: "Klimkiewicz",
        reservationID: "RENT002",
        pickupDate: DateTime.now(),
        returnDate: DateTime.now().add(const Duration(days: 5)),
        rentalStatus: RentalStatus.confirmed,
        carImage: AppImages.mercedes,
        model: "Mercedes-Benz",
        productionYear: 2021,
      ),
      RentalInformationEntry(
        profileImage: AppImages.person,
        firstName: "Henryk",
        surname: "Sienkiewicz",
        reservationID: "RENT003",
        pickupDate: DateTime.now(),
        returnDate: DateTime.now().add(const Duration(days: 5)),
        rentalStatus: RentalStatus.cancelled,
        carImage: AppImages.mercedes,
        model: "Mercedes-Benz",
        productionYear: 2022,
      )
    ];

    return Scaffold(
      appBar: const AdminAppBar(title: "Future Reservations"),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchFilterModule(filterState: _filterState,),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                "Upcoming Rentals",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              ...rentalInformation.map((entry) {
                return RentalInformationEntry(
                  profileImage: entry.profileImage,
                  firstName: entry.firstName,
                  surname: entry.surname,
                  reservationID: entry.reservationID,
                  pickupDate: entry.pickupDate,
                  returnDate: entry.returnDate,
                  rentalStatus: entry.rentalStatus,
                  carImage: entry.carImage,
                  model: entry.model,
                  productionYear: entry.productionYear,
                );
              }).expand((widget) => [widget, const SizedBox(height: AppSpacing.sm)])
            ],
          ),
        ),
      ),
    );
  }
}
