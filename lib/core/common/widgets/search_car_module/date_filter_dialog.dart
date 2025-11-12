import 'package:flutter/material.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import 'package:intl/intl.dart';

class DateFilterDialog extends StatefulWidget {
  final DateTimeRange? initialDateRange;

  const DateFilterDialog({
    super.key,
    this.initialDateRange,
  });

  @override
  State<DateFilterDialog> createState() => _DateFilterDialogState();
}

class _DateFilterDialogState extends State<DateFilterDialog> {
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _selectedDateRange = widget.initialDateRange;
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.container.neutral900,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

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
                  'Select Dates',
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
            InkWell(
              onTap: _selectDateRange,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.container.neutral700,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.container.neutral700),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        _selectedDateRange == null
                            ? 'Tap to select date range'
                            : '${dateFormat.format(_selectedDateRange!.start)} - ${dateFormat.format(_selectedDateRange!.end)}',
                        style: TextStyle(
                          color: _selectedDateRange == null
                              ? AppColors.text.neutral400
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_selectedDateRange != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${_selectedDateRange!.duration.inDays + 1} days selected',
                style: TextStyle(
                  color: AppColors.text.neutral400,
                  fontSize: 12,
                ),
              ),
            ],
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
                    onPressed: _selectedDateRange == null
                        ? null
                        : () {
                      Navigator.pop(context, _selectedDateRange);
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