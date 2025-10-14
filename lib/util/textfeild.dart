import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Color borderColor; // customizable border color
  final Color fillColor; // customizable background color
  final double borderRadius;
  final int? maxLength;
  final String? Function(String?)? validator; // optional validator
  final Color errorTextColor;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.borderColor = Colors.black,
    this.fillColor = Colors.white,
    this.borderRadius = 25,
    this.maxLength,
    this.errorTextColor = Colors.white,
    this.validator, // optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textAlign: TextAlign.center,
      maxLength: maxLength,
      validator: validator, // use it here
      style: TextStyle(
        fontSize: size.width * 0.05,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      inputFormatters: [
        if (keyboardType == TextInputType.number ||
            keyboardType == TextInputType.phone)
          FilteringTextInputFormatter.digitsOnly,
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
      ],
      decoration: InputDecoration(
        counterText: '',
        filled: true,
        fillColor: fillColor,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black, fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        errorStyle: TextStyle(
          color: errorTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
