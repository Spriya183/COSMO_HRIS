// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
// import 'package:attendance_system/service/config/config.dart';

// class AuthenticationApiService {
//   static Future<Map<String, dynamic>> authentication() async {
//     final url = Config.getAuthentication;

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//       );

//       final responseBody = jsonDecode(response.body);
//       final code = responseBody['code'];
//       final message = responseBody['message'];

//       return {'code': code, 'status': code == 200, 'message': message};
//     } catch (e) {
//       print('Authentication error: ${e.toString()}');
//       return {
//         'code': 401,
//         'status': false,
//         'message': 'Authentication failed due to an exception',
//       };
//     }
//   }
// }
