import 'package:attendance_system/core/common/custom_button.dart';
import 'package:attendance_system/core/common/custom_dropdown.dart';
import 'package:attendance_system/core/common/custom_error_success_box.dart';
import 'package:attendance_system/core/common/custom_form_field.dart';
import 'package:attendance_system/core/common/custom_validation.dart';
import 'package:attendance_system/feature/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:attendance_system/api_services/quick_attendance_api_services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickAttendance extends StatefulWidget {
  const QuickAttendance({super.key});

  @override
  State<QuickAttendance> createState() => _QuickAttendanceState();
}

class _QuickAttendanceState extends State<QuickAttendance> {
  final _formKey = GlobalKey<FormState>();
  String selectedOption = '';
  final List<String> optionList = ['Check In', 'Check Out'];

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController actionController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> HandlequickAttendance() async {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final action = selectedOption.toUpperCase().replaceAll(' ', '');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      try {
        final response =
            await QuickAttendanceApiServices.quickAttendanceAuthentication(
              email,
              password,
              action,
            );

        Navigator.pop(context);

        if (response['code'] == 200) {
          Future.delayed(Duration(seconds: 2), () {
            ShowDialog(
              context: context,
            ).showSucessStateDialog(body: response['message']);
          });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff004E64),
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 110.h),

                  // Avatar
                  Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.r,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.white, width: 1),
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

                  SizedBox(height: 15.h),

                  // Title text
                  Text(
                    'COSMO HRIS',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 55.h),

                  Container(
                    width: double.infinity,
                    height: 478.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 25.w,
                      vertical: 20.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),

                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fill your details',
                            style: TextStyle(
                              color: Color(0xff004E64),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          CustomTextfield(
                            controller: emailController,
                            hint: 'Enter Your Email',
                            label: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            validator: Validation.validUserName,
                          ),
                          SizedBox(height: 20.h),
                          CustomTextfield(
                            controller: passwordController,
                            hint: 'Enter your password',
                            label: 'Password',
                            isPassword: true,
                            prefixIcon: Icon(Icons.lock),
                            validator: Validation.passwordValidation,
                          ),
                          SizedBox(height: 20.h),

                          CustomDropdown(
                            selectedValue: selectedOption,
                            items: optionList,
                            label: ' Select Options',
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value ?? '';
                              });
                            },
                          ),
                          SizedBox(height: 30.h),

                          CustomButton(
                            text: 'Submit Attendance',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                HandlequickAttendance();
                              }
                            },
                          ),

                          SizedBox(height: 20.h),
                          CustomButton(
                            backgroundColor: Colors.white,
                            borderColor: const Color(0xff004E64),
                            textColor: Color(0xff004E64),
                            text: 'Log In',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Loginpage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
