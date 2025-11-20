import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:attendance_system/model/request_model/quick_attendance_model.dart';
import 'package:attendance_system/service/api_url.dart';
import 'package:http/http.dart' as http;

class QuickAttendanceApiServices {
  static Future<Map<String, dynamic>> quickAttendanceAuthentication(
    String email,
    String password,
    String action,
  ) async {
    final url = Config.getquickattendance;
    final requestBody = QuickAttendanceModel(
      email: email,
      password: password,
      action: action,
    );

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody.toJson()),
      );

      final responseBody = jsonDecode(response.body);
      final code = responseBody['code'];
      final message = responseBody['message'];

      if (code == 200) {
        return {'code': 200, 'message': message};
      } else {
        return {'code': code, 'message': message};
      }
    } on SocketException {
      return {'status': false, 'message': 'No Internet connection'};
    } on TimeoutException {
      return {
        'status': false,
        'message': 'The connection has timed out, please try again',
      };
    } on HttpException {
      return {'status': false, 'message': 'Couldn\'t connect to the server'};
    } catch (e) {
      print('Error during quick attendance: $e');
      return {'message': 'An unexpected error occurred'};
    }
  }
}
