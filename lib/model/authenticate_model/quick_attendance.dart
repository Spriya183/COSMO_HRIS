class QuickAttendance {
  String email;
  String password;
  String action;

  QuickAttendance({
    required this.email,
    required this.password,
    required this.action,
  });

  factory QuickAttendance.fromJson(Map<String, dynamic> json) {
    return QuickAttendance(
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
