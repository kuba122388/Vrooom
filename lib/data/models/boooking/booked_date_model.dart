import 'package:vrooom/domain/entities/booked_date.dart';

class BookedDateModel extends BookedDate {
  BookedDateModel({
    required super.startDate,
    required super.endDate,
  });

  factory BookedDateModel.fromJson(Map<String, dynamic> json) {
    return BookedDateModel(
      startDate: DateTime.parse(json["startDate"]),
      endDate: DateTime.parse(json["endDate"]),
    );
  }
}
