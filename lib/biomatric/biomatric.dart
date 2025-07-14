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
    _checkAndAutoLogin();
  }

  Future<void> _checkAndAutoLogin() async {
    biometricEnabled =
        (await _secureStorage.read(key: 'biometric_enabled')) == 'true';
    setState(() {});

    if (biometricEnabled) {
      _authenticateWithBiometrics();
    }
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Stored credentials not found")),
          );
        }
      }
    } catch (e) {
      print("Biometric error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!biometricEnabled) return const SizedBox.shrink();

    return GestureDetector(
      onTap: _authenticateWithBiometrics,
      child: Container(
        height: 50.h,
        width: 50.w,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Icon(
          Icons.fingerprint,
          color: const Color(0xff004E64),
          size: 0.1.sw,
        ),
      ),
    );
  }
}
