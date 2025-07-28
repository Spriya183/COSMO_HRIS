import 'package:attendance_system/feature/attendance/attendance_page.dart';
import 'package:attendance_system/feature/dashboard/dashboard.dart';
import 'package:attendance_system/feature/profile/profile.dart';
import 'package:attendance_system/feature/setting/settingpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  bool _isDrawerOpen = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return true;
  }

  void _handleDrawerChanged(bool isOpen) {
    setState(() {
      _isDrawerOpen = isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      Dashboard(
        scaffoldKey: _scaffoldKey,
        onDrawerChanged: _handleDrawerChanged,
      ),
      Attentancepage(
        scaffoldKey: _scaffoldKey,
        onDrawerChanged: _handleDrawerChanged,
      ),

      // ProfilePage(
      //   scaffoldKey: _scaffoldKey,
      //   onDrawerChanged: _handleDrawerChanged,
      // ),
      SettingsPage(
        scaffoldKey: _scaffoldKey,
        onDrawerChanged: _handleDrawerChanged,
      ),
    ];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar:
            _isDrawerOpen
                ? null
                : Container(
                  margin: EdgeInsets.all(12.r),
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 12.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.3),
                        spreadRadius: 3.r,
                        blurRadius: 8.r,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                    selectedItemColor: const Color(0xff004E64),
                    unselectedItemColor: Colors.grey,
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.dashboard),
                        label: 'Dashboard',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.check_circle_outline),
                        label: 'Attendance',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'Setting',
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
