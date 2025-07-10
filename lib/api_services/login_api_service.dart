import 'package:attendance_system/model/authenticate_model/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:attendance_system/service/config/config.dart';

class LoginApiService {
  static final _storage = FlutterSecureStorage();
  static const _cookieKey = 'sessionCookie';

  // Save cookie to secure storage
  static Future<void> _saveSessionCookie(String cookie) async {
    await _storage.write(key: _cookieKey, value: cookie);
  }

  // Public login method
  static Future<Map<String, dynamic>> authenticateEmployee(
    String email,
    String password,
  ) async {
    final url = Config.getLogin;
    final authenticateRequest = UserLogin(email: email, password: password);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(authenticateRequest.toJson()),
      );

      // Handle and store cookie
      if (response.headers.containsKey('set-cookie')) {
        final rawCookie = response.headers['set-cookie']!;
        final cookie = rawCookie.split(';')[0]; // e.g. jwt=abc123...
        await _saveSessionCookie(cookie);
        print(" Cookie saved: $cookie");
      } else {
        print(" No Set-Cookie received from server.");
      }

      final responseBody = jsonDecode(response.body);
      final code = responseBody['code'];
      final message = responseBody['message'];

      if (code == 200) {
        return {'code': 200, 'message': message};
      } else {
        return {'code': code, 'message': message};
      }
    } catch (e) {
      print("Login error: ${e.toString()}");
      return {'message': 'An error occurred during logout.'};
    }
  }

  // Getter for session cookie
  static Future<String?> getSessionCookie() async {
    return await _storage.read(key: _cookieKey);
  }
}
