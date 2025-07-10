class CheckIn {
  final String httpStatus;
  final String message;
  final int code;
  final Data? data;
  final bool asyncRequest;

  CheckIn({
    required this.httpStatus,
    required this.message,
    required this.code,
    required this.data,
    required this.asyncRequest,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      httpStatus: json['httpStatus'] ?? '',
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      asyncRequest: json['asyncRequest'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {
      'httpStatus': httpStatus,
      'message': message,
      'code': code,
      'asyncRequest': asyncRequest,
    };

    if (data != null) {
      dataMap['data'] = data!.toJson();
    }

    return dataMap;
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
