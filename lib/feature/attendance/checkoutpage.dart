import 'dart:async';

import 'package:attendance_system/api_services/checkout_api_services.dart';
import 'package:attendance_system/constant/custom_app_padding.dart';
import 'package:attendance_system/core/common/custom_base_page.dart';
import 'package:attendance_system/core/common/custom_button.dart';
import 'package:attendance_system/core/common/custom_error_success_box.dart';
import 'package:attendance_system/feature/common/attendance_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
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

  Future<void> _handleCheckout(BuildContext context) async {
    final result = await CheckoutApiServices.checkoutRecord();
    ShowDialog(context: context).showSucessStateDialog(body: result['message']);
    tableKey.currentState?.loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm:ss').format(_now);
    final date = DateFormat('dd MMMM yyyy').format(_now);

    return BasePage(
      title: const Text('Check Out', style: TextStyle(color: Colors.white)),
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
            // Time & Date Container
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
              child: Column(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 36.sp,
                    color: const Color(0xff004E64),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff004E64),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    date,
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Check-out Prompt Container
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
              child: Column(
                children: [
                  Icon(
                    Icons.logout,
                    size: 28.sp,
                    color: const Color(0xff004E64),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Ready to Check Out?",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff004E64),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "Tap the button below to mark your attendance for today.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),

            CustomButton(
              text: 'Check Out Now',
              prefixIcon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => _handleCheckout(context),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
