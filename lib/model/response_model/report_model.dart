class reportretrive {
  String httpStatus;
  String message;
  int code;
  List<reportretrive> data;
  bool asyncRequest;
  int? id;
  String? status;
  String? attendanceDate;
  String? checkInTime;
  String? checkOutTime;

  reportretrive({
    required this.httpStatus,
    required this.message,
    required this.code,
    required this.data,
    required this.asyncRequest,
    this.id,
    this.status,
    this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
  });

  factory reportretrive.fromJson(Map<String, dynamic> json) {
    return reportretrive(
      httpStatus: json['httpStatus'] ?? '',
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
      data:
          json['data'] != null
              ? List<reportretrive>.from(
                json['data'].map((item) => reportretrive.fromJson(item)),
              )
              : [],
      asyncRequest: json['asyncRequest'] ?? false,

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
