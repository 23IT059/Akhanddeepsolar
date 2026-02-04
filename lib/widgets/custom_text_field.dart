import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.icon,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, color: Colors.orange) : null,
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.orange, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
