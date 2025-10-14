import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soapy/pages/loginpage.dart';
import 'package:soapy/util/appconstant.dart';
import 'package:soapy/util/colors.dart';
import 'dart:io';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<Map<String, String?>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(AppConstants.USERNAME),
      'mobile': prefs.getString(AppConstants.USERMOBILE),
      'imagePath': prefs.getString(AppConstants.USERIMAGE),
    };
  }

  Future<void> _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to logout?\nAll your data will be cleared.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    try {
      // Clear all SharedPreferences data
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Fluttertoast.showToast(
        msg: "Logged out successfully 🎉",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      if (!context.mounted) return;

      // Navigate to login page and clear all routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Loginpage()),
        (route) => false,
      );

      // Show success message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Logged out successfully'),
      //     backgroundColor: Colors.green,
      //     duration: Duration(seconds: 2),
      //   ),
      // );
    } catch (e) {
      if (!context.mounted) return;
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Logout failed: $e'),
      //     backgroundColor: Colors.red,
      //   ),
      Fluttertoast.showToast(
        msg: "Logout failed: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Qnss-bg2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // User Profile Header
            FutureBuilder<Map<String, String?>>(
              future: _getUserData(),
              builder: (context, snapshot) {
                final userData = snapshot.data ?? {};
                final name = userData['name'] ?? 'User';
                final mobile = userData['mobile'] ?? '';
                final imagePath = userData['imagePath'];

                return UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColor.loginButton.withOpacity(0.9),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: imagePath != null && imagePath.isNotEmpty
                        ? FileImage(File(imagePath))
                        : null,
                    child: imagePath == null || imagePath.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: AppColor.loginButton,
                          )
                        : null,
                  ),
                  accountName: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    mobile.isNotEmpty ? '+91 $mobile' : '',
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              },
            ),

            // Menu Items
            Expanded(
              child: Container(
                color: Colors.white.withOpacity(0.95),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(
                      icon: Icons.home,
                      title: 'Home',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  
                    _buildDrawerItem(
                      icon: Icons.history_edu,
                      title: 'Service History',
                      onTap: () {
                        Navigator.pop(context);
                        // This will be handled by bottom nav
                      },
                    ),   _buildDrawerItem(
                      icon: Icons.privacy_tip,
                      title: 'Privacy Policy',
                      onTap: () {
                        Navigator.pop(context);
                        _showAboutDialog(context);
                      },
                    ),
                       _buildDrawerItem(
                      icon: Icons.note_alt_rounded,
                      title: 'Terms and Conditions',
                      onTap: () {
                        Navigator.pop(context);
                        _showAboutDialog(context);
                      },
                    ),
                       _buildDrawerItem(
                      icon: Icons.question_answer,
                      title: 'FAQ',
                      onTap: () {
                        Navigator.pop(context);
                        _showAboutDialog(context);
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.info_outline,
                      title: 'About',
                      onTap: () {
                        Navigator.pop(context);
                        _showAboutDialog(context);
                      },
                    ),
                    const Divider(thickness: 1),
                    _buildDrawerItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      iconColor: Colors.red,
                      titleColor: Colors.red,
                      onTap: () {
                        Navigator.pop(context);
                        _performLogout(context);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // App Version Footer
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white.withOpacity(0.95),
              child: const Text(
                'Version 1.0.0',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Optional: Call logout API if you have one
      // final response = await YourAuthService.logout();

      // Navigate to login screen and remove all previous routes
      if (context.mounted) {
        Navigator.of(context).pop(); // Remove loading dialog
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Loginpage()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      // Handle errors
      if (context.mounted) {
        Navigator.of(context).pop(); // Remove loading dialog

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       'Logout failed: $e',
        //       textScaler: TextScaler.linear(1),
        //     ),
        //     backgroundColor: Colors.red,
        //   ),
        // );
        Fluttertoast.showToast(
          msg: "Logout failed: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }
}

Widget _buildDrawerItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  Color? iconColor,
  Color? titleColor,
}) {
  return ListTile(
    leading: Icon(icon, color: iconColor ?? AppColor.loginButton),
    title: Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: titleColor ?? Colors.black87,
      ),
    ),
    onTap: onTap,
    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
  );
}

void _showAboutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Row(
        children: [
          Image.asset('assets/soapy-logo2.png', width: 40, height: 40),
          const SizedBox(width: 12),
          const Text('About QNSS'),
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QNSS Service App',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 16),
          Text(
            'Professional laundry and cleaning services at your doorstep.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 16),
          Text(
            '© 2025 QNSS. All rights reserved.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
