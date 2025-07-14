class VerifyOtp {
  final String httpStatus;
  final String message;
  final int code;
  final Data? data;
  final bool asyncRequest;
  final String email;
  final int opt;
  final String password;
  final String confirmPassword;

  VerifyOtp({
    required this.httpStatus,
    required this.message,
    required this.code,
    required this.data,
    required this.asyncRequest,
    required this.email,
    required this.opt,
    required this.password,
    required this.confirmPassword,
  });

  factory VerifyOtp.fromJson(Map<String, dynamic> json) {
    return VerifyOtp(
      httpStatus: json['httpStatus'] ?? '',
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      asyncRequest: json['asyncRequest'] ?? false,
      email: json['email'] ?? '',
      opt: json['otp'] ?? 0,
      password: json['password'] ?? '',
      confirmPassword: json['confirmPassword'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'httpStatus': httpStatus,
      'message': message,
      'code': code,
      'data': data?.toJson(),
      'asyncRequest': asyncRequest,
      'email': email,
      "otp": opt,
      "password": password,
      "confirmPassword": confirmPassword,
    };
  }
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
