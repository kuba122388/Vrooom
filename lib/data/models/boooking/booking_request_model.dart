import 'package:vrooom/domain/entities/booking_request.dart';

class BookingRequestModel extends BookingRequest {
  BookingRequestModel({
    required super.userId,
    required super.vehicleId,
    required super.insuranceId,
    required super.startDate,
    required super.endDate,
    required super.totalPrice,
    required super.pickupAddress,
    required super.dropOffAddress,
  });

  factory BookingRequestModel.fromEntity(BookingRequest entity) {
    return BookingRequestModel(
      userId: entity.userId,
      vehicleId: entity.vehicleId,
      startDate: entity.startDate,
      endDate: entity.endDate,
      insuranceId: entity.insuranceId,
      totalPrice: entity.totalPrice,
      pickupAddress: entity.pickupAddress,
      dropOffAddress: entity.dropOffAddress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "vehicleId": vehicleId,
      "insuranceId": insuranceId,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String(),
      "totalPrice": totalPrice,
      "pickupAddress": pickupAddress,
      "dropOffAddress": dropOffAddress,
    };
  }
}
