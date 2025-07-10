import 'package:flutter/material.dart';
import 'package:attendance_system/common/custom_textfield.dart';
import 'package:attendance_system/common/validation.dart';
import 'package:attendance_system/common/custom_dropdown.dart';
import 'package:attendance_system/api_services/quick_attendance_api_services.dart';
import 'package:attendance_system/login/loginpage.dart';

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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response['message'])));
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
                  const SizedBox(height: 110),

                  // Avatar
                  Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
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
                  const Text(
                    'COSMO HRIS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 55),

                  Container(
                    width: double.infinity,
                    height: 478.h,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 20,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),

                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fill your details',
                            style: TextStyle(
                              color: Color(0xff004E64),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomTextfield(
                            controller: emailController,
                            hint: 'Enter Your Email',
                            label: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            validator: Validation.validUserName,
                          ),
                          const SizedBox(height: 20),
                          CustomTextfield(
                            controller: passwordController,
                            hint: 'Enter your password',
                            label: 'Password',
                            isPassword: true,
                            prefixIcon: const Icon(Icons.lock),
                            validator: Validation.passwordValidation,
                          ),
                          const SizedBox(height: 20),

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
                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff004E64),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  HandlequickAttendance();
                                }
                              },
                              child: const Text(
                                'Submit Attendance',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                side: const BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Loginpage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Log In',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
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
