import 'package:attendance_system/biomatric/biomatric.dart';
import 'package:attendance_system/core/common/custom_button.dart';
import 'package:attendance_system/core/common/custom_dropdown.dart';
import 'package:attendance_system/core/common/custom_error_success_box.dart';
import 'package:attendance_system/core/common/custom_form_field.dart';
import 'package:attendance_system/core/common/custom_validation.dart';
import 'package:attendance_system/feature/login/login_page.dart';
import 'package:attendance_system/api_services/quick_attendance_api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

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

  bool alreadyEnabled = false;

  @override
  void initState() {
    super.initState();
    checkBiometricStatus();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> checkBiometricStatus() async {
    final storage = FlutterSecureStorage();
    final isEnabled = await storage.read(key: 'biometric_enabled');
    setState(() {
      alreadyEnabled = isEnabled == 'true';
    });
  }

  void biometricAutoLogin(String username, String password) async {
    String? action = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            titlePadding: EdgeInsets.fromLTRB(24.r, 24.r, 24.r, 0),
            contentPadding: EdgeInsets.fromLTRB(24.r, 12.r, 24.r, 0),
            actionsPadding: EdgeInsets.only(right: 16.r, bottom: 12.r),
            title: const Text(
              "Choose Action",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xff004E64),
              ),
            ),
            content: const Text(
              "Please select Check In or Check Out.",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context, 'Check In'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                ),
                child: const Text(
                  "Check In",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, 'Check Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                ),
                child: const Text(
                  "Check Out",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    if (action != null) {
      setState(() {
        emailController.text = username;
        passwordController.text = password;
        selectedOption = action;
      });

      HandlequickAttendance();
    }
  }

  Future<void> _askToEnableBiometric(String username, String password) async {
    final _secureStorage = const FlutterSecureStorage();
    final alreadyEnabled =
        await _secureStorage.read(key: 'biometric_enabled') == 'true';
    if (alreadyEnabled) return;

    bool? enable = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Enable Biometric QuickAttendance"),
            content: const Text(
              "Would you like to enable biometric login for faster sign-in next time?",
            ),
            actionsAlignment: MainAxisAlignment.start,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Yes"),
              ),
            ],
          ),
    );

    if (enable == true) {
      final auth = LocalAuthentication();
      final didAuthenticate = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint to enable biometric for Quick Attendance',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        await _secureStorage.write(key: 'biometric_enabled', value: 'true');
        await _secureStorage.write(key: 'username', value: username);
        await _secureStorage.write(key: 'password', value: password);

        ShowDialog(
          context: context,
        ).showSucessStateDialog(body: 'Biometric QuickAttendance enabled');
      }
    }
  }

  Future<void> HandlequickAttendance() async {
    if (_formKey.currentState!.validate()) {
      if (selectedOption.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Check In or Check Out')),
        );
        return;
      }

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
          ShowDialog(
            context: context,
          ).showSucessStateDialog(body: response['message']);
          await _askToEnableBiometric(email, password);
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(height: 80.h),
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
                    SizedBox(height: 15.h),
                    Text(
                      'COSMO HRIS',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Expanded(
                      child: Container(
                        width: double.infinity,
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
                                label: 'Select Options',
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value ?? '';
                                  });
                                },
                              ),
                              SizedBox(height: 15.h),
                              CustomButton(
                                text: 'Quick Attendance',
                                onPressed: HandlequickAttendance,
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
                                      builder: (_) => const Loginpage(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 10.h),
                              BiometricLoginScreen(onLogin: biometricAutoLogin),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
