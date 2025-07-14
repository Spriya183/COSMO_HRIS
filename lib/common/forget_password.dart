import 'package:flutter/material.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key, required String email});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            //logic
          },
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
              color: Color(0xff666666A8),
              fontSize: 16,
              fontFamily: 'roboto',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  static Future<ForgetPassword?> fromJson(Map<String, dynamic> data) async {}

  Object? toJson() {}
}
