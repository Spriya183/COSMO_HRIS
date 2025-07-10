import 'package:attendance_system/model/authenticate_model/logout_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:attendance_system/service/config/config.dart';

class LogoutApiService {
  static Future<Map<String, dynamic>> employeeLogout() async {
    final url = Config.getLogout;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      final responseBody = jsonDecode(response.body);
      final logoutResponse = UserLogout.fromJson(responseBody);

      if (response.statusCode == 200 && logoutResponse.code == 200) {
        print('Logout success: $responseBody');
        return {'status': true, 'message': logoutResponse.message};
      } else {
        return {'status': false, 'message': logoutResponse.message};
      }
    } catch (e) {
      print('Logout error: ${e.toString()}');
      return {'status': false, 'message': 'An error occurred during logout.'};
    }
  }
}
