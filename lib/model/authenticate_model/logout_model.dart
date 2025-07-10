class UserLogout {
  String httpStatus;
  String message;
  int code;
  Data? data;
  bool asyncRequest;

  UserLogout({
    required this.httpStatus,
    required this.message,
    required this.code,
    this.data,
    required this.asyncRequest,
  });

  factory UserLogout.fromJson(Map<String, dynamic> json) {
    return UserLogout(
      httpStatus: json['httpStatus'],
      message: json['message'],
      code: json['code'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      asyncRequest: json['asyncRequest'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'httpStatus': httpStatus,
      'message': message,
      'code': code,
      'asyncRequest': asyncRequest,
    };
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
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
