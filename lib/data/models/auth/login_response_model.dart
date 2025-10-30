import 'package:vrooom/data/models/user_model.dart';

class LoginResponseModel {
  final String jwt;
  final UserModel user;

  LoginResponseModel({
    required this.jwt,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: UserModel.fromJson(json['user']),
      jwt: json['jwt'] ?? '',
    );
  }
}
