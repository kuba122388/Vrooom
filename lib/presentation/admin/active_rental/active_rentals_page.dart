import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vrooom/presentation/admin/active_rental/widgets/search_filter_module_active.dart';
import 'package:vrooom/presentation/admin/rental_history/widgets/rental_history_car_entry.dart';

import '../../../core/common/widgets/loading_widget.dart';
import '../../../core/common/widgets/search_car_module/filter_state.dart';
import '../../../../core/configs/theme/app_spacing.dart';
import '../../../core/common/widgets/primary_button.dart';
import '../../../core/configs/di/service_locator.dart';
import '../../../core/configs/routes/app_routes.dart';
import '../../../core/configs/theme/app_text_styles.dart';
import '../../../core/enums/rental_status.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_drawer.dart';
import 'controllers/vehicle_list_active_controller.dart';

class ActiveRentalsPage extends StatefulWidget {
  const ActiveRentalsPage({super.key});

  @override
  State<ActiveRentalsPage> createState() => _ActiveRentalsPageState();
}

class _ActiveRentalsPageState extends State<ActiveRentalsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => FilterState(
                  getRentalLocationsUseCase: sl(),
                  getVehicleEquipmentUseCase: sl(),
                )),
        ChangeNotifierProxyProvider<FilterState, VehicleListActiveController>(
          create: (context) => VehicleListActiveController(
            filterState: context.read<FilterState>(),
          ),
          update: (_, filterState, previous) => previous!..filterState.loadFilterOptions(),
        ),
      ],
      child: const _ActiveRentalsView(),
    );
  }
}

class _ActiveRentalsView extends StatelessWidget {
  const _ActiveRentalsView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VehicleListActiveController>();
    final filterState = context.watch<FilterState>();

    return Scaffold(
      appBar: const AdminAppBar(
        title: "Active Rentals",
      ),
      drawer: const AdminDrawer(),
      body: LoadingWidget(
        isLoading: controller.isLoading,
        errorMessage: controller.errorMessage,
        refreshFunction: controller.refreshBookings,
        futureResultObj: controller.filteredBookings,
        emptyResultMsg: filterState.hasActiveFilters || controller.searchQuery.isNotEmpty
            ? "No history entries match your filters."
            : "No history data found.",
        staticBuilder: () {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchFilterModuleActive(
                onSearchChanged: controller.onSearchChanged,
                filterState: filterState,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                "Active Rentals",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              if (filterState.hasActiveFilters || controller.searchQuery.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Text(
                    '${controller.filteredBookings.length} bookings found',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          );
        },
        futureBuilder: () => _buildBookings(context, controller),
      ),
    );
  }

  Widget _buildBookings(BuildContext context, VehicleListActiveController controller) {
    return Column(
      children: controller.filteredBookings.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return Column(
          children: [
            if (RentalStatus.fromString(item.bookingStatus!) == RentalStatus.finished) ...[
              Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: RentalHistoryCarEntry(
                        customerPictureSize: 30,
                        vehicleImageSize: 100,
                        booking: item,
                        customerPicture: controller.customerImage[index]),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: PrimaryButton(
                      text: "FINALIZE RENTAL",
                      width: 180,
                      textStyle: AppTextStyles.smallButton,
                      backgroundOpacity: 0.75,
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.finalizeRental,
                          arguments: {"booking": item}).then((value) {
                        if (value == 'refresh') {
                          controller.refreshBookings();
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ] else ...[
              RentalHistoryCarEntry(
                  customerPictureSize: 30,
                  vehicleImageSize: 100,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.userBookingDetails,
                          arguments: {
                            'booking': item,
                            'title': '${item.customerName} ${item.customerSurname}'
                          }).then((value) {
                        if (value == 'refresh') {
                          controller.refreshBookings();
                        }
                      }),
                  booking: item,
                  customerPicture: controller.customerImage[index]),
            ],
            const SizedBox(height: AppSpacing.sm)
          ],
        );
      }).toList(),
    );
  }
}
