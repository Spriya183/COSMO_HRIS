class Checkout {
  String httpStatus;
  String message;
  int code;
  Data? data;
  bool asyncRequest;

  Checkout({
    required this.httpStatus,
    required this.message,
    required this.code,
    required this.data,
    required this.asyncRequest,
  });

  factory Checkout.fromJson(Map<String, dynamic> json) {
    return Checkout(
      httpStatus: json['httpStatus'] as String,
      message: json['message'] as String,
      code: json['code'] as int,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      asyncRequest: json['asyncRequest'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['httpStatus'] = httpStatus;
    result['message'] = message;
    result['code'] = code;
    if (data != null) {
      result['data'] = data!.toJson();
    }
    result['asyncRequest'] = asyncRequest;
    return result;
  }
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};

    return result;
  }
}
