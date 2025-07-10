class employeestatus {
  String httpStatus;
  String message;
  int code;
  bool asyncRequest;
  StatusData? Data;

  employeestatus({
    required this.httpStatus,
    required this.message,
    required this.code,
    required this.Data,
    required this.asyncRequest,
  });

  factory employeestatus.fromJson(Map<String, dynamic> json) {
    return employeestatus(
      httpStatus: json['httpStatus'] ?? '',
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
      Data: json['data'] != null ? StatusData.fromJson(json['data']) : null,
      asyncRequest: json['asyncRequest'] ?? false,
    );
  }
}

class StatusData {
  final String? status;

  final String? checkInTime;
  final String? checkOutTime;

  StatusData({
    required this.status,

    required this.checkInTime,
    required this.checkOutTime,
  });

  factory StatusData.fromJson(Map<String, dynamic> json) {
    return StatusData(
      status: json['status'] ?? '',
      checkOutTime: json['checkOutTime'] ?? '',
      checkInTime: json['checkInTime'] ?? '',
    );
  }
}
