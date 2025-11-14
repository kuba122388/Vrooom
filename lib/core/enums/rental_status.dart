import 'dart:ui';

import '../configs/theme/app_colors.dart';

enum RentalStatus {
  active,
  pending,
  completed,
  cancelled,
  confirmed,
  finished,
  overdue,
  inProgress,
  penalty;

  Color get color {
    switch (this) {
      case RentalStatus.pending:
        return AppColors.container.progress200;
      case RentalStatus.confirmed:
        return AppColors.container.complete200;
      case RentalStatus.cancelled:
        return AppColors.container.danger500;
      case RentalStatus.active:
        return AppColors.container.claret;
      case RentalStatus.completed:
        return AppColors.container.neutral800;
      case RentalStatus.finished:
        return AppColors.container.danger500;
      case RentalStatus.inProgress:
        return AppColors.container.progress200;
      case RentalStatus.penalty:
        return AppColors.primary;
      case RentalStatus.overdue:
        return AppColors.primary;
    }
  }

  String get displayText {
    switch (this) {
      case RentalStatus.confirmed:
        return "Confirmed";
      case RentalStatus.cancelled:
        return "Cancelled";
      case RentalStatus.pending:
        return "Pending";
      case RentalStatus.active:
        return "Active";
      case RentalStatus.completed:
        return "Completed";
      case RentalStatus.finished:
        return "Finished";
      case RentalStatus.inProgress:
        return "In progress";
      case RentalStatus.penalty:
        return "Penalty";
      case RentalStatus.overdue:
        return "Overdue";
    }
  }

  static RentalStatus getRentalStatus(String status) {
    switch (status) {
      case "Active":
        return RentalStatus.active;
      case "Pending":
        return RentalStatus.pending;
      case "Completed":
        return RentalStatus.completed;
      case "Cancelled":
        return RentalStatus.cancelled;
      case "Confirmed":
        return RentalStatus.confirmed;
      case "Finished":
        return RentalStatus.finished;
      case "Overdue":
        return RentalStatus.finished;
      case "In Progress":
        return RentalStatus.inProgress;
      default:
        return RentalStatus.penalty;
    }
  }
}
