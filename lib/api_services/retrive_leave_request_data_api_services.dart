import 'dart:convert';

import 'package:attendance_system/model/response_model/leave_request_model.dart';
import 'package:attendance_system/service/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RetriveLeaveRequestDataApiServices {
  static final _storage = FlutterSecureStorage();
  static const _cookieKey = 'sessionCookie';

  static Future<String?> _getSessionCookie() async {
    final cookie = await _storage.read(key: _cookieKey);
    print('Loaded cookie: $cookie');
    return cookie;
  }

  static Future<Map<String, dynamic>> fetchLeaveRequestRecords() async {
    final url = Config.getLeaveRequestdata;

    try {
      String? sessionCookie = await _getSessionCookie();

      final response = await http.post(
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

        final parsedResponse = retriveLeaveRequestData.fromJson(responseBody);

        return {
          'code': parsedResponse.code,
          'message': parsedResponse.message,
          'data': parsedResponse.data,
        };
      } else {
        return {
          'message': 'Failed with status code: ${response.statusCode}',
          'body': response.body,
        };
      }
    } catch (e) {
      print('Leave Request fetch error: ${e.toString()}');
      return {
        'status': false,
        'message': 'An error occurred while fetching Leave Request records.',
      };
    }
  }
}
