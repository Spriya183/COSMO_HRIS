class ForgetPassword {
  final String email;

  ForgetPassword({required this.email});

  factory ForgetPassword.fromJson(Map<String, dynamic> json) {
    return ForgetPassword(email: json['email'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}
