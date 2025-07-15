import 'package:attendance_system/api_services/verify_otp_api_services.dart';
import 'package:attendance_system/core/common/custom_base_page.dart';
import 'package:attendance_system/core/common/custom_button.dart';
import 'package:attendance_system/core/common/custom_otp_input_field.dart';
import 'package:attendance_system/feature/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  const OtpVerificationPage({super.key, required this.email});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController otpController = TextEditingController();

  Future<void> handleVerifiedPassword(BuildContext context) async {
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("OTP must be 6 digits")));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await VerifyOtpApiServices.VerifyOtp(
        widget.email,
        int.parse(otp),
      );

      Navigator.pop(context);

      if (response['status'] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response['message'])));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Loginpage()),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Verify OTP',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Enter the 6-digit code sent to your email',
                style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25.h),
              //pin
              CustomOtpInputFormField(
                numberOfFields: 6,
                fieldWidth: 50,
                fieldHeight: 60,
                borderRadius: 12,
                autoFocus: true,
                textStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                focusedBorderColor: Color(0xff004E64),
                fillColor: Colors.white,
                borderColor: Colors.black,
                otpController: otpController,
                onChanged: (value) {
                  (' $value');
                },
                onCompleted: (value) {
                  ('$value');
                },
              ),

              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive code?",
                    style: TextStyle(fontSize: 13.sp),
                  ),
                  SizedBox(width: 5.w),
                  TextButton(
                    onPressed: () {
                      // Resend OTP API call
                    },
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(
                        color: const Color(0xFF79A8F7),
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              CustomButton(
                text: 'Verify OTP',
                onPressed: () => handleVerifiedPassword(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
