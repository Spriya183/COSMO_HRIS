import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:attendance_system/service/config/config.dart';

class CheckinApiServices {
  static final _storage = FlutterSecureStorage();
  static const _cookieKey = 'sessionCookie';

  // Save cookie securely
  static Future<void> _saveSessionCookie(String cookie) async {
    await _storage.write(key: _cookieKey, value: cookie);
  }

  // Load stored cookie
  static Future<String?> _getSessionCookie() async {
    return await _storage.read(key: _cookieKey);
  }

  static Future<Map<String, dynamic>> checkinRecord() async {
    final url = Config.getCheckIn;

    try {
      String? sessionCookie = await _getSessionCookie();

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      print('Raw response: ${response.body}');
      print('Headers: ${response.headers}');

      // Save cookie if received
      if (response.headers.containsKey('set-cookie')) {
        final rawCookie = response.headers['set-cookie']!;
        final cookie =
            rawCookie.split(
              ';',
            )[0]; // only take first part like "JSESSIONID=abc"
        await _saveSessionCookie(cookie);
        print('Session cookie saved: $cookie');
      }
      print("CheckIn API status: ${response.statusCode}");
      print("CheckOut API response: ${response.body}");

      final responseBody = jsonDecode(response.body);
      final code = responseBody['code'];
      final message = responseBody['message'];

      if (code == 200) {
        return {'status': true, 'message': message};
      } else {
        return {'status': false, 'message': message};
      }
    } catch (e) {
      print('Check-In error: $e');
      return {
        'status': false,
        'message': 'An error occurred while checking in.',
      };
    }
  }
}
