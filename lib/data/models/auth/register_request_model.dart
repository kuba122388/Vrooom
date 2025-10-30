class RegisterRequestModel {
  final String name;
  final String surname;
  final String email;
  final String password;
  final String phoneNumber;
  final String streetAddress;
  final String city;
  final String postalCode;
  final String country;

  RegisterRequestModel({
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.streetAddress,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  factory RegisterRequestModel.fromJson(json) {
    return RegisterRequestModel(
      name: json["name"] ?? "",
      surname: json["surname"] ?? "",
      email: json["email"] ?? "",
      password: json["password"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      streetAddress: json["streetAddress"] ?? "",
      city: json["city"] ?? "",
      postalCode: json["postalCode"] ?? "",
      country: json["country"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "surname": surname,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
      "streetAddress": streetAddress,
      "city": city,
      "postalCode": postalCode,
      "country": country
    };
  }
}
