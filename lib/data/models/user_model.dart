import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel(
      {required super.customerID,
      required super.name,
      required super.surname,
      required super.email,
      required super.phoneNumber,
      required super.streetAddress,
      required super.city,
      required super.postalCode,
      required super.country,
      required super.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      customerID: json["customerID"] ?? "",
      name: json["name"] ?? "",
      surname: json["surname"] ?? "",
      email: json["email"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      streetAddress: json["streetAddress"] ?? "",
      city: json["city"] ?? "",
      postalCode: json["postalCode"] ?? "",
      country: json["country"] ?? "",
      role: json["role"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "customerID": customerID,
      "name": name,
      "surname": surname,
      "email": email,
      "phoneNumber": phoneNumber,
      "streetAddress": streetAddress,
      "city": city,
      "postalCode": postalCode,
      "country": country,
      "role": role,
    };
  }
}
