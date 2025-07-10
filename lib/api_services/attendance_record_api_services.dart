import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:attendance_system/model/attendance_model/attendance_response_model.dart';
import 'package:attendance_system/service/config/config.dart';

class AttendanceRecordApiServices {
  static final _storage = FlutterSecureStorage();
  static const _cookieKey = 'sessionCookie';

  static Future<String?> _getSessionCookie() async {
    final cookie = await _storage.read(key: _cookieKey);
    print('Loaded cookie: $cookie');
    return cookie;
  }

  static Future<Map<String, dynamic>> fetchAttendanceRecords() async {
    final url = Config.getRecord;

    try {
      String? sessionCookie = await _getSessionCookie();

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );
      print('Status code: ${response.statusCode}');
      print('Raw response: ${response.body}');
      print('Headers: ${response.headers}');

      if (response.headers.containsKey('set-cookie')) {
        final rawCookie = response.headers['set-cookie']!;
        final cookie = rawCookie.split(';')[0];
        await _storage.write(key: _cookieKey, value: cookie);
        print('Cookie saved: $cookie');
      }

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final attendanceResponse = AttendanceRecords.fromJson(responseBody);

        return {
          'status': true,
          'message': attendanceResponse.message,
          'data': attendanceResponse.data,
        };
      } else {
        return {
          'status': false,
          'message': 'Failed with status code: ${response.statusCode}',
          'body': response.body,
        };
      }
    } catch (e) {
      print('Attendance fetch error: ${e.toString()}');
      return {
        'status': false,
        'message': 'An error occurred while fetching attendance records.',
      };
    }
  }
}
