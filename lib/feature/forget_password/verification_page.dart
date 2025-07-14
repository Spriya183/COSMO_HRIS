import 'package:attendance_system/api_services/verify_otp_api_services.dart';
import 'package:attendance_system/core/common/custom_base_page.dart';
import 'package:attendance_system/core/common/custom_button.dart';
import 'package:attendance_system/core/common/custom_form_field.dart';
import 'package:attendance_system/core/common/custom_validation.dart';
import 'package:attendance_system/feature/forget_password/forget_password_page.dart';
import 'package:attendance_system/feature/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerificationPage extends StatefulWidget {
  final String email;
  const VerificationPage({super.key, required this.email});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> handleVerifiedPassword(BuildContext context) async {
    final email = widget.email.trim();
    final otp = otpController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await VerifyOtpApiServices.VerifyOtp(
        email,
        int.parse(otp),
        newPassword,
        confirmPassword,
      );

      Navigator.pop(context);

      if (response['code'] == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response['message'])));

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Loginpage()),
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
        'Reset Password',
        style: TextStyle(color: Colors.white),
      ),
      showBackButton: true,
      centerTitle: true,
      colors: const Color(0xff004E64),
      bodyColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            ClipOval(
              child: Image.asset(
                'assets/images/logo.png',
                width: 100.w,
                height: 100.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Forgot Password',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Enter the OTP sent to your email and set a new password',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.black),
            ),
            SizedBox(height: 30.h),

            CustomTextfield(
              controller: otpController,
              hint: 'Enter Your OTP',
              label: 'OTP',
              validator: Validation.passwordValidation,
              prefixIcon: const Icon(Icons.lock),
            ),
            SizedBox(height: 20.h),

            CustomTextfield(
              controller: newPasswordController,
              hint: 'Enter Your New Password',
              label: 'New Password',
              isPassword: true,
              validator: Validation.passwordValidation,
              prefixIcon: const Icon(Icons.lock_outline),
            ),
            SizedBox(height: 20.h),

            CustomTextfield(
              controller: confirmPasswordController,
              hint: 'Confirm Your Password',
              label: 'Confirm Password',
              isPassword: true,
              validator: Validation.passwordValidation,
              prefixIcon: const Icon(Icons.lock_outline),
            ),

            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Resend OTP logic here
                  },
                  child: const Text(
                    "Resend OTP",
                    style: TextStyle(
                      color: Color(0xff666666A8),
                      fontSize: 16,
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            CustomButton(
              text: 'Reset Password',
              prefixIcon: const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
              ),
              onPressed: () => handleVerifiedPassword(context),
            ),
            SizedBox(height: 20.h),

            CustomButton(
              borderColor: const Color(0xff004E64),
              backgroundColor: Colors.white,
              textColor: const Color(0xff004E64),
              text: 'Back to Email',
              prefixIcon: const Icon(
                Icons.arrow_back,
                color: Color(0xff004E64),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
