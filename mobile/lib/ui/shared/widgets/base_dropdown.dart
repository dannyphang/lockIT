import 'package:flutter/material.dart';

class BaseDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items; // plain strings
  final ValueChanged<String?> onChanged;
  final bool isRequired;
  final bool disable;

  const BaseDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isRequired = false,
    this.disable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item.toUpperCase()),
              ),
            )
            .toList(),
        onChanged: disable ? null : onChanged, // 👈 disable dropdown
        validator: (val) {
          if (isRequired && (val == null || val.isEmpty)) {
            return '$label is required';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
