// menubar_drawer
import 'package:attendance_system/login/add_leave_request_page.dart';
import 'package:attendance_system/login/common/buttom_nav_bar.dart';
import 'package:attendance_system/login/report_page.dart';
import 'package:flutter/material.dart';
import 'package:attendance_system/login/loginpage.dart';
import 'package:attendance_system/api_services/logout_api_service.dart';

class MenubarDrawer extends StatelessWidget {
  const MenubarDrawer({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final result = await LogoutApiService.employeeLogout();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result['message'])));
    if (result['status']) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Loginpage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(top: 40, left: 20),
        children: [
          const Center(
            child: Text(
              'Cosmo Hris',
              style: TextStyle(
                color: Color(0xff004E64),
                fontSize: 20,
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
                MaterialPageRoute(builder: (context) => const BottomNavBar()),
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
              Navigator.pop(context);
              await _handleLogout(context);
            },
          ),
        ],
      ),
    );
  }
}
