import 'package:attendance_system/model/authenticate_model/employee_authentication_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:attendance_system/service/config/config.dart';

class EmployeeAuthenticationApiServices {
  //1
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _cookiekey = 'sessionCookie';

  //cookie 1
  static Future<String?> _getSessionCookie() async {
    final cookie = await _storage.read(key: _cookiekey);
    print('Loaded cookie: $cookie');
    return cookie;
  }

  static Future<EmployeeAuthentication?> authenticateEmployee() async {
    final url = Config.getemployeeauthentication;

    //2

    try {
      //cookiee 2
      String? sessionCookie = await _getSessionCookie();

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          //here
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
      );
      //3
      final setCookie = response.headers['set-cookie'];
      if (setCookie != null) {
        final sessionCookie = setCookie.split(';').first;
        await _storage.write(key: _cookiekey, value: sessionCookie);
        print('Cookie saved: $sessionCookie');
      } else {
        print('No Set-Cookie header found in the response.');
      }

      //4
      print('Raw response: ${response.body}');
      final responseBody = jsonDecode(response.body);
      final employeeAuthenticationresponse = EmployeeAuthentication.fromJson(
        responseBody,
      );

      //5
      if (response.statusCode == 200 &&
          employeeAuthenticationresponse.code == 200) {
        return employeeAuthenticationresponse;
      } else {
        return null;
      }
    } catch (e) {
      print('Authentication error: $e');
      return null;
    }
  }
}
