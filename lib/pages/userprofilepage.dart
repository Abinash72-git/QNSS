import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soapy/util/appconstant.dart';
import 'package:soapy/util/colors.dart';
import 'package:soapy/util/style.dart';


class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Load user details from SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString(AppConstants.USERNAME) ?? '';
      _mobileController.text = prefs.getString(AppConstants.USERMOBILE) ?? '';
      _imagePath = prefs.getString(AppConstants.USERIMAGE);
    });
  }

  /// Save updated details to SharedPreferences
  Future<void> _saveUserData() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.USERNAME, _nameController.text);
    await prefs.setString(AppConstants.USERMOBILE, _mobileController.text);
    if (_imagePath != null) {
      await prefs.setString(AppConstants.USERIMAGE, _imagePath!);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context);
    }
  }

  /// Pick profile image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imagePath = picked.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile',style: TextStyle(color: AppColor.loginText),),
        backgroundColor: AppColor.loginButton,
        centerTitle: true,
        iconTheme: const IconThemeData(
    color: AppColor.loginText, // 👈 sets back arrow color
  ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: size.width * 0.18,
                  backgroundColor: AppColor.loginText,
                  backgroundImage:
                      _imagePath != null ? FileImage(File(_imagePath!)) : null,
                  child: _imagePath == null
                      ? const Icon(Icons.person_2_sharp,
                          size: 40, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your name" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: "Mobile Number",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? "Please enter your mobile number" : null,
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveUserData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.titleButton,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    "Save",
                    style: Styles.textStyleSmall3(context,
                        color: AppColor.whiteColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
