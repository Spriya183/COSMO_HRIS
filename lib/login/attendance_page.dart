import 'package:flutter/material.dart';
import 'package:attendance_system/common/base_page.dart';
import 'package:attendance_system/login/common/body_container.dart';
import 'package:attendance_system/login/common/table.dart';
import 'package:attendance_system/api_services/checkin_api_services.dart';
import 'package:attendance_system/api_services/checkout_api_services.dart';
import 'package:attendance_system/login/common/attendance_request_page.dart';

class Attentancepage extends StatefulWidget {
  const Attentancepage({super.key});

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
      title: const Text('Attendance', style: TextStyle(color: Colors.white)),
      showBackButton: false,
      centerTitle: true,
      colors: const Color(0xff004E64),
      bodyColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
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
                  const SizedBox(width: 10),
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 50),

              // ✅ Use GlobalKey here to refresh table dynamically
              Tablepage(key: tableKey),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
