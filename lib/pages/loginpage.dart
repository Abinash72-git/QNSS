import 'package:flutter/material.dart';
import 'package:soapy/pages/verifyOtp.dart';
import 'package:soapy/util/appconstant.dart';
import 'package:soapy/util/button.dart';
import 'package:soapy/util/colors.dart';
import 'package:soapy/util/phonetextfeild.dart';
import 'package:soapy/util/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  // Specify the correct type for the GlobalKey
  final GlobalKey<PhonetextfeildState> phoneFieldKey =
      GlobalKey<PhonetextfeildState>();
  final TextEditingController mobileController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add listener to close keyboard when max digits are entered
    mobileController.addListener(() {
      if (!mounted) return;

      // Get the current required length from the phone field
      final phoneState = phoneFieldKey.currentState;
      if (phoneState != null) {
        final requiredLength = phoneState.phoneMaxLength;
        if (mobileController.text.length == requiredLength) {
          FocusScope.of(context).unfocus(); // Close keyboard
        }
      }
    });
  }

  Future<void> saveMobileNumber(String number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.USERMOBILE, number);
  }

  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Qnss-bg2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.1),
                Image.asset(
                  "assets/icons/Qnss-new_icon.png",
                  width: 350,
                  height: 180,
                ),
                Text(
                  "Let's get your",
                  style: Styles.textStyleLogin(
                    context,
                    color: AppColor.loginText,
                  ),
                  textScaler: TextScaler.linear(1),
                ),
                const SizedBox(height: 10),
                Text(
                  "Mobile Verified",
                  style: Styles.textStyleLogin(
                    context,
                    color: AppColor.loginText,
                  ),
                  textScaler: TextScaler.linear(1),
                ),
                SizedBox(height: size.height * 0.05),
                Text(
                  "Please Enter Your",
                  style: Styles.textStyleSmall(
                    context,
                    color: AppColor.whiteColor,
                  ),
                  textScaler: TextScaler.linear(1),
                ),
                Text(
                  "Register Mobile Number to begin...",
                  style: Styles.textStyleSmall(
                    context,
                    color: AppColor.whiteColor,
                  ),
                  textScaler: TextScaler.linear(1),
                ),
                SizedBox(height: size.height * 0.02),

                // Phone text field implementation with correct key
                Phonetextfeild(
                  key: phoneFieldKey,
                  controller: mobileController,
                  hintText: 'Mobile Number',
                  isPhoneField: true,
                  initialCountryCode: 'IN', // Default to India
                  borderColor: AppColor.whiteColor,
                  fillColor: AppColor.whiteColor,
                  errorTextColor: Colors.red,
                ),

                SizedBox(height: size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't worry ! Your details are safe us.",
                      style: Styles.textStyleSmall2(
                        context,
                        color: AppColor.loginText,
                      ),
                      textScaler: TextScaler.linear(1),
                    ),
                    Image.asset(
                      "assets/icons/security.png",
                      width: size.width * 0.04,
                      height: size.height * 0.04,
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                MyButton(
                  text: "GET OTP",
                  color: AppColor.loginButton,
                  isLoading: _isLoading,
                  onPressed: () async {
                    if (_isLoading) return;

                    // Get the phone field state
                    final phoneFieldState = phoneFieldKey.currentState;
                    if (phoneFieldState == null) {
                      print("Could not access phone field state");
                      return;
                    }

                    // Get the current phone length requirement
                    final requiredLength = phoneFieldState.phoneMaxLength;

                    // Validate phone number
                    if (mobileController.text.length == requiredLength) {
                      setState(() => _isLoading = true);

                      // Get full number with country code
                      final fullNumber = phoneFieldState.getFullPhoneNumber();
                      print("Full phone number: $fullNumber");

                      // Save the mobile number with country code
                      await saveMobileNumber(fullNumber);

                      // Simulate network delay
                      await Future.delayed(const Duration(seconds: 2));

                      // Navigate to OTP page
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (route) => Verifyotp()),
                      );
                      setState(() => _isLoading = false);
                    } else {
                      // Show toast for invalid number
                      try {
                        Fluttertoast.showToast(
                          msg:
                              "Please enter a valid $requiredLength-digit mobile number",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 14.0,
                        );
                      } catch (e) {
                        // Fallback if Fluttertoast fails
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text(
                        //       "Please enter a valid $requiredLength-digit mobile number"
                        //     ),
                        //     backgroundColor: Colors.red,
                        //   ),
                        // );
                        Fluttertoast.showToast(
                          msg:
                              "Please enter a valid $requiredLength-digit mobile number",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
