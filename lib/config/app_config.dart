import 'package:soapy/flavours.dart';

class AppConfig {
  static const AppConfig instance = AppConfig();
  const AppConfig();
  String get baseUrl {
    switch (F.appFlavor) {
      case null:
        return "https://nss.tsitcloud.com/";
      case Flavor.dev:
        return "https://nss.tsitcloud.com/";
      case Flavor.prod:
        return "https://nss.tsitcloud.com/";
      case Flavor.demo:
        return "https://nss.tsitcloud.com/";
    }
  }
}
