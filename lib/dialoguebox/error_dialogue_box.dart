import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertBoxConnection extends StatelessWidget {
  const AlertBoxConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      icon: Icon(Icons.warning_rounded, color: Colors.amber, size: 0.2.sw),
      title: Text(
        "Connection Error",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
      ),
      content: Text(
        "Could not connect to the server at this moment. Please check your network and try again.",
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        textAlign: TextAlign.justify,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Column(
            children: [
              Center(
                child: Text(
                  "OK",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
