import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soapy/pages/homepage.dart';
import 'package:soapy/provider/UserProvider.dart';
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

  UserProvider get provider =>context.read<UserProvider>();

  @override
  void initState() {
    super.initState();
    getMobileNumber();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) focusNode.requestFocus();
    });
  }

  Future<void> getMobileNumber() async {
    final prefs = await SharedPreferences.getInstance();
    String? number = prefs.getString(AppConstants.USERMOBILE);
    setState(() => mobileNumber = number);
  }

  Future<void> setIsRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.ISREGISTERED, true);
    print("✅ User registration status saved");
  }

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
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Qnss-bg2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.1),
                Image.asset("assets/icons/Qnss-new_icon.png",
                    width: 350, height: 180),
                Text("Verifying Your",
                    style: Styles.textStyleLogin(context,
                        color: AppColor.loginText)),
                const SizedBox(height: 10),
                Text("Code",
                    style: Styles.textStyleLogin(context,
                        color: AppColor.loginText)),
                SizedBox(height: size.height * 0.05),
                Text("Please type the verification code",
                    style: Styles.textStyleSmall(context,
                        color: AppColor.whiteColor)),
                Text(
                  mobileNumber == null
                      ? "sent to ..."
                      : "sent to ${maskNumber(mobileNumber!)}",
                  style: Styles.textStyleSmall(context,
                      color: AppColor.whiteColor),
                ),
                SizedBox(height: size.height * 0.02),

                // ✅ PIN input
                Pinput(
                  controller: otpController,
                  focusNode: focusNode,
                  length: 6,
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
                    if (otpController.text.length == 6 &&
                        mobileNumber != null) {
                      setState(() => _isLoading = true);

                      final result = await provider.verifyOtp(
                        mobileNumber: mobileNumber!,
                        otp: otpController.text,
                      );

                      setState(() => _isLoading = false);

                      if (result.status) {
                        await setIsRegistered();
                        Fluttertoast.showToast(
                          msg: "OTP verified successfully 🎉",
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                        );
                        if (!mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const Homepage()),
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: "Invalid OTP or Login failed",
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please enter the complete OTP",
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  },
                ),

                SizedBox(height: size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Didn't get code",
                        style: Styles.textStyleSmall2(context,
                            color: AppColor.loginText)),
                    SizedBox(width: size.width * 0.01),
                    GestureDetector(
                      onTap: () {
                        print("Resend OTP clicked");
                      },
                      child: Text("RESEND !",
                          style: Styles.textStyleSmall(context,
                              color: AppColor.redColor)),
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
