import 'package:flutter/material.dart';
import 'package:kids_republik/utils/const.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.enabled,
    required this.labelText,
    required this.controller,
    required this.inputType,
    this.validators,
    this.onChanged,
  }) : super(key: key);

  final bool? enabled;
  final String labelText;
  final TextEditingController controller;
  final TextInputType inputType;
  final Function(String)? validators;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled ?? true,
      controller: controller,
      keyboardType: inputType,
      onChanged: onChanged,
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.85),
        fontSize: 16.0, // Set your desired font size
      ),
      decoration: InputDecoration(
        isDense: true,
        labelText: labelText,

        // floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: kLabelStyle.copyWith(
          color:
              Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.9),
        ),
        hintStyle: kLabelStyle.copyWith(
          fontSize: 16,
          color:
              Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.7),
        ),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!, width: 0.8),
        ),
      ),
      validator: validators as String? Function(String?)?,
    );
  }
}
