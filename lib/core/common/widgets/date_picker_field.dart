import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/configs/assets/app_vectors.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';

class DatePickerField extends StatefulWidget {
  final String label;
  final String hintText;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime? initialDate; // ← Add this

  const DatePickerField({
    super.key,
    this.hintText = "Select a date",
    this.onDateSelected,
    required this.label,
    this.initialDate,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  void didUpdateWidget(DatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      setState(() {
        selectedDate = widget.initialDate;
      });
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.red,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      widget.onDateSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        selectedDate != null ? DateFormat('dd MMM yyyy').format(selectedDate!) : widget.hintText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16.0,
            letterSpacing: -0.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: AppSpacing.xxs,
        ),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: AppColors.text.neutral400),
            ),
            child: Row(
              children: [
                AppSvg(
                  asset: AppVectors.calendar,
                  color: AppColors.svg.neutral200,
                  height: 16.0,
                ),
                const SizedBox(
                  width: AppSpacing.xs,
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: selectedDate == null ? AppColors.text.neutral400 : Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: AppSpacing.md,
        )
      ],
    );
  }
}
