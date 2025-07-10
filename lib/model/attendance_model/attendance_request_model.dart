class AttendanceRequest {
  String requestedType;
  RequestedTime? requestedTime;
  String reason;
  String attendanceDate;
  final String message;
  final int code;

  AttendanceRequest({
    required this.requestedType,
    required this.requestedTime,
    required this.reason,
    required this.attendanceDate,
    required this.message,
    required this.code,
  });

  factory AttendanceRequest.fromJson(Map<String, dynamic> json) {
    return AttendanceRequest(
      requestedType: json['requestedType'] ?? '',
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
      requestedTime:
          json['requestedTime'] != null
              ? RequestedTime.fromJson(json['requestedTime'])
              : null,
      reason: json['reason'] ?? '',
      attendanceDate: json['attendanceDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['requestedType'] = requestedType;
    if (requestedTime != null) {
      data['requestedTime'] = requestedTime!.toJson();
    }
    data['reason'] = reason;
    data['attendanceDate'] = attendanceDate;
    return data;
  }
}

class RequestedTime {
  int hour;
  int minute;
  int second;
  int nano;

  RequestedTime({
    required this.hour,
    required this.minute,
    required this.second,
    required this.nano,
  });

  factory RequestedTime.fromJson(Map<String, dynamic> json) {
    return RequestedTime(
      hour: json['hour'] ?? 0,
      minute: json['minute'] ?? 0,
      second: json['second'] ?? 0,
      nano: json['nano'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'hour': hour, 'minute': minute, 'second': second, 'nano': nano};
  }
}
