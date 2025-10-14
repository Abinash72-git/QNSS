import 'package:flutter/material.dart';
import 'package:soapy/pages/loginpage.dart';


enum AppRouteName {
  loginPage('/loginpage');

  final String value;
  const AppRouteName(this.value);
}

extension AppRouteNameExt on AppRouteName {
  Future<T?> push<T extends Object?>(
    BuildContext context, {
    Object? args,
  }) async {
    return await Navigator.pushNamed<T>(context, value, arguments: args);
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(
    BuildContext context,
    bool Function(Route<dynamic>) predicate, {
    Object? args,
  }) async {
    return await Navigator.pushNamedAndRemoveUntil<T>(
      context,
      value,
      predicate,
      arguments: args,
    );
  }

  Future<T?> popAndPush<T extends Object?>(
    BuildContext context, {
    Object? args,
  }) async {
    return await Navigator.popAndPushNamed(context, value);
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final name = AppRouteName.values
        .where((element) => element.value == settings.name)
        .firstOrNull;

    switch (name) {
      case AppRouteName.loginPage:
        return MaterialPageRoute(builder: (_) => Loginpage());
      // case AppRouteName.otpPage:
      // final userId = settings.arguments as String;
      //   return MaterialPageRoute(builder: (_) => Otpverifypage(userId: userId,));
      // case AppRouteName.homepage:
      //   return MaterialPageRoute(builder: (_) => Homepage());
      // case AppRouteName.Storepage:
      //   return MaterialPageRoute(builder: (_) => Storepage());
      case null:
        return MaterialPageRoute(
          builder: (context) =>
              Scaffold(body: Center(child: Text("Route not found"))),
        );
      default:
        return MaterialPageRoute(
          builder: (context) =>
              Scaffold(body: Center(child: Text("Route Error"))),
        );
    }
  }
}

class AudioScreenArgs<T extends ChangeNotifier, R extends Object?> {
  final T provider;

  AudioScreenArgs({required this.provider});
}
