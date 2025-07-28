import 'package:attendance_system/feature/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Loginpage()),
      ); // Change route as needed
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context); // If using screen_util

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004E64), Color(0xFF60A3BC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo or Icon
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
            SizedBox(height: 20.h),
            // App Title
            Text(
              "COSMO HRIS",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "Your Time, Our Priority.",
              style: TextStyle(fontSize: 14.sp, color: Colors.white70),
            ),
            SizedBox(height: 30.h),
            // Loading Indicator
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
