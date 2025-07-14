import 'package:attendance_system/biomatric/biomatric.dart';
import 'package:attendance_system/core/common/custom_button.dart';
import 'package:attendance_system/core/common/custom_form_field.dart';
import 'package:attendance_system/core/common/custom_validation.dart';
import 'package:attendance_system/feature/common/buttom_nav_bar.dart';
import 'package:attendance_system/feature/forget_password/forget_password_ui.dart';
import 'package:attendance_system/feature/quick_attendance/quick_attendance.dart';
import 'package:flutter/material.dart';
import 'package:attendance_system/api_services/login_api_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool alreadyEnabled = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
    checkBiometricStatus();
  }

  Future<void> checkBiometricStatus() async {
    final storage = FlutterSecureStorage();
    final isEnabled = await storage.read(key: 'biometric_enabled');
    setState(() {
      alreadyEnabled = isEnabled == 'true';
    });
  }

  void biometricAutoLogin(String username, String password) {
    setState(() {
      emailController.text = username;
      passwordController.text = password;
    });
    handleLogin();
  }

  Future<void> handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      // _askToEnableBiometric(emailController.text, passwordController.text);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final response = await LoginApiService.authenticateEmployee(
          email,
          password,
        );

        Navigator.pop(context);

        if (response['code'] == 200) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response['message'])));

          await _askToEnableBiometric(email, password);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response['message'])));
        }
      } catch (e) {
        Navigator.pop(context); // close loading dialog if error
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  //biomatric
  Future<void> _askToEnableBiometric(String username, String password) async {
    final _secureStorage = const FlutterSecureStorage();

    final alreadyEnabled =
        await _secureStorage.read(key: 'biometric_enabled') == 'true';
    if (alreadyEnabled) return;

    bool? enable = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Enable Biometric Login"),
            content: const Text(
              "Would you like to enable biometric login for faster sign-in next time?",
            ),
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
        localizedReason: 'Scan your fingerprint to enable biometric login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        await _secureStorage.write(key: 'biometric_enabled', value: 'true');
        await _secureStorage.write(key: 'username', value: username);
        await _secureStorage.write(key: 'password', value: password);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Biometric login enabled")),
        );
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

                  SizedBox(height: 15.h),

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
                    height: 480.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 25.w,
                      vertical: 20.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                    ),

                    //form
                    child: Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Log In',
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
                            validator: Validation.validUserName,
                            prefixIcon: const Icon(Icons.email),
                          ),
                          SizedBox(height: 20.h),
                          CustomTextfield(
                            controller: passwordController,
                            hint: 'Enter Your Password',
                            label: 'Password',
                            isPassword: true,
                            validator: Validation.passwordValidation,
                            prefixIcon: const Icon(Icons.lock),
                          ),
                          SizedBox(height: 10.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ForgotPasswordPage(),
                                    ),
                                  );
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
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                width: 270.w,
                                text: 'LOG IN',
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    handleLogin();
                                  }
                                },
                              ),

                              BiometricLoginScreen(onLogin: biometricAutoLogin),
                            ],
                          ),
                          SizedBox(height: 15.h),

                          CustomButton(
                            backgroundColor: Colors.white,
                            borderColor: const Color(0xff004E64),
                            textColor: Color(0xff004E64),
                            text: 'Quick Attendance',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const QuickAttendance(),
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
