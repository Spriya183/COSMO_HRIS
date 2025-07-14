import 'package:attendance_system/login/common/menubar.dart';
import 'package:flutter/material.dart';
import 'package:attendance_system/common/base_page.dart';
import 'package:attendance_system/login/common/body_container.dart';
import 'package:attendance_system/login/common/table.dart';
import 'package:attendance_system/api_services/checkin_api_services.dart';
import 'package:attendance_system/api_services/checkout_api_services.dart';
import 'package:attendance_system/login/common/attendance_request_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Attentancepage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(bool) onDrawerChanged;

  const Attentancepage({
    super.key,
    required this.scaffoldKey,
    required this.onDrawerChanged,
  });

  @override
  State<Attentancepage> createState() => _HomepageState();
}

class _HomepageState extends State<Attentancepage> {
  final GlobalKey<TablepageState> tableKey = GlobalKey<TablepageState>();

  Future<void> _handleCheckIn() async {
    final result = await CheckinApiServices.checkinRecord();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['status'] ? Colors.green : Colors.red,
      ),
    );

    //  Refresh the table after check-in
    tableKey.currentState?.loadRecords();
  }

  Future<void> _handleCheckout() async {
    final result = await CheckoutApiServices.checkoutRecord();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['status'] ? Colors.green : Colors.red,
      ),
    );

    //  Refresh the table after check-out
    tableKey.currentState?.loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      scaffoldKey: widget.scaffoldKey,
      onDrawerChanged: widget.onDrawerChanged,
      title: const Text('Attendance', style: TextStyle(color: Colors.white)),
      showBackButton: false,
      centerTitle: true,
      drawer: const MenubarDrawer(),
      leadingWidget: Builder(
        builder:
            (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
      ),
      colors: const Color(0xff004E64),
      bodyColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(25.r),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30.h),
              Row(
                children: [
                  Expanded(
                    child: InnerContainer(
                      title: 'Check In',
                      titlecolor: Colors.black,
                      borderColor: Colors.grey,
                      backgroundColor: Colors.cyan,
                      buttonTextColor: Colors.white,
                      onPressed: _handleCheckIn,
                    ),
                  ),
                  SizedBox(width: 10.h),
                  Expanded(
                    child: InnerContainer(
                      title: 'Check Out',
                      titlecolor: Colors.black,
                      borderColor: Colors.grey,
                      backgroundColor: Colors.redAccent,
                      buttonTextColor: Colors.white,
                      onPressed: _handleCheckout,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              InnerContainer(
                title: 'Attendance Request',
                titlecolor: Colors.black,
                borderColor: Colors.grey,
                backgroundColor: Colors.green,
                buttonTextColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestAttendancePage(),
                    ),
                  );
                },
              ),
              SizedBox(height: 50.h),

              // ✅ Use GlobalKey here to refresh table dynamically
              Tablepage(key: tableKey),

              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }
}
