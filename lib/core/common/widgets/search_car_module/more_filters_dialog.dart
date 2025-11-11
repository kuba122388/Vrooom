import 'package:flutter/material.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';

class MoreFiltersDialog extends StatefulWidget {
  final RangeValues initialPriceRange;
  final List<String> initialSelectedEquipment;
  final List<String> availableEquipment;
  final double minPrice;
  final double maxPrice;

  const MoreFiltersDialog({
    super.key,
    required this.initialPriceRange,
    required this.initialSelectedEquipment,
    required this.availableEquipment,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  State<MoreFiltersDialog> createState() => _MoreFiltersDialogState();
}

class _MoreFiltersDialogState extends State<MoreFiltersDialog> {
  late RangeValues _priceRange;
  late List<String> _selectedEquipment;

  @override
  void initState() {
    super.initState();
    _priceRange = widget.initialPriceRange;
    _selectedEquipment = List.from(widget.initialSelectedEquipment);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.container.neutral900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'More Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Price Range Section
              const Text(
                'Price Range (per day)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${_priceRange.start.round()}',
                    style: TextStyle(
                      color: AppColors.text.neutral400,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '\$${_priceRange.end.round()}',
                    style: TextStyle(
                      color: AppColors.text.neutral400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              RangeSlider(
                values: _priceRange,
                min: widget.minPrice,
                max: widget.maxPrice,
                divisions: ((widget.maxPrice - widget.minPrice) / 10).round(),
                activeColor: AppColors.primary,
                inactiveColor: AppColors.container.neutral700,
                onChanged: (RangeValues values) {
                  setState(() {
                    _priceRange = values;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Equipment Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Equipment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_selectedEquipment.isNotEmpty)
                    Text(
                      '${_selectedEquipment.length} selected',
                      style: TextStyle(
                        color: AppColors.text.neutral400,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: widget.availableEquipment.map((equipment) {
                  final isSelected = _selectedEquipment.contains(equipment);
                  return FilterChip(
                    label: Text(equipment),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedEquipment.add(equipment);
                        } else {
                          _selectedEquipment.remove(equipment);
                        }
                      });
                    },
                    backgroundColor: AppColors.container.neutral700,
                    selectedColor: AppColors.primary.withValues(alpha: 0.3),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.text.neutral400,
                      fontSize: 12,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.container.neutral700,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _priceRange = RangeValues(widget.minPrice, widget.maxPrice);
                          _selectedEquipment.clear();
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.container.neutral700),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Clear'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'priceRange': _priceRange,
                          'equipment': _selectedEquipment,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Apply'),
                    ),
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