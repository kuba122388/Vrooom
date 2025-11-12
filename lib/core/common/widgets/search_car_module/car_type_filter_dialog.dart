import 'package:flutter/material.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';

class CarTypeFilterDialog extends StatefulWidget {
  final String? initialCarType;
  final List<String> availableCarTypes;

  const CarTypeFilterDialog({
    super.key,
    this.initialCarType,
    required this.availableCarTypes,
  });

  @override
  State<CarTypeFilterDialog> createState() => _CarTypeFilterDialogState();
}

class _CarTypeFilterDialogState extends State<CarTypeFilterDialog> {
  String? _selectedCarType;

  @override
  void initState() {
    super.initState();
    _selectedCarType = widget.initialCarType;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.container.neutral900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Car Type',
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
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: widget.availableCarTypes.map((type) {
                final isSelected = _selectedCarType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCarType = selected ? type : null;
                    });
                  },
                  backgroundColor: AppColors.container.neutral700,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.text.neutral400,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, null);
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
                      Navigator.pop(context, _selectedCarType);
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
    );
  }
}