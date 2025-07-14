// menubar_drawer
import 'package:attendance_system/login/add_leave_request_page.dart';
import 'package:attendance_system/login/attendance_page.dart';
import 'package:attendance_system/login/common/buttom_nav_bar.dart';
import 'package:attendance_system/login/report_page.dart';
import 'package:flutter/material.dart';
import 'package:attendance_system/login/login_page.dart';
import 'package:attendance_system/api_services/logout_api_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenubarDrawer extends StatelessWidget {
  const MenubarDrawer({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await LogoutApiService.employeeLogout();
      Navigator.pop(context); // Dismiss loading dialog

      if (result['code'] == 200) {
        // Show success message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));

        // Navigate to login page and clear previous routes
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Loginpage()),
          (route) => false,
        );
      } else {
        // Show failure message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    } catch (e) {
      Navigator.pop(context); // Ensure dialog is dismissed on error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(top: 40.h, left: 20.w),
        children: [
          Center(
            child: Text(
              'Cosmo Hris',
              style: TextStyle(
                color: Color(0xff004E64),
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(color: Colors.grey, thickness: 0.5),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Color(0xff004E64)),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time, color: Color(0xff004E64)),
            title: const Text('Attendance'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BottomNavBar()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.request_page, color: Color(0xff004E64)),
            title: const Text('Leave Request'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LeaveRequestPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.report, color: Color(0xff004E64)),
            title: const Text('Reports'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AttendanceReportPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xff004E64)),
            title: const Text('Logout'),
            onTap: () async {
              await _handleLogout(context);
            },
          ),
        ],
      ),
    );
  }
}
