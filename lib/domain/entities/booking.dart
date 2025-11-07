class Booking {
  final int? bookingID;
  final String? customerName;
  final String? vehicleMake;
  final String? vehicleModel;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? totalAmount;
  final String? vehicleImage;
  final String? customerSurname;
  final String? customerEmail;
  final String? customerPhoneNumber;
  final DateTime? actualReturnDate;
  final double? penalty;
  final String? notes;
  final String? bookingStatus;
  final bool? verified;
  final double? pricePerDay;
  final double? deposit;
  final String? insuranceType;
  final double? insuranceCost;
  final String? insuranceDescription;
  final int? vehicleID;

  Booking({
    required this.bookingID,
    required this.customerName,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.startDate,
    required this.endDate,
    required this.totalAmount,
    required this.vehicleImage,
    required this.customerSurname,
    required this.customerEmail,
    required this.customerPhoneNumber,
    required this.actualReturnDate,
    required this.penalty,
    required this.notes,
    required this.bookingStatus,
    required this.verified,
    required this.pricePerDay,
    required this.deposit,
    required this.insuranceType,
    required this.insuranceCost,
    required this.insuranceDescription,
    required this.vehicleID
  });
}
