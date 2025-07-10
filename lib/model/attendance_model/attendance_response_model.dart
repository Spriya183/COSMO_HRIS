class AttendanceRecords {
  String? httpStatus;
  String? message;
  int? code;
  List<AttendanceRecords>? data;
  bool? asyncRequest;

  // These are the actual attendance fields
  int? id;
  String? status;
  String? attendanceDate;
  String? checkInTime;
  String? checkOutTime;

  AttendanceRecords({
    this.httpStatus,
    this.message,
    this.code,
    this.data,
    this.asyncRequest,

    this.id,
    this.status,
    this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
  });

  factory AttendanceRecords.fromJson(Map<String, dynamic> json) {
    return AttendanceRecords(
      httpStatus: json['httpStatus'],
      message: json['message'],
      code: json['code'],
      data:
          json['data'] != null
              ? (json['data'] as List)
                  .map((item) => AttendanceRecords.fromJson(item))
                  .toList()
              : null,
      asyncRequest: json['asyncRequest'],
      id: json['id'],
      status: json['status'],
      attendanceDate: json['attendanceDate'],
      checkInTime: json['checkInTime'],
      checkOutTime: json['checkOutTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'attendanceDate': attendanceDate,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
    };
  }
}
