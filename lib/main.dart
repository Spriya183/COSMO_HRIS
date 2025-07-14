import 'package:attendance_system/login/login_page.dart';
import 'package:attendance_system/login/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_system/common/connection_status_handler.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(ConnectionStatusHandler(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: [routeObserver],
          title: "Cosmo HRIS",
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
              iconTheme: IconThemeData(color: Colors.black),
            ),
            scaffoldBackgroundColor: Colors.white,
          ),
          home: Loginpage(),
        );
      },
    );
  }
}
