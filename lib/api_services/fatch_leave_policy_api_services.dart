import 'dart:convert';
import 'package:attendance_system/model/attendance_model/fatch_leave_policy_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:attendance_system/service/config/config.dart';

class FatchLeavePolicyApiServices {
  static final _storage = FlutterSecureStorage();
  static const _cookieKey = 'sessionCookie';

  static Future<String?> _getSessionCookie() async {
    return await _storage.read(key: _cookieKey);
  }

  static Future<Map<String, dynamic>> fetchLeavePolicy() async {
    final url = Config.getFatchLeavePolicy;

    try {
      String? sessionCookie = await _getSessionCookie();

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final leavePolicyResponse = LeavePolicyResponse.fromJson(responseBody);

        return {
          'status': true,
          'message': leavePolicyResponse.message,
          'data': leavePolicyResponse.data, // List<LeavePolicy>
        };
      } else {
        return {
          'status': false,
          'message': 'Failed with status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'status': false, 'message': 'An error occurred: ${e.toString()}'};
    }
  }
}
