import 'dart:convert';
import 'package:attendance_system/service/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AttendanceRequestApiService {
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

  // API to get attendance request records
  static Future<Map<String, dynamic>> attendanceRequestRecord({
    required String type,
    required int hour,
    required int minute,
    required String comment,
    required DateTime date,
  }) async {
    final url = Config.getAttendanceRequest;
    //body
    final body = {
      "requestedType": type,
      // "requestedTime": {"hour": hour, "minute": minute, "second": 0, "nano": 0},
      "requestedTime":
          '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',

      "reason": comment,
      "attendanceDate": date.toIso8601String().split('T').first, // YYYY-MM-DD
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
        final cookie = rawCookie.split(';')[0]; // e.g., "JSESSIONID=abc123"
        await _saveSessionCookie(cookie);
        print('Session cookie saved: $cookie');
      }

      final responseBody = jsonDecode(response.body);
      final code = responseBody['code'];
      final message = responseBody['message'];

      if (code == 201) {
        return {'status': true, 'message': message};
      } else {
        return {'status': false, 'message': message};
      }
    } catch (e) {
      print('Attendance request error: $e');
      return {
        'status': false,
        'message': 'An error occurred while requesting attendance.',
      };
    }
  }
}
