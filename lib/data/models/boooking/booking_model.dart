import 'package:vrooom/domain/entities/booking.dart';

class BookingModel extends Booking {
  BookingModel({
    required super.bookingID,
    required super.customerName,
    required super.vehicleMake,
    required super.vehicleModel,
    required super.startDate,
    required super.endDate,
    required super.totalAmount,
    required super.vehicleImage,
    required super.customerSurname,
    required super.customerEmail,
    required super.customerPhoneNumber,
    required super.actualReturnDate,
    required super.penalty,
    required super.notes,
    required super.bookingStatus,
    required super.verified,
    required super.pricePerDay,
    required super.deposit,
    required super.insuranceType,
    required super.insuranceCost,
    required super.insuranceDescription,
    required super.vehicleID});

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingID: json["bookingId"] as int?,
      customerName: json["customerName"] as String?,
      vehicleMake: json["vehicleMake"] as String?,
      vehicleModel: json["vehicleModel"] as String?,
      startDate: json["startDate"] != null
        ? DateTime.tryParse(json["startDate"])
        : null,
      endDate: json["endDate"] != null
        ? DateTime.tryParse(json["endDate"])
        : null,
      totalAmount: json["totalAmount"] as double?,
      vehicleImage: "http://192.168.0.168:8080/images/${json["vehicleImage"] as String?}",
      customerSurname: json["customerSurname"] as String?,
      customerEmail: json["customerEmail"] as String?,
      customerPhoneNumber: json["customerPhoneNumber"] as String?,
      actualReturnDate: json["actualReturnDate"] != null
        ? DateTime.tryParse(json["actualReturnDate"])
        : null,
      penalty: json["penalty"] as double?,
      notes: json["notes"] as String?,
      bookingStatus: json["bookingStatus"] as String?,
      verified: json["verified"] as bool?,
      pricePerDay: json["pricePerDay"] as double?,
      deposit: json["deposit"] as double?,
      insuranceType: json["insuranceType"] as String?,
      insuranceCost: json["insuranceCost"] as double?,
      insuranceDescription: json["insuranceDescription"] as String?,
      vehicleID: json["vehicleID"] as int?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bookingID": bookingID,
      "customerName": customerName,
      "vehicleMake": vehicleMake,
      "vehicleModel": vehicleModel,
      "startDate": startDate,
      "endDate": endDate,
      "totalAmount": totalAmount,
      "vehicleImage": vehicleImage,
      "customerSurname": customerSurname,
      "customerEmail": customerEmail,
      "customerPhoneNumber": customerPhoneNumber,
      "actualReturnDate": actualReturnDate,
      "penalty": penalty,
      "notes": notes,
      "bookingStatus": bookingStatus,
      "verified": verified,
      "pricePerDay": pricePerDay,
      "deposit": deposit,
      "insuranceType": insuranceType,
      "insuranceCost": insuranceCost,
      "insuranceDescription": insuranceDescription,
      "vehicleID": vehicleID
    };
  }
}