class PasswordRequestModel {
  final String oldPassword;
  final String newPassword;

  PasswordRequestModel({
    required this.oldPassword,
    required this.newPassword
  });

  Map<String, dynamic> toJson() {
    return {
      "oldPassword": oldPassword,
      "newPassword": newPassword
    };
  }
}