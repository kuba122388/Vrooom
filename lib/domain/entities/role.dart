enum Role { admin, customer }

extension RoleExtension on Role {
  String toJson() {
    switch (this) {
      case Role.admin:
        return "ADMIN";
      case Role.customer:
        return "CUSTOMER";
    }
  }

  static Role fromJson(String json) {
    switch (json.toUpperCase()) {
      case "ADMIN":
        return Role.admin;
      case "CUSTOMER":
        return Role.customer;
      default:
        throw Exception("Unknown role: $json");
    }
  }
}
