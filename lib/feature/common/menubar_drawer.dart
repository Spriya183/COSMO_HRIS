// menubar_drawer

import 'package:attendance_system/core/common/custom_error_success_box.dart';
import 'package:attendance_system/feature/logout/custom_logout_dialogue_box.dart';
import 'package:attendance_system/feature/common/buttom_nav_bar.dart';
import 'package:attendance_system/feature/dashboard/dashboard.dart';
import 'package:attendance_system/feature/leave_request/leave_request_page.dart';
import 'package:attendance_system/feature/login/login_page.dart';
import 'package:attendance_system/feature/report/report_page.dart';
import 'package:attendance_system/feature/setting/settingpage.dart';
import 'package:flutter/material.dart';
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
        Future.delayed(Duration(microseconds: 100), () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Loginpage()),
            (route) => false,
          );
        });

        // ShowDialog(
        //   context: context,
        // ).showSucessStateDialog(body: result['message']);

        // // Navigate to login page and clear previous routes
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => const Loginpage()),
        //   (route) => false,
        // );
      } else {
        // Show failure message
        ShowDialog(
          context: context,
        ).showErrorStateDialog(body: result['message']);
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
          Text(
            'Cosmo Hris',
            style: TextStyle(
              color: Color(0xff004E64),
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.grey, thickness: 0.5),

          ListTile(
            leading: const Icon(Icons.assignment_add, color: Color(0xff004E64)),
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
            leading: const Icon(Icons.history, color: Color(0xff004E64)),
            title: const Text('All records'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AttendanceReportPage(),
                ),
              );
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.settings, color: Color(0xff004E64)),
          //   title: const Text('Settings'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => SettingsPage(

          //       )),
          //     );
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xff004E64)),
            title: const Text('Logout'),
            onTap: () async {
              final shouldLogout = await showLogoutDialog(context);

              if (shouldLogout == true) {
                await _handleLogout(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
