class QuickAttendanceModel {
  String email;
  String password;
  String action;

  QuickAttendanceModel({
    required this.email,
    required this.password,
    required this.action,
  });

  factory QuickAttendanceModel.fromJson(Map<String, dynamic> json) {
    return QuickAttendanceModel(
      email: json['email'],
      password: json['password'],
      action: json['action'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': this.email,
      'password': this.password,
      'action': this.action,
    };
  }
}
