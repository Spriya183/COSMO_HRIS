class Config {
  //static const String baseUrl = "https://edf6d8ecf612.ngrok-free.app";
  static const String baseUrl = "https://api.cosmotechintl.com/COSMO_HRIS";

  // For login
  static const String _loginEndpoint = "api/v1/auth/authenticate";
  static String get getLogin => "$baseUrl/$_loginEndpoint";

  //for logout
  static const String _logoutEndpoint = "api/v1/auth/logout";
  static String get getLogout => "$baseUrl/$_logoutEndpoint";

  //for check in
  static const String _checkin = "api/v1/attendance/check-in";
  static String get getCheckIn => "$baseUrl/$_checkin";

  //for checkout
  static const String _checkout = "api/v1/attendance/checkout";
  static String get getCheckOut => "$baseUrl/$_checkout";

  //for attendance record
  static const String _attendanceRecord = "api/v1/attendance/getAll";
  static String get getRecord => "$baseUrl/$_attendanceRecord";

  //for quick attendance
  static const String _quickattendance = "api/v1/auth/quick-action";
  static String get getquickattendance => "$baseUrl/$_quickattendance";

  //for employee authentication
  static const String _employeeAuthentication =
      "api/v1/employee/getAuthenticatedEmployee";
  static String get getemployeeauthentication =>
      "$baseUrl/$_employeeAuthentication";

  //for today status
  static const String _todaystatus = "api/v1/attendance/getTodayStatus";
  static String get gettodaystatus => "$baseUrl/$_todaystatus";

  //for attenance request
  static const String _attendancerequest = "api/v1/attendance-request/create";
  static String get getAttendanceRequest => "$baseUrl/$_attendancerequest";

  // //for authenticate employee .. if employee is authenticated direct go to dashboard
  // static const String _authentication = "api/v1/auth/isAuthenticated";
  // static String get getAuthentication => "$baseUrl/$_authentication";

  // add leave request
  static const String _addLeaveRequest = "api/v1/leave-request/create";
  static String get getAddLeaveRequest => "$baseUrl/$_addLeaveRequest";

  // add fetch leave policy
  static const String _fetchLeavePolicy = "api/v1/leave-policy/get";
  static String get getfetchLeavePolicy => "$baseUrl/$_fetchLeavePolicy";

  // add fetch leave policy
  static const String _retriveLeaveRequestdata = "api/v1/leave-request/get-own";
  static String get getLeaveRequestdata => "$baseUrl/$_retriveLeaveRequestdata";

  // add fetch report recoed
  static const String _retriveReportRecord =
      "api/v1/attendance/getMonthlyRecord";
  static String get getReportRecord => "$baseUrl/$_retriveReportRecord";

  // forget password
  static const String _forgetpasswordopt = "api/v1/auth/forget-password";
  static String get getOtp => "$baseUrl/$_forgetpasswordopt";

  // verify otp
  static const String _veriryOpt = "api/v1/auth/verify-otp";
  static String get getVerifyOtp => "$baseUrl/$_veriryOpt";
  // resend otp
  static const String _resendOtp = "api/v1/auth/resend-otp";
  static String get getResendOtp => "$baseUrl/$_resendOtp";

  // set new password
  static const String _setForgetPassword = "api/v1/auth/set-forget-password";
  static String get getsetForgetPassword => "$baseUrl/$_setForgetPassword";

  // change password
  static const String _ChangePassword = "api/v1/employee/change-password";
  static String get getChangePassword => "$baseUrl/$_ChangePassword";
}
