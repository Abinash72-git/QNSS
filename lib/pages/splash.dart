import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soapy/pages/loginpage.dart';
import 'package:soapy/pages/homepage.dart';
import 'package:soapy/util/appconstant.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();


    _checkRegistrationAndNavigate();
  }

  Future<void> _checkRegistrationAndNavigate() async {

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();


      final bool isRegistered =
          prefs.getBool(AppConstants.ISREGISTERED) ?? false;


      final String? userName = prefs.getString(AppConstants.USERNAME);
      final String? userMobile = prefs.getString(AppConstants.USERMOBILE);

      print("Registration Status: $isRegistered");
      print("User Name: $userName");
      print("User Mobile: $userMobile");

      if (!mounted) return;

      if (isRegistered) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Homepage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Loginpage()),
        );
      }
    } catch (e) {
      print("Error checking registration: $e");

      if (!mounted) return;


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Loginpage()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          SizedBox.expand(
            child: Image.asset("assets/Qnss-bg.jpg", fit: BoxFit.cover),
          ),

         Container(color: Colors.black.withOpacity(0.3)),
          Center(
            child: FadeTransition(
              opacity: _animation,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 150),
                  Image.asset(
                    "assets/icons/Qnss-new_icon.png",
                    width: 300,
                    height: 300,
                  ),
                ],
              ),
            ),
          ),

         Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 60,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white.withOpacity(0.3),
                  color: Colors.white,
                  minHeight: 4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
