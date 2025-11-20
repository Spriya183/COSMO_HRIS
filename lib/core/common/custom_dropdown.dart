import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final List<String> items;
  final String label;

  const CustomDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.items,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue?.isNotEmpty == true ? selectedValue : null,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: [
        for (var item in items)
          DropdownMenuItem(value: item, child: Text(item)),
      ],
    );
  }
}
