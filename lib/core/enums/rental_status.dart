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

  static RentalStatus fromString(String status) {
    final normalizedStatus = status.toLowerCase().trim();

    switch (normalizedStatus) {
      case "active":
        return RentalStatus.active;
      case "pending":
        return RentalStatus.pending;
      case "completed":
        return RentalStatus.completed;
      case "cancelled":
        return RentalStatus.cancelled;
      case "confirmed":
        return RentalStatus.confirmed;
      case "finished":
        return RentalStatus.finished;
      case "overdue":
        return RentalStatus.overdue;
      case "in progress":
        return RentalStatus.inProgress;
      case "penalty":
        return RentalStatus.penalty;
      default:
        return RentalStatus.pending;
    }
  }
}
