class EmployeeAuthentication {
  String httpStatus;
  String message;
  int code;
  bool asyncRequest;
  EmployeeData? data;

  EmployeeAuthentication({
    required this.httpStatus,
    required this.message,
    required this.code,
    required this.asyncRequest,
    required this.data,
  });

  factory EmployeeAuthentication.fromJson(Map<String, dynamic> json) {
    return EmployeeAuthentication(
      httpStatus: json['httpStatus'] ?? '',
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
      asyncRequest: json['asyncRequest'] ?? false,
      data: json['data'] != null ? EmployeeData.fromJson(json['data']) : null,
    );
  }
}

class EmployeeData {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String dob;
  final String dateOfJoining;
  final String gender;
  final String status;
  final String bloodGroup;
  final String department;
  final String position;
  final String imageUrl;

  EmployeeData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.dob,
    required this.dateOfJoining,
    required this.gender,
    required this.status,
    required this.bloodGroup,
    required this.department,
    required this.position,
    required this.imageUrl,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      dob: json['dob'] ?? '',
      dateOfJoining: json['dateOfJoining'] ?? '',
      gender: json['gender'] ?? '',
      status: json['status'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      department: json['department'] ?? '',
      position: json['position'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
