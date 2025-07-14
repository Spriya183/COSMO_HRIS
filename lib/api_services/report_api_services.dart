import 'dart:convert';

import 'package:attendance_system/model/response_model/report_model.dart';
import 'package:attendance_system/service/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ReportApiServices {
  static final _storage = FlutterSecureStorage();
  static const _cookieKey = 'sessionCookie';

  static Future<String?> _getSessionCookie() async {
    final cookie = await _storage.read(key: _cookieKey);
    print('Loaded cookie: $cookie');
    return cookie;
  }

  static Future<Map<String, dynamic>> fetchReportRecord() async {
    final url = Config.getReportRecord;

    try {
      String? sessionCookie = await _getSessionCookie();

      // Replace these values with actual logic if needed
      final String month = DateTime.now().month.toString().padLeft(2, '0');
      final String year = DateTime.now().year.toString();

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (sessionCookie != null) 'Cookie': sessionCookie,
        },
        body: jsonEncode({"month": month, "year": year}),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.headers.containsKey('set-cookie')) {
        final rawCookie = response.headers['set-cookie']!;
        final cookie = rawCookie.split(';')[0];
        await _storage.write(key: _cookieKey, value: cookie);
      }

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<reportretrive> leaveRequests =
            (responseBody['data'] as List)
                .map((item) => reportretrive.fromJson(item))
                .toList();

        return {
          'status': true,
          'code': responseBody['code'],
          'message': responseBody['message'],
          'data': leaveRequests,
        };
      } else {
        return {
          'status': false,
          'code': response.statusCode,
          'message': responseBody['message'] ?? 'Bad request',
          'body': response.body,
        };
      }
    } catch (e) {
      return {
        'status': false,
        'code': 500,
        'message': 'Exception: ${e.toString()}',
      };
    }
  }
}
