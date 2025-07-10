import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:attendance_system/service/config/config.dart';

class AuthenticationApiService {
  static Future<Map<String, dynamic>> authentication() async {
    final url = Config.getAuthentication;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      final responseBody = jsonDecode(response.body);
      final AuthenticationResponse = authentication.fromJson(responseBody);

      if (response.statusCode == 200 && AuthenticationResponse.code == 200) {
        print('Authentication success: $responseBody');
        return {'status': true, 'message': AuthenticationResponse.message};
      } else {
        return {'status': false, 'message': AuthenticationResponse.message};
      }
    } catch (e) {
      print('Authentication error: ${e.toString()}');
      return {'status': false, 'message': 'You are not Authenticated'};
    }
  }
}

extension on Future<Map<String, dynamic>> Function() {
  fromJson(responseBody) {}
}
