import 'dart:convert';

import 'package:attendance_system/model/response_model/today_attendance_status_model.dart';
import 'package:attendance_system/service/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EmployeeStatusApiServices {
  static final _storage = FlutterSecureStorage();
  static const _cookieKey = 'sessionCookie';

  static Future<String?> _getSessionCookie() async {
    final cookie = await _storage.read(key: _cookieKey);
    print('Loaded cookie: $cookie');
    return cookie;
  }

  static Future<employeestatus?> fetchStatusRecords() async {
    final url = Config.gettodaystatus;

    try {
      String? sessionCookie = await _getSessionCookie();

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );

      // Save updated session cookie if present
      final setCookie = response.headers['set-cookie'];
      if (setCookie != null) {
        final newSessionCookie = setCookie.split(';').first;
        await _storage.write(key: _cookieKey, value: newSessionCookie);
        print('Cookie saved: $newSessionCookie');
      } else {
        print('No Set-Cookie header found in the response.');
      }

      print('Raw response: ${response.body}');
      final responseBody = jsonDecode(response.body);
      final statusResponse = employeestatus.fromJson(responseBody);

      if (response.statusCode == 200 && statusResponse.code == 200) {
        return statusResponse;
      } else {
        print('Failed with code: ${statusResponse.code}');
        return null;
      }
    } catch (e) {
      print('Status fetch error: $e');
      return null;
    }
  }
}
