import 'package:flutter/material.dart';
import 'package:soapy/app.dart';
import 'package:soapy/config/app_intialize.dart';

Future<void> main() async {
  await AppInitialize.start();
  runApp( MyApp());
}