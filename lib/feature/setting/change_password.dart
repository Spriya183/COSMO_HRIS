import 'package:attendance_system/api_services/change_password_api_service.dart';
import 'package:attendance_system/core/common/custom_base_page.dart';
import 'package:attendance_system/core/common/custom_button.dart';
import 'package:attendance_system/core/common/custom_error_success_box.dart';
import 'package:attendance_system/core/common/custom_form_field.dart';
import 'package:attendance_system/core/common/custom_validation.dart';
import 'package:attendance_system/feature/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> handleChangePassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final currentPassword = currentPasswordController.text.trim();
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
      final response = await ChangePasswordApiService.changePassword(
        currentPassword,
        newPassword,
        confirmPassword,
      );

      Navigator.pop(context);

      if (response['status'] == true) {
        ShowDialog(context: context).showSucessStateDialog(
          body: response['message'],
          onTab: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Loginpage()),
            );
          },
        );
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
        'Change Password',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      colors: const Color(0xff004E64),
      bodyColor: Colors.white,
      leadingWidget: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 100.w,
                    height: 100.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Current Password
              CustomTextfield(
                controller: currentPasswordController,
                hint: 'Enter Current Password',
                label: 'Current Password',
                isPassword: true,
                validator: Validation.passwordValidation,
                prefixIcon: const Icon(Icons.lock),
              ),
              const SizedBox(height: 15),

              /// New Password
              CustomTextfield(
                controller: newPasswordController,
                hint: 'Enter New Password',
                label: 'New Password',
                isPassword: true,
                validator: Validation.passwordValidation,
                prefixIcon: const Icon(Icons.lock_outline),
              ),
              const SizedBox(height: 15),

              /// Confirm Password
              CustomTextfield(
                controller: confirmPasswordController,
                hint: 'Confirm New Password',
                label: 'Confirm Password',
                isPassword: true,
                validator: Validation.passwordValidation,
                prefixIcon: const Icon(Icons.lock_outline),
              ),
              const SizedBox(height: 25),

              /// Submit Button
              CustomButton(
                text: "Change Password",
                onPressed: () => handleChangePassword(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
