import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soapy/pages/homepage.dart';
import 'package:soapy/util/appconstant.dart';
import 'package:soapy/util/button.dart';
import 'package:soapy/util/colors.dart';
import 'package:soapy/util/style.dart';
import 'package:pinput/pinput.dart';

class Verifyotp extends StatefulWidget {
  const Verifyotp({super.key});

  @override
  State<Verifyotp> createState() => _VerifyotpState();
}

class _VerifyotpState extends State<Verifyotp> {
  final TextEditingController otpController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  String? mobileNumber;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getMobileNumber();

    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) focusNode.requestFocus();
    });
  }

  Future<void> getMobileNumber() async {
    final prefs = await SharedPreferences.getInstance();
    String? number = prefs.getString(AppConstants.USERMOBILE);
    setState(() => mobileNumber = number);
  }

  /// ✅ Function to set user as registered
  Future<void> setIsRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.ISREGISTERED, true);
    print("User registration status saved ✅");
  }

  /// Mask the mobile number for privacy
  String maskNumber(String number) {
    if (number.length < 10) return number;
    return number.substring(0, 2) + "*****" + number.substring(7);
  }

  @override
  void dispose() {
    otpController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: TextStyle(
        fontSize: 24,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColor.loginText, width: 2),
      borderRadius: BorderRadius.circular(30),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.white,
        border: Border.all(color: AppColor.loginText),
      ),
    );

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
                Image.asset("assets/icons/Qnss-new_icon.png",
                    width: 350, height: 180),
                Text(
                  "Verifying Your",
                  style: Styles.textStyleLogin(context,
                      color: AppColor.loginText),
                ),
                const SizedBox(height: 10),
                Text(
                  "Code",
                  style: Styles.textStyleLogin(context,
                      color: AppColor.loginText),
                ),
                SizedBox(height: size.height * 0.05),
                Text(
                  "Please type the verification code",
                  style: Styles.textStyleSmall(context,
                      color: AppColor.whiteColor),
                ),
                Text(
                  mobileNumber == null
                      ? "sent to ..."
                      : "sent to ${maskNumber(mobileNumber!)}",
                  style: Styles.textStyleSmall(context,
                      color: AppColor.whiteColor),
                ),
                SizedBox(height: size.height * 0.02),

                // Pinput
                Pinput(
                  controller: otpController,
                  focusNode: focusNode,
                  length: 4,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  showCursor: true,
                ),

                SizedBox(height: size.height * 0.05),

                MyButton(
                  text: "VERIFY",
                  color: AppColor.loginButton,
                  isLoading: _isLoading,
                  onPressed: () async {
                    if (otpController.text.length == 4) {
                      setState(() => _isLoading = true);

                      // Simulate API call delay
                      await Future.delayed(const Duration(seconds: 2));

                      // ✅ Save registration status
                      await setIsRegistered();

                      // ✅ Show success toast
                      Fluttertoast.showToast(
                        msg: "OTP verified successfully 🎉",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );

                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => Homepage()),
                      );

                      setState(() => _isLoading = false);
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please enter complete OTP",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 14.0,
                      );
                    }
                  },
                ),

                SizedBox(height: size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't get code",
                      style: Styles.textStyleSmall2(context,
                          color: AppColor.loginText),
                    ),
                    SizedBox(width: size.width * 0.01),
                    GestureDetector(
                      onTap: () {
                        print("Resend OTP clicked");
                      },
                      child: Text(
                        "RESEND !",
                        style: Styles.textStyleSmall(context,
                            color: AppColor.redColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
