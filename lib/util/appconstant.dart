import 'package:flutter/material.dart';
import 'package:soapy/models/api_validation_model.dart';

class AppConstants {
  static const String appName = 'QNSS';

  //API URL Constants
  // static const String BASE_URL = 'https://new.dev-healthplanner.xyz/api/'; //Dev
  static const String BASE_URL = "https://fulupostore.tsitcloud.com/api"; //Prod

  // static final String BASE_URL = AppConfig.instance.baseUrl;

  static Map<String, String> headers = {
    //"X-API-KEY": "OpalIndiaKeysinUse",
    'Charset': 'utf-8',
    'Accept': 'application/json',
  };
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  static late ApiValidationModel apiValidationModel;

  static String networkImage =
      "https://creazilla-store.fra1.digitaloceanspaces.com/cliparts/3174456/profile-clipart-xl.png";
  static const String token = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String USERMOBILE = 'user_mobile';
  static const String UserID = 'userId';
  static const String Company = 'company';
  static const String location = 'location';
  static const String USERIMAGE = 'user_image';
  static const String ISREGISTERED = 'is_registered';
  static const String USERNAME = 'user_name';
  static const String COMPANY = 'company_name';
  static const String LOCATION = 'location_address';
}
