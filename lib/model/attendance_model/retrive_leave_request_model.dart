class retriveLeaveRequestData {
  String httpStatus;
  String message;
  int code;
  List<retriveLeaveRequestData>? data;
  bool asyncRequest;

  String? startDate;
  String? endDate;
  String? reason;
  Status? status;
  String? createdAt;
  LeavePolicy? leavePolicy;

  retriveLeaveRequestData({
    required this.httpStatus,
    required this.message,
    required this.code,
    required this.data,
    required this.asyncRequest,
    this.startDate,
    this.endDate,
    this.reason,
    this.status,
    this.createdAt,
    this.leavePolicy,
  });

  factory retriveLeaveRequestData.fromJson(Map<String, dynamic> json) {
    return retriveLeaveRequestData(
      httpStatus: json['httpStatus'] ?? '',
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
      data:
          json['data'] != null
              ? (json['data'] as List)
                  .map((item) => retriveLeaveRequestData.fromJson(item))
                  .toList()
              : null,
      asyncRequest: json['asyncRequest'] ?? false,
      startDate: json['startDate'],
      endDate: json['endDate'],
      reason: json['reason'],
      createdAt: json['createdAt'],
      status: json['status'] != null ? Status.fromJson(json['status']) : null,
      leavePolicy:
          json['leavePolicy'] != null
              ? LeavePolicy.fromJson(json['leavePolicy'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'status': status?.toJson(),
      'endDate': endDate,
      'reason': reason,
      'createdAt': createdAt,
      'leavePolicy': leavePolicy?.toJson(),
    };
  }
}

class Status {
  String? status;

  Status({this.status});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(status: json['status']);
  }

  Map<String, dynamic> toJson() => {'status': status};
}

class LeavePolicy {
  String? leaveType;
  String? maxDay;

  LeavePolicy({this.leaveType, this.maxDay});

  factory LeavePolicy.fromJson(Map<String, dynamic> json) {
    return LeavePolicy(leaveType: json['leaveType'], maxDay: json['maxDay']);
  }

  Map<String, dynamic> toJson() => {'leaveType': leaveType, 'maxDay': maxDay};
}
