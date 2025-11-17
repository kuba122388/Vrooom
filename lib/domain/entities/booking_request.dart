class BookingRequest {
  final int userId;
  final int vehicleId;
  final int insuranceId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final String pickupAddress;
  final String dropOffAddress;

  BookingRequest({
    required this.userId,
    required this.vehicleId,
    required this.insuranceId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.pickupAddress,
    required this.dropOffAddress,
  });
}
