import 'dart:async';
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

  // OTP Display Variables
  bool showOtpMessage = false;
  String? receivedOtp;
  String? otpExpiresIn;
  Timer? otpDisplayTimer;
  Timer? resendTimer;
  int resendCountdown = 0;

  UserProvider get provider => context.read<UserProvider>();

  @override
  void initState() {
    super.initState();
    getMobileNumber();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) focusNode.requestFocus();
    });
    
    // Simulate OTP reception
    simulateOtpReception();
  }

  Future<void> simulateOtpReception() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? demoOtp = prefs.getString(AppConstants.Otp);
    String? expiresIn = prefs.getString(AppConstants.OtpExpiresIn);

    if (demoOtp != null && demoOtp.isNotEmpty) {
      // Wait 2 seconds to simulate message reception
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            receivedOtp = demoOtp;
            otpExpiresIn = expiresIn;
            showOtpMessage = true;
          });

          // Auto-hide the message after 50 seconds
          otpDisplayTimer = Timer(const Duration(seconds: 50), () {
            if (mounted) {
              setState(() {
                showOtpMessage = false;
              });
            }
          });

          // Show snackbar as well
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.message, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'OTP Received: $demoOtp',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'USE',
                textColor: Colors.white,
                onPressed: () {
                  _useReceivedOtp(demoOtp);
                },
              ),
            ),
          );
        }
      });
    }
  }

  void _useReceivedOtp(String otp) {
    setState(() {
      otpController.text = otp;
      showOtpMessage = false;
    });
    
    Fluttertoast.showToast(
      msg: "OTP auto-filled",
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
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

  String formatPhoneNumber(String phone) {
    if (phone.length < 4) return phone;
    
    String visibleStart = phone.substring(0, 2);
    String visibleEnd = phone.substring(phone.length - 2);
    String maskedMiddle = '*' * (phone.length - 4);
    
    return '$visibleStart$maskedMiddle$visibleEnd';
  }

  Future<void> resendOtp() async {
    if (resendCountdown > 0) {
      Fluttertoast.showToast(
        msg: "Please wait $resendCountdown seconds before resending",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    if (mobileNumber == null) {
      Fluttertoast.showToast(
        msg: "Mobile number not found",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await provider.login(UserMobile: mobileNumber!);

    setState(() => _isLoading = false);

    if (result.status) {
      // Start countdown timer
      setState(() => resendCountdown = 90);
      resendTimer?.cancel();
      resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (resendCountdown > 0) {
          setState(() => resendCountdown--);
        } else {
          timer.cancel();
        }
      });

      Fluttertoast.showToast(
        msg: "OTP resent successfully!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Simulate new OTP reception
      simulateOtpReception();
    } else {
      Fluttertoast.showToast(
        msg: "Failed to resend OTP",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    focusNode.dispose();
    otpDisplayTimer?.cancel();
    resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Qnss-bg2.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
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

                    // PIN input
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
                              MaterialPageRoute(
                                  builder: (_) => const Homepage()),
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
                          onTap: resendCountdown > 0 ? null : resendOtp,
                          child: Text(
                            resendCountdown > 0
                                ? "RESEND ! ($resendCountdown s)"
                                : "RESEND !",
                            style: Styles.textStyleSmall(
                              context,
                              color: resendCountdown > 0
                                  ? Colors.grey
                                  : AppColor.redColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.05),
                  ],
                ),
              ),
            ),
          ),

          // OTP Message Overlay
          if (showOtpMessage && receivedOtp != null)
            Positioned(
              top: size.height * 0.05,
              left: size.width * 0.05,
              right: size.width * 0.05,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade600],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.26),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.message,
                          color: Colors.green, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'OTP Message Received',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),textScaler: TextScaler.linear(1),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your verification code: $receivedOtp',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),textScaler: TextScaler.linear(1),
                          ),
                          Text(
                            'for ${mobileNumber != null ? formatPhoneNumber(mobileNumber!) : "your number"}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),textScaler: TextScaler.linear(1),
                          ),
                          if (otpExpiresIn != null)
                            Text(
                              'Expires in: $otpExpiresIn seconds',
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                              ),textScaler: TextScaler.linear(1),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _useReceivedOtp(receivedOtp!);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'USE',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),textScaler: TextScaler.linear(1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showOtpMessage = false;
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}