import 'package:attendance_system/api_services/employee_authentication_api_services.dart';
import 'package:attendance_system/core/common/custom_error_success_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricDisable extends StatefulWidget {
  final VoidCallback onDisabled;

  const BiometricDisable({super.key, required this.onDisabled});

  @override
  State<BiometricDisable> createState() => _BiometricDisableState();
}

class _BiometricDisableState extends State<BiometricDisable> {
  String? email;

  @override
  void initState() {
    super.initState();
    _fetchEmployeeEmail();
  }

  Future<void> _fetchEmployeeEmail() async {
    final authResponse =
        await EmployeeAuthenticationApiServices.authenticateEmployee();

    if (authResponse != null && authResponse.data != null) {
      setState(() {
        email = authResponse.data!.email;
      });
    }
  }

  Future<void> _disableBiometric(BuildContext context) async {
    const storage = FlutterSecureStorage();

    // Delete biometric keys
    await storage.delete(key: 'biometric_enabled');
    await storage.delete(key: 'username');
    await storage.delete(key: 'password');

    // Show success dialog
    ShowDialog(
      context: context,
    ).showSucessStateDialog(body: "Biometric Disabled Successfully");

    // Callback to parent
    widget.onDisabled();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.fingerprint, color: Color(0xff004E64), size: 30),
              const SizedBox(height: 10),
              const Text(
                'Biometric Login Enabled',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff004E64),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Logged in as: ${email ?? ''}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => _disableBiometric(context),
                child: const Text(
                  'Disable Biometric Login',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
