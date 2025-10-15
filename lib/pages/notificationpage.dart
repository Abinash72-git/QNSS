import 'package:flutter/material.dart';
import 'package:soapy/util/colors.dart';
import 'package:soapy/util/style.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: AppColor.loginText),textScaler: TextScaler.linear(1),
        ),
        backgroundColor: AppColor.loginButton,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: AppColor.loginText, // back arrow color
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_none,
                size: size.width * 0.25,
                color: AppColor.loginText.withOpacity(0.5),
              ),
              const SizedBox(height: 20),
              Text(
                "No Notifications Yet",
                style: Styles.textStyleSmall3(
                  context,
                  color: AppColor.loginText.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "You’ll see updates and alerts here once they’re available.",
                textAlign: TextAlign.center,
                style: Styles.textStyleSmall3(
                  context,
                  color: AppColor.loginText.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
