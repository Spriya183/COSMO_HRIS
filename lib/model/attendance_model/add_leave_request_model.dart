class AddLeaveRequest {
  final String httpStatus;
  final String message;
  final int code;
  final Data? data;
  final bool asyncRequest;

  AddLeaveRequest({
    required this.httpStatus,
    required this.message,
    required this.code,
    required this.data,
    required this.asyncRequest,
  });

  factory AddLeaveRequest.fromJson(Map<String, dynamic> json) {
    return AddLeaveRequest(
      httpStatus: json['httpStatus'] ?? '',
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      asyncRequest: json['asyncRequest'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'httpStatus': httpStatus,
      'message': message,
      'code': code,
      'data': data?.toJson(),
      'asyncRequest': asyncRequest,
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
