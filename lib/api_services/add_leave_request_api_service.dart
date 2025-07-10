import 'dart:convert';
import 'package:attendance_system/model/attendance_model/add_leave_request_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:attendance_system/service/config/config.dart';

class AddLeaveRequestApiService {
  static final _storage = FlutterSecureStorage();
  static const _cookieKey = 'sessionCookie';

  // Save session cookie
  static Future<void> _saveSessionCookie(String cookie) async {
    await _storage.write(key: _cookieKey, value: cookie);
  }

  // Retrieve session cookie
  static Future<String?> _getSessionCookie() async {
    return await _storage.read(key: _cookieKey);
  }

  // Add leave request API
  static Future<Map<String, dynamic>> addLeaveRequest({
    required String leaveType,
    required String reason,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final url = Config.getAddLeaveRequest;

    final body = {
      "leaveType": leaveType,
      "reason": reason,
      "startDate": startDate.toIso8601String().split('T').first,
      "endDate": endDate.toIso8601String().split('T').first,
      // "startDate": "2025-07-12",
      // "endDate": "2025-07-12",
    };

    try {
      String? sessionCookie = await _getSessionCookie();

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
        body: jsonEncode(body),
      );

      print('Raw response Body: ${response.body}');
      print('Response Headers: ${response.headers}');

      // Save session cookie if set-cookie header exists
      if (response.headers.containsKey('set-cookie')) {
        final rawCookie = response.headers['set-cookie']!;
        final cookie = rawCookie.split(';')[0];
        await _saveSessionCookie(cookie);
        print('Session cookie saved: $cookie');
      }

      final responseData = jsonDecode(response.body);
      if (responseData == null) {
        return {'status': false, 'message': 'Empty response from server'};
      }

      final leaveResponse = AddLeaveRequest.fromJson(responseData);

      if (leaveResponse.code == 201) {
        return {'status': true, 'message': leaveResponse.message};
      } else {
        return {'status': false, 'message': leaveResponse.message};
      }
    } catch (e) {
      print('Leave request error: $e');
      return {
        'status': false,
        'message': 'An error occurred while requesting leave.',
      };
    }
  }
}
