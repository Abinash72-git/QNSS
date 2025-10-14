import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soapy/pages/homepage.dart';
import 'package:soapy/util/appconstant.dart';

import 'package:soapy/util/button.dart';
import 'package:soapy/util/colors.dart';
import 'package:soapy/util/style.dart';
import 'package:soapy/util/textfeild.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final TextEditingController userNameController = TextEditingController();
  File? _profileImage;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage() async {
    try {
      // Show dialog to choose between camera and gallery
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Choose Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
          );
        },
      );

      if (source == null) return;

      // Request permission based on source
      PermissionStatus status;
      if (source == ImageSource.camera) {
        status = await Permission.camera.request();
      } else {
        // Try photos permission first (Android 13+), fallback to storage
        status = await Permission.photos.request();
        if (status.isDenied || status.isPermanentlyDenied) {
          status = await Permission.storage.request();
        }
      }

      if (!status.isGranted) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              source == ImageSource.camera
                  ? "Camera permission denied"
                  : "Gallery permission denied",
            ),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () => openAppSettings(),
            ),
          ),
        );
        return;
      }

      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              lockAspectRatio: true,
              cropFrameColor: Colors.white,
              cropGridColor: Colors.white.withOpacity(0.5),
            ),
            IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: true),
          ],
        );

        if (croppedFile != null) {
          setState(() {
            _profileImage = File(croppedFile.path);
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error picking image: $e")));
    }
  }

  // Save user data to SharedPreferences
  Future<void> saveUserData(String userName, String? imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.USERNAME, userName);
    if (imagePath != null) {
      await prefs.setString(AppConstants.USERIMAGE, imagePath);
    }
    await prefs.setBool(AppConstants.ISREGISTERED, true);
  }

  @override
  void dispose() {
    userNameController.dispose();
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
                  "CREATE",
                  style: Styles.textStyleLogin(
                    context,
                    color: AppColor.loginText,
                  ),
                  textScaler: TextScaler.linear(1),
                ),
                const SizedBox(height: 5),
                Text(
                  "YOUR ACCOUNT",
                  style: Styles.textStyleLogin(
                    context,
                    color: AppColor.loginText,
                  ),
                  textScaler: TextScaler.linear(1),
                ),
                SizedBox(height: size.height * 0.02),

                // Profile Image Box
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.loginButton,
                          border: Border.all(color: Colors.white, width: 2),
                          image: _profileImage != null
                              ? DecorationImage(
                                  image: FileImage(_profileImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _profileImage == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: AppColor.loginText,
                              )
                            : null,
                      ),
                      // Camera icon overlay
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 4),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: AppColor.loginButton,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.02),
                Form(
                  key: _formKey,
                  child: MyTextField(
                    controller: userNameController,
                    hintText: "Enter Your Name",
                    fillColor: AppColor.loginText,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "* Name cannot be empty";
                      } else if (value.trim().length < 3) {
                        return "* Name must be at least 3 characters";
                      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                        return "* Name can only contain letters";
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(height: size.height * 0.02),
                MyButton(
                  text: "REGISTER",
                  color: AppColor.loginButton,
                  isLoading: _isLoading,
                  onPressed: () async {
                    // Validate form
                    if (!_formKey.currentState!.validate()) {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text(
                      //       "Please enter a valid name",
                      //       style: TextStyle(color: AppColor.whiteColor),
                      //     ),
                      //   ),
                      // );
                      Fluttertoast.showToast(
                        msg: "Please enter a valid name",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 14.0,
                      );
                      return;
                    }

                    // Show loading
                    setState(() => _isLoading = true);

                    try {
                      // Save user data
                      await saveUserData(
                        userNameController.text.trim(),
                        _profileImage?.path,
                      );

                      // Simulate API call (remove in production)
                      await Future.delayed(const Duration(seconds: 2));

                      if (!mounted) return;

                      // Navigate to home and clear stack
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (route) => Homepage()),
                        (route) => false, // Remove all previous routes
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Registration failed: $e")),
                      );
                    } finally {
                      if (mounted) {
                        setState(() => _isLoading = false);
                      }
                    }
                  },
                ),

                SizedBox(height: size.height * 0.01),
                Text(
                  "Tap the icon above to add profile picture",
                  style: Styles.textStyleSmall2(
                    context,
                    //color: AppColor.whiteColor.withOpacity(0.7),
                    color: AppColor.loginText,
                  ),
                  textScaler: TextScaler.linear(1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
