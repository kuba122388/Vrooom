import 'package:vrooom/domain/entities/role.dart';

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
      customerID: json["customerID"] as int,
      name: json["name"] as String,
      surname: json["surname"] as String,
      email: json["email"] as String,
      phoneNumber: json["phoneNumber"] as String? ?? "",
      streetAddress: json["streetAddress"] as String? ?? "",
      city: json["city"] as String? ?? "" ,
      postalCode: json["postalCode"] as String? ?? "",
      country: json["country"] as String? ?? "",
      role: RoleExtension.fromJson(json["role"] as String),
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
      "role": role.toJson(),
    };
  }
}
