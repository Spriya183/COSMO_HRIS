import 'dart:convert';

import 'package:attendance_system/service/config/config.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordApiServices {
  static Future<Map<String, dynamic>> forgetPassword(String email) async {
    final url = Config.getOtp;
    final requestBody = {'email': email};

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      final responseBody = jsonDecode(response.body);
      final code = responseBody['code'];
      final message = responseBody['message'];

      if (code == 200) {
        return {'status': true, 'message': message};
      } else {
        return {'status': false, 'message': message};
      }
    } catch (e) {
      print('Error during sending OTP $e');
      return {'code': 500, 'message': 'An unexpected error occurred'};
    }
  }
}
