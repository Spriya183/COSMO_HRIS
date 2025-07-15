class ReportModel {
  final int? id;
  final String? status;
  final String? attendanceDate;
  final String? checkInTime;
  final String? checkOutTime;

  ReportModel({
    this.id,
    this.status,
    this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
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
