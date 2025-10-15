import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Phonetextfeild extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Color borderColor;
  final Color fillColor;
  final double borderRadius;
  final int? maxLength;
  final String? Function(String?)? validator;
  final Color errorTextColor;
  final bool isPhoneField;
  final String? initialCountryCode;

  const Phonetextfeild({
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
    this.validator,
    this.isPhoneField = false,
    this.initialCountryCode,
  }) : super(key: key);

  @override
  PhonetextfeildState createState() => PhonetextfeildState();
}

class PhonetextfeildState extends State<Phonetextfeild> {
  String selectedCountry = 'ID'; // Default to Indonesia
  int phoneMaxLength = 15; // General max length

  // Map of country codes without strict length requirements
  final Map<String, Map<String, dynamic>> countryData = {
    'SG': {'code': '+65', 'flag': '🇸🇬'},
    'ID': {'code': '+62', 'flag': '🇮🇩'},
    // Add more countries as needed
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialCountryCode != null &&
        countryData.containsKey(widget.initialCountryCode)) {
      selectedCountry = widget.initialCountryCode!;
    }
  }

  void _updateCountry(String country) {
    setState(() {
      selectedCountry = country;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (!widget.isPhoneField) {
      // Return regular text field if not a phone field
      return _buildRegularTextField(size);
    }

    // Return unified phone field with country code in a single container
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: widget.fillColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: widget.borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius - 1),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Country code dropdown
              Material(
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.only(right: 8),
                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${countryData[selectedCountry]!['flag']}",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "${countryData[selectedCountry]!['code']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    onSelected: _updateCountry,
                    itemBuilder: (context) {
                      return countryData.keys.map((String country) {
                        return PopupMenuItem<String>(
                          value: country,
                          child: Row(
                            children: [
                              Text("${countryData[country]!['flag']} "),
                              Text("${countryData[country]!['code']} ($country)"),
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
              
              // Vertical divider
              Container(
                width: 1,
                color: Colors.grey.withOpacity(0.2),
                margin: EdgeInsets.symmetric(vertical: 8),
              ),
              
              // Phone number field
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.left,
                  maxLength: phoneMaxLength,
                  validator: widget.validator ?? _defaultPhoneValidator,
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(phoneMaxLength),
                  ],
                  decoration: InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    hintText: widget.hintText.isNotEmpty
                        ? '${widget.hintText}'
                        : 'Phone Number',
                    hintStyle: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                    errorStyle: TextStyle(
                      color: widget.errorTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Other methods (build regular text field, etc.)
  
  // Modified validator without strict length requirement
  String? _defaultPhoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // No length validation - just checking if it's not empty
    return null;
  }

  // Get the full phone number (with country code)
  String getFullPhoneNumber() {
    return "${countryData[selectedCountry]!['code']}${widget.controller.text}";
  }

  // Get just the country code
  String getCountryCode() {
    return countryData[selectedCountry]!['code'];
  }



  Widget _buildRegularTextField(Size size) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      textAlign: TextAlign.center,
      maxLength: widget.maxLength,
      validator: widget.validator,
      style: TextStyle(
        fontSize: size.width * 0.05,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      inputFormatters: [
        if (widget.keyboardType == TextInputType.number ||
            widget.keyboardType == TextInputType.phone)
          FilteringTextInputFormatter.digitsOnly,
        if (widget.maxLength != null)
          LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      decoration: InputDecoration(
        counterText: '',
        filled: true,
        fillColor: widget.fillColor,
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor, width: 2),
        ),
        errorStyle: TextStyle(
          color: widget.errorTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      
      ),
    );
  }

  // // Default phone validator
  // String? _defaultPhoneValidator(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Phone number is required';
  //   }
  //   if (value.length != phoneMaxLength) {
  //     return 'Phone number must be $phoneMaxLength digits for ${selectedCountry}';
  //   }
  //   return null;
  // }

  // // Get the full phone number (with country code)
  // String getFullPhoneNumber() {
  //   return "${countryData[selectedCountry]!['code']}${widget.controller.text}";
  // }

  // // Get just the country code
  // String getCountryCode() {
  //   return countryData[selectedCountry]!['code'];
  // }
}
