import 'dart:async';
import 'package:attendance_system/api_services/checkin_api_services.dart';
import 'package:attendance_system/constant/custom_app_padding.dart';
import 'package:attendance_system/core/common/custom_base_page.dart';
import 'package:attendance_system/core/common/custom_button.dart';
import 'package:attendance_system/core/common/custom_error_success_box.dart';
import 'package:attendance_system/feature/common/attendance_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final GlobalKey<AttendanceTableState> tableKey =
      GlobalKey<AttendanceTableState>();

  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();

    // Update time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Clean up the timer
    super.dispose();
  }

  Future<void> _handleCheckIn(BuildContext context) async {
    final result = await CheckinApiServices.checkinRecord();
    ShowDialog(context: context).showSucessStateDialog(body: result['message']);
    tableKey.currentState?.loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm:ss').format(_now);
    final date = DateFormat('dd MMMM yyyy').format(_now);

    return BasePage(
      title: const Text('Check In', style: TextStyle(color: Colors.white)),
      leadingWidget: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      colors: const Color(0xff004E64),
      bodyColor: Colors.white,
      body: Padding(
        padding: AppPadding.basePagePadding,
        child: Column(
          children: [
            // Time & Date Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.grey, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12.r,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 40.sp,
                    color: const Color(0xff004E64),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 34.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff004E64),
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Prompt Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.grey, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12.r,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.login,
                    size: 32.sp,
                    color: const Color(0xff004E64),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    "Ready to Check In?",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff004E64),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Tap the button below to mark your attendance for today.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),

            // Check In Button
            CustomButton(
              text: 'Check In Now',
              prefixIcon: const Icon(Icons.login, color: Colors.white),
              onPressed: () => _handleCheckIn(context),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
