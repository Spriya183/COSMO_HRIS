import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:attendance_system/service/config/config.dart';

class LogoutApiService {
  static Future<Map<String, dynamic>> employeeLogout() async {
    final url = Config.getLogout;
    print("Calling logout API: $url");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      print("Logout API status: ${response.statusCode}");
      print("Logout API response: ${response.body}");

      final responseBody = jsonDecode(response.body);
      final code = responseBody['code'];
      final message = responseBody['message'];

      return {'code': code, 'message': message};
    } catch (e) {
      print('Logout error: $e');
      return {'code': 500, 'message': 'An error occurred during logout.'};
    }
  }
}
