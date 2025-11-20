import 'package:attendance_system/core/common/custom_button.dart';
import 'package:attendance_system/core/common/custom_error_success_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricLoginScreen extends StatefulWidget {
  final Function(String username, String password) onLogin;

  const BiometricLoginScreen({super.key, required this.onLogin});

  @override
  _BiometricLoginScreenState createState() => _BiometricLoginScreenState();
}

class _BiometricLoginScreenState extends State<BiometricLoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  final _secureStorage = const FlutterSecureStorage();

  bool biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricStatus(); // ✅ Just check, don’t authenticate here
  }

  Future<void> _checkBiometricStatus() async {
    final isEnabled = await _secureStorage.read(key: 'biometric_enabled');
    setState(() {
      biometricEnabled = isEnabled == 'true';
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      final didAuthenticate = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        final username = await _secureStorage.read(key: 'username');
        final password = await _secureStorage.read(key: 'password');

        if (username != null && password != null) {
          widget.onLogin(username, password);
        } else {
          ShowDialog(
            context: context,
          ).showErrorStateDialog(body: 'Stored credentials not found');
        }
      }
    } catch (e) {
      print("Biometric error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!biometricEnabled) return const SizedBox.shrink();

    // Hide if not enabled
    return CustomButton(
      text: "Tap to Login with Biometric",
      textColor: Color(0xff004E64),
      onPressed: _authenticateWithBiometrics,
      backgroundColor: Colors.white,
      borderColor: Color(0xff004E64),
      prefixIcon: Icon(Icons.fingerprint),
      iconColor: Color(0xff004E64),
    );
    // return GestureDetector(
    //   onTap: _authenticateWithBiometrics, // Only when tapped
    //   child: Column(
    //     children: [
    //       Container(
    //         decoration: BoxDecoration(
    //           border: Border.all(color: Color(0xff004E64), width: 1.0),
    //           borderRadius: BorderRadius.circular(20),
    //         ),

    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Icon(
    //               Icons.fingerprint,
    //               color: const Color(0xff004E64),
    //               size: 40.sp,
    //             ),
    //             SizedBox(width: 10.w),
    //             Text(
    //               "Tap to Login with Biometric",
    //               style: TextStyle(
    //                 fontSize: 14.sp,
    //                 color: const Color(0xff004E64),
    //                 fontWeight: FontWeight.w600,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
