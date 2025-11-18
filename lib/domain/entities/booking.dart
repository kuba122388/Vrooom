class Booking {
  final int? bookingID;
  final String? customerName;
  final String? vehicleMake;
  final String? vehicleModel;
  final int? vehicleProductionYear;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? pickupAddress;
  final String? dropOffAddress;
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
    required this.vehicleProductionYear,
    required this.startDate,
    required this.endDate,
    required this.pickupAddress,
    required this.dropOffAddress,
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
    required this.vehicleID,
  });

  Booking copyWith({
    double? penalty,
    String? notes,
    DateTime? actualReturnDate,
  }) {
    return Booking(
      bookingID: bookingID,
      customerName: customerName,
      vehicleMake: vehicleMake,
      vehicleModel: vehicleModel,
      vehicleProductionYear: vehicleProductionYear,
      startDate: startDate,
      endDate: endDate,
      pickupAddress: pickupAddress,
      dropOffAddress: dropOffAddress,
      totalAmount: totalAmount,
      vehicleImage: vehicleImage,
      customerSurname: customerSurname,
      customerEmail: customerEmail,
      customerPhoneNumber: customerPhoneNumber,
      actualReturnDate: actualReturnDate ?? this.actualReturnDate,
      penalty: penalty ?? this.penalty,
      notes: notes ?? this.notes,
      bookingStatus: bookingStatus,
      verified: verified,
      pricePerDay: pricePerDay,
      deposit: deposit,
      insuranceType: insuranceType,
      insuranceCost: insuranceCost,
      insuranceDescription: insuranceDescription,
      vehicleID: vehicleID,
    );
  }
}
