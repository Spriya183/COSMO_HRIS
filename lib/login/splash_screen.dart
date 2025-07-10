import 'package:flutter/material.dart';
import 'package:attendance_system/api_services/authentication_api_service.dart';
import 'package:attendance_system/login/dashboard.dart';
import 'package:attendance_system/login/loginpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    final result = await AuthenticationApiService.authentication();
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    if (result['status'] == true) {
      // Authenticated, go to Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => Dashboard(
                scaffoldKey: _scaffoldKey,
                onDrawerChanged: (isOpen) {
                  // Handle drawer open/close logic here if needed
                  print("Drawer is ${isOpen ? 'opened' : 'closed'}");
                },
              ),
        ),
      );
    } else {
      // Not Authenticated, go to Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginpage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
