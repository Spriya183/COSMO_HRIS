import 'dart:convert';
import 'package:attendance_system/service/api_url.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ChangePasswordApiService {
  static final _storage = FlutterSecureStorage();
  static const _cookieKey = 'sessionCookie';

  // Save session cookie to secure storage
  static Future<void> _saveSessionCookie(String cookie) async {
    await _storage.write(key: _cookieKey, value: cookie);
  }

  // Load stored session cookie
  static Future<String?> _getSessionCookie() async {
    return await _storage.read(key: _cookieKey);
  }

  // Change password API call
  static Future<Map<String, dynamic>> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    final url = Config.getChangePassword;

    final requestBody = {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };

    try {
      // Get stored cookie
      String? sessionCookie = await _getSessionCookie();

      // Build headers
      final headers = {
        'Content-Type': 'application/json',
        if (sessionCookie != null) 'Cookie': sessionCookie,
      };

      // Make POST request
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      // Save new session cookie if received
      if (response.headers.containsKey('set-cookie')) {
        final rawCookie = response.headers['set-cookie']!;
        final cookie = rawCookie.split(';').first;
        await _saveSessionCookie(cookie);
        print("New cookie saved: $cookie");
      }

      // Decode response
      final responseBody = jsonDecode(response.body);
      final int? code = responseBody['code'];
      final String message = responseBody['message'];

      if (code == 201) {
        return {'status': true, 'message': message};
      } else {
        return {'status': false, 'message': message};
      }
    } catch (e) {
      print("Exception during change password: $e");
      return {
        'status': false,
        'message': 'An unexpected error occurred. Please try again later.',
      };
    }
  }
}
