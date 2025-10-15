import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soapy/config/app_theme.dart';
import 'package:soapy/flavours.dart';
import 'package:soapy/pages/homepage.dart';
import 'package:soapy/pages/orderpage.dart';
import 'package:soapy/pages/splash.dart';
import 'package:soapy/provider/UserProvider.dart';
import 'package:soapy/route_generator.dart';
import 'package:soapy/util/appconstant.dart';
// Import your UserProvider


ValueNotifier<bool> isDevicePreviewEnabled = ValueNotifier<bool>(false);
bool testingMode = kDebugMode && F.appFlavor == Flavor.dev;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDevicePreviewEnabled,
      builder: (context, value, __) {
        return MultiProvider(
          providers: [
            // Add your UserProvider
            ChangeNotifierProvider<UserProvider>(
              create: (_) => UserProvider(),
            ),
            // Add any other providers you might need
          ],
          child: AppThemeData(
            data: AppThemes(ThemeMode.light).customTheme,
            child: DevicePreview(
              enabled: F.appFlavor != Flavor.prod ? value : false,
              tools: DevicePreview.defaultTools,
              builder: (context) {
                return MaterialApp(
                  showSemanticsDebugger: false,
                  localizationsDelegates: const [],
                  builder: (BuildContext context, Widget? child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: MediaQuery.of(context).textScaler.clamp(
                          minScaleFactor: 0.5,
                          maxScaleFactor: 1.5,
                        ),
                      ),
                      child: child!,
                    );
                  },
                
                  navigatorKey: AppConstants.navigatorKey,
                
                  useInheritedMediaQuery: true,
                  onGenerateRoute: RouteGenerator.generateRoute,
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: false,
                  theme: AppThemes(ThemeMode.light).theme,
                  darkTheme: AppThemes(ThemeMode.dark).theme,
                  themeMode: ThemeMode.light,
                  home: Splash(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
