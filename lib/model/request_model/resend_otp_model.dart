class ResendOtpModel {
  final String email;

  ResendOtpModel({required this.email});

  factory ResendOtpModel.fromJson(Map<String, dynamic> json) {
    return ResendOtpModel(email: json['email'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}
