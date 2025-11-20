import 'package:attendance_system/api_services/set_new_password_api_services.dart';
import 'package:attendance_system/core/common/custom_base_page.dart';
import 'package:attendance_system/core/common/custom_button.dart';
import 'package:attendance_system/core/common/custom_error_success_box.dart';
import 'package:attendance_system/core/common/custom_form_field.dart';
import 'package:attendance_system/core/common/custom_validation.dart';
import 'package:attendance_system/feature/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetPasswordPage extends StatelessWidget {
  final String email;
  final int otp;

  SetPasswordPage({Key? key, required this.email, required this.otp})
    : super(key: key);

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> handleSetPassword(BuildContext context) async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      ShowDialog(
        context: context,
      ).showErrorStateDialog(body: "Passwords do not match");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await SetNewPasswordApiServices.SetNewPassword(
        email,
        otp,
        newPassword,
        confirmPassword,
      );

      Navigator.pop(context);

      if (response['status'] == true) {
        ShowDialog(context: context).showSucessStateDialog(
          body: response['message'],

          onTab: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Loginpage()),
            );
          },
        );

        // ShowDialog(
        //   context: context,
        // ).showSucessStateDialog(body: response['message']);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const Loginpage()),
        // );
      } else {
        ShowDialog(
          context: context,
        ).showErrorStateDialog(body: response['message']);
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
        'Set Your Password',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      leadingWidget: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      colors: const Color(0xff004E64),
      bodyColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.r,
                      offset: Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 1.w),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 100.w,
                    height: 100.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Set Your Password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              CustomTextfield(
                controller: newPasswordController,
                hint: 'Enter Your New Password',
                label: 'New Password',
                isPassword: true,
                validator: Validation.passwordValidation,
                prefixIcon: const Icon(Icons.lock),
              ),
              const SizedBox(height: 15),

              CustomTextfield(
                controller: confirmPasswordController,
                hint: 'Confirm Your Password',
                label: 'Confirm Password',
                isPassword: true,
                validator: Validation.passwordValidation,
                prefixIcon: const Icon(Icons.lock),
              ),
              const SizedBox(height: 20),

              CustomButton(
                text: 'Set Password',
                onPressed: () => handleSetPassword(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
