

import 'package:soapy/flavours.dart';

class AppConfig {
  static const AppConfig instance = AppConfig();
  const AppConfig();
  String get baseUrl {
    switch (F.appFlavor) {
      case null:
        return "https://fulupostore.tsitcloud.com/api";
      case Flavor.dev:
        return "https://fulupostore.tsitcloud.com/api";
      case Flavor.prod:
        return "https://fulupostore.tsitcloud.com/api";
      case Flavor.demo:
        return "https://fulupostore.tsitcloud.com/api";
    }
  }
}
