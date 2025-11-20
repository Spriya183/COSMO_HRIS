import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final int? maxLines;
  final Widget? prefixIcon;

  final EdgeInsets? customPadding;
  final TextAlignVertical? customTextAlignVertical;

  const CustomTextfield({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.maxLines,
    this.isPassword = false,
    this.prefixIcon,
    this.customPadding,
    this.customTextAlignVertical,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextfield> {
  bool _showpassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType ?? TextInputType.text,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.isPassword ? _showpassword : false,
      maxLines: widget.maxLines ?? 1,
      textAlignVertical:
          widget.customTextAlignVertical ?? TextAlignVertical.center,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        contentPadding:
            widget.customPadding ??
            const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: widget.prefixIcon,
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    _showpassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _showpassword = !_showpassword;
                    });
                  },
                )
                : null,
      ),
    );
  }
}
