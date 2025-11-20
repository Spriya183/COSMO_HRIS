class LeavePolicyResponse {
  final String httpStatus;
  final String message;
  final int code;
  final List<LeavePolicy> data;
  final bool asyncRequest;

  LeavePolicyResponse({
    required this.httpStatus,
    required this.message,
    required this.code,
    required this.data,
    required this.asyncRequest,
  });

  factory LeavePolicyResponse.fromJson(Map<String, dynamic> json) {
    return LeavePolicyResponse(
      httpStatus: json['httpStatus'] ?? '',
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
      asyncRequest: json['asyncRequest'] ?? false,
      data: List<LeavePolicy>.from(
        json['data'].map((item) => LeavePolicy.fromJson(item)),
      ),
    );
  }
}

class LeavePolicy {
  final int id;
  final String leaveType;
  final String maxDay;

  LeavePolicy({
    required this.id,
    required this.leaveType,
    required this.maxDay,
  });

  factory LeavePolicy.fromJson(Map<String, dynamic> json) {
    return LeavePolicy(
      id: json['id'],
      leaveType: json['leaveType'],
      maxDay: json['maxDay'],
    );
  }
}
