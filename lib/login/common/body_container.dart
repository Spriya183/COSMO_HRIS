import 'package:flutter/material.dart';

class InnerContainer extends StatelessWidget {
  final String title;
  final Color titlecolor;
  final Color borderColor;
  final Color backgroundColor;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color buttonTextColor;

  const InnerContainer({
    super.key,
    required this.title,
    required this.titlecolor,
    required this.borderColor,
    required this.backgroundColor,
    this.icon,
    required this.onPressed,
    required this.buttonTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor, width: 0.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: titlecolor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onPressed,
              child: Text(
                title,
                style: TextStyle(fontSize: 16, color: buttonTextColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
