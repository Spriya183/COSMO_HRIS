import 'package:attendance_system/api_services/forget_password_api_services.dart';
import 'package:attendance_system/common/base_page.dart';
import 'package:attendance_system/common/custom_button.dart';
import 'package:attendance_system/common/custom_textfield.dart';
import 'package:attendance_system/common/validation.dart';
import 'package:attendance_system/login/common/send_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ForgotPasswordPage({super.key});

  Future<void> handleOtp(BuildContext context) async {
    final email = emailController.text.trim();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await ForgetPasswordApiServices.forgetPassword(email);

      Navigator.pop(context);

      if (response['code'] == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response['message'])));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordPage(email: email),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response['message'])));
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: const Text(
        'Forget Password',
        style: TextStyle(color: Colors.white),
      ),
      showBackButton: true,
      centerTitle: true,
      colors: const Color(0xff004E64),
      bodyColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40.h),
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 1.w),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Forgot Password',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Enter your email to receive a password reset OTP',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.black),
            ),
            SizedBox(height: 30.h),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextfield(
                    controller: emailController,
                    hint: 'Enter Your Email',
                    label: 'Email',
                    validator: Validation.validUserName,
                    prefixIcon: const Icon(Icons.email),
                  ),
                  SizedBox(height: 30.h),
                  CustomButton(
                    text: 'Send OTP',
                    prefixIcon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        handleOtp(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
