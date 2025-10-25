import 'package:flutter/material.dart';
import 'package:vrooom/presentation/admin/rental_history/widgets/rental_history_car_entry.dart';

import '../../../../core/common/widgets/search_filter_module.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../../core/enums/rental_status.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_drawer.dart';

class RentalHistoryPage extends StatelessWidget {
  const RentalHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<RentalHistoryCarEntry> rentalHistory = [
      RentalHistoryCarEntry(
        rentalID: "RENT001",
        startDate: DateTime(2025, 6, 30),
        endDate: DateTime(2025, 7, 30),
        rentalStatus: RentalStatus.completed,
      ),
      RentalHistoryCarEntry(
        rentalID: "RENT002",
        startDate: DateTime(2025, 6, 30),
        endDate: DateTime(2025, 7, 30),
        rentalStatus: RentalStatus.cancelled,
      ),
      RentalHistoryCarEntry(
        rentalID: "RENT003",
        startDate: DateTime(2025, 6, 30),
        endDate: DateTime(2025, 7, 30),
        rentalStatus: RentalStatus.cancelled,
      )
    ];

    return Scaffold(
      appBar: const AdminAppBar(
        title: "Rental History",
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
                "Rental History",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              ...rentalHistory.expand(
                (entry) => [
                  entry,
                  const SizedBox(
                    height: AppSpacing.sm,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
