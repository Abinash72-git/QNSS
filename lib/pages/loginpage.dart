import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soapy/pages/verifyOtp.dart';
import 'package:soapy/provider/UserProvider.dart';
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
  final GlobalKey<PhonetextfeildState> phoneFieldKey =
      GlobalKey<PhonetextfeildState>();
  final TextEditingController mobileController = TextEditingController();
  bool _isLoading = false;
  UserProvider get provider => context.read<UserProvider>();

  @override
  void initState() {
    super.initState();
    mobileController.addListener(() {
      if (!mounted) return;
      final phoneState = phoneFieldKey.currentState;
      if (phoneState != null) {
        final requiredLength = phoneState.phoneMaxLength;
        if (mobileController.text.length == requiredLength) {
          FocusScope.of(context).unfocus();
        }
      }
    });
  }

  Future<void> saveMobileNumber(String number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.USERMOBILE, number);
  }

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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
                  "assets/icons/Qnss-final-2.png",
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

                      try {
                        // Get just the plain number without country code
                        final plainNumber = mobileController.text;
                        final fullNumber = phoneFieldState.getFullPhoneNumber();

                        print("Plain number for API: $plainNumber");
                        print("Full number for storage: $fullNumber");

                        // Save the full number with country code
                        await saveMobileNumber(fullNumber);

                        // Call API with just the plain number
                        final result = await provider.login(
                          UserMobile: plainNumber,
                        );

                        if (!mounted) return;

                        if (result.status) {
                          // OTP sent successfully
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (route) => Verifyotp()),
                          );
                        } else {
                          // Show error message from API
                          String errorMsg = "Failed to send OTP";
                          if (result.data != null &&
                              result.data["message"] != null) {
                            errorMsg = result.data["message"];
                          }
                          showErrorToast(errorMsg);
                        }
                      } catch (e) {
                        print("Error sending OTP: $e");
                        showErrorToast("Network error. Please try again.");
                      } finally {
                        if (mounted) {
                          setState(() => _isLoading = false);
                        }
                      }
                    } else {
                      // Show toast for invalid number
                      showErrorToast(
                        "Please enter a valid $requiredLength-digit mobile number",
                      );
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
