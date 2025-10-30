import 'package:vrooom/data/models/user_model.dart';

class RegisterResponseModel {
  final String jwt;
  final UserModel user;

  RegisterResponseModel({
    required this.jwt,
    required this.user,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      user: UserModel.fromJson(json['user']),
      jwt: json['jwt'] ?? '',
    );
  }
}
