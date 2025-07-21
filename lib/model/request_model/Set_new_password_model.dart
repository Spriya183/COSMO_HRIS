class SetNewPasswordModel {
  final String email;
  final int otp;
  final String password;
  final String confirmPassword;

  SetNewPasswordModel({
    required this.email,
    required this.otp,
    required this.password,
    required this.confirmPassword,
  });

  factory SetNewPasswordModel.fromJson(Map<String, dynamic> json) {
    return SetNewPasswordModel(
      email: json['email'] ?? '',
      otp: json['otp'] ?? 0,
      password: json['password'] ?? '',
      confirmPassword: json['confirmPassword'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
