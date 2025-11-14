enum CarStatus {
  available, maintenance, booked, rented, unavailable, archived;

  static CarStatus fromString(String status) {
    switch (status) {
      case "Available":
        return CarStatus.available;
      case "Maintenance":
        return CarStatus.maintenance;
      case "Booked":
        return CarStatus.booked;
      case "Rented":
        return CarStatus.rented;
      case "Unavailable":
        return CarStatus.unavailable;
      default:
        return CarStatus.archived;
    }
  }
}