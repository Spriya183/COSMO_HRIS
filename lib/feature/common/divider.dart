import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HorizontalDividerWithText extends StatelessWidget {
  final String text;
  final Color dividerColor;
  final Color textColor;

  const HorizontalDividerWithText({
    super.key,
    this.text = 'or',
    this.dividerColor = Colors.grey,
    this.textColor = Colors.black54,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 14.sp),
          ),
        ),
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
      ],
    );
  }
}
