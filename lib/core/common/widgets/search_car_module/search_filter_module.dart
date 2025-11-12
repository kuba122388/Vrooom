import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vrooom/core/common/widgets/filter_tile.dart';

import '../../../configs/assets/app_vectors.dart';
import '../../../configs/theme/app_colors.dart';
import '../../../configs/theme/app_spacing.dart';
import '../app_svg.dart';
import 'car_type_filter_dialog.dart';
import 'date_filter_dialog.dart';
import 'filter_state.dart';
import 'location_filter_dialog.dart';
import 'more_filters_dialog.dart';

class SearchFilterModule extends StatelessWidget {
  final void Function(String)? onSearchChanged;
  final FilterState filterState;

  const SearchFilterModule({
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

  Future<void> _showDateFilter(BuildContext context) async {
    final result = await showDialog<DateTimeRange?>(
      context: context,
      builder: (context) => DateFilterDialog(
        initialDateRange: filterState.selectedDateRange,
      ),
    );

    if (result != null || result == null && filterState.selectedDateRange != null) {
      filterState.setDateRange(result);
    }
  }

  Future<void> _showCarTypeFilter(BuildContext context) async {
    final result = await showDialog<String?>(
      context: context,
      builder: (context) => CarTypeFilterDialog(
        initialCarType: filterState.selectedCarType,
        availableCarTypes: filterState.availableCarTypes,
      ),
    );

    if (result != null || result == null && filterState.selectedCarType != null) {
      filterState.setCarType(result);
    }
  }

  Future<void> _showMoreFilters(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (context) => MoreFiltersDialog(
        initialPriceRange: filterState.priceRange,
        initialSelectedEquipment: filterState.selectedEquipment,
        availableEquipment: filterState.availableEquipment,
        minPrice: filterState.minPrice,
        maxPrice: filterState.maxPrice,
      ),
    );

    if (result != null) {
      filterState.setPriceRange(result['priceRange'] as RangeValues);
      filterState.setEquipmentList(result['equipment'] as List<String>);
    }
  }

  String _getLocationText() {
    return filterState.selectedLocation ?? 'Location';
  }

  String _getDateText() {
    if (filterState.selectedDateRange == null) return 'Dates';
    final format = DateFormat('MMM dd');
    return '${format.format(filterState.selectedDateRange!.start)} - ${format.format(filterState.selectedDateRange!.end)}';
  }

  String _getCarTypeText() {
    return filterState.selectedCarType ?? 'Car Type';
  }

  String _getFiltersText() {
    int count = 0;
    if (filterState.selectedEquipment.isNotEmpty) count++;
    if (filterState.priceRange.start != filterState.minPrice ||
        filterState.priceRange.end != filterState.maxPrice) count++;

    return count > 0 ? 'Filters ($count)' : 'Filters';
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
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showDateFilter(context),
                    child: FilterTile(
                      text: _getDateText(),
                      svgPicture: AppVectors.calendar,
                      isActive: filterState.selectedDateRange != null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),

            // Filter Buttons Row 2
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showCarTypeFilter(context),
                    child: FilterTile(
                      text: _getCarTypeText(),
                      svgPicture: AppVectors.car,
                      isActive: filterState.selectedCarType != null,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showMoreFilters(context),
                    child: FilterTile(
                      text: _getFiltersText(),
                      svgPicture: AppVectors.filter,
                      isActive: filterState.selectedEquipment.isNotEmpty ||
                          filterState.priceRange.start != filterState.minPrice ||
                          filterState.priceRange.end != filterState.maxPrice,
                    ),
                  ),
                ),
              ],
            ),

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
