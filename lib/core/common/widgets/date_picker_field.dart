import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vrooom/core/common/widgets/app_svg.dart';
import 'package:vrooom/core/configs/assets/app_vectors.dart';
import 'package:vrooom/core/configs/theme/app_colors.dart';
import 'package:vrooom/core/configs/theme/app_spacing.dart';
import '../../../domain/entities/booked_date.dart';

class DatePickerField extends StatefulWidget {
  final String label;
  final String hintText;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime? initialDate;
  final List<BookedDate> bookedDates;
  final bool isEndDate;
  final DateTime? startDate;

  const DatePickerField({
    super.key,
    this.hintText = "Select a date",
    this.onDateSelected,
    required this.label,
    this.initialDate,
    this.bookedDates = const [],
    this.isEndDate = false,
    this.startDate,
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

  DateTime? _findNearestBookedDateAfter(DateTime date) {
    DateTime? nearestBookedStart;
    for (final booked in widget.bookedDates) {
      if (booked.startDate.isAfter(date)) {
        if (nearestBookedStart == null || booked.startDate.isBefore(nearestBookedStart)) {
          nearestBookedStart = booked.startDate;
        }
      }
    }
    return nearestBookedStart;
  }

  bool _isDateSelectable(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);

    if (widget.isEndDate && widget.startDate != null) {
      final normalizedStartDate = DateTime(
        widget.startDate!.year,
        widget.startDate!.month,
        widget.startDate!.day,
      );

      if (normalizedDay.isBefore(normalizedStartDate)) {
        return false;
      }
      for (final booked in widget.bookedDates) {
        final normalizedBookedStart = DateTime(
          booked.startDate.year,
          booked.startDate.month,
          booked.startDate.day,
        );
        final normalizedBookedEnd = DateTime(
          booked.endDate.year,
          booked.endDate.month,
          booked.endDate.day,
        );

        if (normalizedDay.isAfter(normalizedBookedStart.subtract(const Duration(days: 1))) &&
            normalizedDay.isBefore(normalizedBookedEnd.add(const Duration(days: 1)))) {
          return false;
        }
      }
      final nearestBooked = _findNearestBookedDateAfter(normalizedStartDate);
      if (nearestBooked != null && !normalizedDay.isBefore(nearestBooked)) {
        return false;
      }
    } else {
      for (final booked in widget.bookedDates) {
        final normalizedBookedStart = DateTime(
          booked.startDate.year,
          booked.startDate.month,
          booked.startDate.day,
        );
        final normalizedBookedEnd = DateTime(
          booked.endDate.year,
          booked.endDate.month,
          booked.endDate.day,
        );

        if (normalizedDay.isAfter(normalizedBookedStart.subtract(const Duration(days: 1))) &&
            normalizedDay.isBefore(normalizedBookedEnd.add(const Duration(days: 1)))) {
          return false;
        }
      }
    }
    return true;
  }

  DateTime _findValidInitialDate() {
    if (selectedDate != null && _isDateSelectable(selectedDate!)) {
      return selectedDate!;
    }

    if (widget.isEndDate && widget.startDate != null && _isDateSelectable(widget.startDate!)) {
      return widget.startDate!;
    }

    DateTime checkDate =
        widget.isEndDate && widget.startDate != null ? widget.startDate! : DateTime.now();

    final maxDate = DateTime.now().add(const Duration(days: 365));

    while (checkDate.isBefore(maxDate)) {
      if (_isDateSelectable(checkDate)) {
        return checkDate;
      }
      checkDate = checkDate.add(const Duration(days: 1));
    }

    return DateTime.now();
  }

  Future<void> _pickDate() async {
    DateTime? maxSelectableDate;
    if (widget.isEndDate && widget.startDate != null) {
      final nearestBooked = _findNearestBookedDateAfter(widget.startDate!);
      if (nearestBooked != null) {
        maxSelectableDate = nearestBooked.subtract(const Duration(days: 1));
      }
    }

    final validInitialDate = _findValidInitialDate();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: validInitialDate,
      firstDate: widget.isEndDate && widget.startDate != null ? widget.startDate! : DateTime.now(),
      lastDate: maxSelectableDate ?? DateTime.now().add(const Duration(days: 365)),
      selectableDayPredicate: _isDateSelectable,
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
