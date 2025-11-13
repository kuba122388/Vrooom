import 'package:flutter/material.dart';
import 'package:vrooom/core/common/widgets/filter_tile.dart';

import '../../../../core/common/widgets/app_svg.dart';
import '../../../../core/common/widgets/search_car_module/filter_state.dart';
import '../../../../core/common/widgets/search_car_module/location_filter_dialog.dart';
import '../../../../core/configs/assets/app_vectors.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/configs/theme/app_spacing.dart';

class SearchFilterModuleHistory extends StatelessWidget {
  final void Function(String)? onSearchChanged;
  final FilterState filterState;

  const SearchFilterModuleHistory({
    super.key,
    this.onSearchChanged,
    required this.filterState,
  });

  Future<void> _showLocationFilter(BuildContext context) async {
    final result = await showDialog<String?>(
      context: context,
      builder: (context) => LocationFilterDialog(
        initialLocation: filterState.selectedLocation,
        availableLocations: filterState.availableLocations,
      ),
    );

    if (result != null || result == null && filterState.selectedLocation != null) {
      filterState.setLocation(result);
    }
  }

  String _getLocationText() {
    return filterState.selectedLocation ?? 'Location';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.container.neutral900,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.container.neutral700,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppSvg(
                          asset: AppVectors.search,
                          width: 20,
                          color: AppColors.svg.neutral400,
                        ),
                      ],
                    ),
                  ),
                  hintText: "Search cars, locations...",
                  hintStyle: const TextStyle(letterSpacing: -0.5),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),

            // Filter Buttons Row 1
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showLocationFilter(context),
                    child: FilterTile(
                      text: _getLocationText(),
                      svgPicture: AppVectors.mapPin,
                      isActive: filterState.selectedLocation != null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),

            // Clear All Filters Button
            if (filterState.hasActiveFilters) ...[
              const SizedBox(height: AppSpacing.xs),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => filterState.clearAllFilters(),
                  icon: const Icon(Icons.clear, size: 16),
                  label: const Text('Clear all filters'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.text.neutral400,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
