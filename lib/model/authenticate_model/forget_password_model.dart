class ForgetPassword {
  final String httpStatus;
  final String message;
  final int code;
  final Data? data;
  final bool asyncRequest;
  final String email;

  ForgetPassword({
    required this.httpStatus,
    required this.message,
    required this.code,
    required this.data,
    required this.asyncRequest,
    required this.email,
  });

  factory ForgetPassword.fromJson(Map<String, dynamic> json) {
    return ForgetPassword(
      httpStatus: json['httpStatus'] ?? '',
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      asyncRequest: json['asyncRequest'] ?? false,
      email: json['email'] ?? '',
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
