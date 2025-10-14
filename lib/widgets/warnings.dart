import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:soapy/route_generator.dart';
import 'package:soapy/services/api_service.dart';
import 'package:soapy/util/exception.dart';
import 'package:soapy/util/extension.dart';
import 'package:soapy/util/global.dart';
import 'package:soapy/widgets/dilogue.dart';



class AppCupertinoDialogue extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final Function(BuildContext context)? onTap;
  final bool barrierDismissible;

  const AppCupertinoDialogue({
    super.key,
    required this.title,
    required this.content,
    required this.buttonText,
    this.onTap,
    this.barrierDismissible = true,
  });

  static Future<T?> showTimeoutException<T>(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AppCupertinoDialogue(
          title: AppGlobal.connectTimeOut,
          content: AppGlobal.timeoutWarningmsg,
          buttonText: AppGlobal.ok.toUpperCase(),
        );
      },
    );
  }

  static Future<T?> showIncorrectCredDialogue<T>(
    BuildContext context, {
    required String message,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AppCupertinoDialogue(
          title: AppGlobal.unableLogin,
          content: message,
          buttonText: AppGlobal.tryAgain,
        );
      },
    );
  }

  static Future<T?> forceLogout<T>(
    BuildContext context, {
    required String message,
    bool forceLogin = true,
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AppCupertinoDialogue(
          title: AppGlobal.oops.toUpperCase(),
          content: message,
          buttonText: AppGlobal.loginagain,
          barrierDismissible: false,
          onTap: (context) async {
            if (forceLogin) {
              await AppRouteName.loginPage.pushAndRemoveUntil(
                context,
                (route) => false,
              );
            } else {
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String content,
    required String buttonText,
    Function(BuildContext context)? onTap,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AppCupertinoDialogue(
          title: title,
          content: content,
          buttonText: buttonText,
          onTap: onTap,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        if (barrierDismissible) {
          Navigator.pop(context);
        } else {
          if (kDebugMode) {
            Navigator.pop(context);
          }
        }
      },
      child: CupertinoAlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [const SizedBox(height: 15), Text(content)],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: onTap != null
                ? () {
                    onTap!(context);
                  }
                : () {
                    Navigator.of(context).maybePop();
                  },
            child: Text(
              buttonText,
              style: TextStyle(
                color: context.colorScheme.secondaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoInternetScreen extends StatelessWidget {
  /// The "NoInternetScreen.show()" dialogue is set to display only once, regardless of multiple API calls.
  /// The FunCallManager manages the entire process, seamlessly coordinating the presentation
  /// of the dialogue, API calls, and handling network unavailability.
  static Future<bool> show(BuildContext context) async {
    final data = _FunCallManager.insert();
    if (!_FunCallManager.alreadyCalled) {
      _FunCallManager.switchValue(data);
      final result =
          await showModalBottomSheet<bool>(
            context: context,
            backgroundColor: context.colorScheme.surface,
            isDismissible: false,
            isScrollControlled: true,
            enableDrag: false,
            useSafeArea: true,
            transitionAnimationController: AnimationController(
              duration: const Duration(milliseconds: 500),
              // Adjust duration as needed
              vsync: Navigator.of(context),
            ),
            builder: (context) {
              return const NoInternetScreen();
            },
          ) ??
          false;
      _FunCallManager.remove(data);
      return result;
    } else {
      _FunCallManager.remove(data);
      while (_FunCallManager.alreadyCalled == true) {
        await Future.delayed(const Duration(milliseconds: 500));
      }

      return true;
    }
  }

  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        try {
          await APIService.checkInternet().then((value) {
            if (value == true) {
              Navigator.pop(context, true);
            } else {
              AppDialogue.toast(AppGlobal.noInternet);
            }
          });
        } on InternetException {
          AppDialogue.toast(AppGlobal.noInternet);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Lottie.asset(ConstantImageKey.noInternet),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) =>
                      LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          context.colorScheme.primary,
                          context.colorScheme.secondary,
                        ],
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                  child: Text(
                    AppGlobal.oops.toUpperCase(),
                    style: context.textTheme.displayLarge?.copyWith(
                      height: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppGlobal.noInternet,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await APIService.checkInternet().then((value) {
                          if (value == true) {
                            Navigator.pop(context, true);
                          }
                        });
                      } on InternetException catch (e) {
                        AppDialogue.toast(e.message);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      // padding: const EdgeInsets.symmetric(
                      //   vertical: 20,
                      //   horizontal: 20,
                      // ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(80, 80),
                          bottomLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                          bottomRight: Radius.elliptical(80, 80),
                        ),
                      ),
                    ),
                    child: Text(
                      AppGlobal.tryAgain,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FunCallManager {
  static int limitOfCalls = 1000000;
  static int apiCallCount = 0;

  static List<MapEntry<int, bool>> list = [];

  static bool get alreadyCalled {
    return list.where((element) => element.value == true).isNotEmpty;
  }

  static MapEntry<int, bool> insert() {
    if (apiCallCount > limitOfCalls) {
      apiCallCount = 0;
    }
    apiCallCount++;
    final value = MapEntry(apiCallCount, false);
    list.add(value);
    return value;
  }

  static switchValue(MapEntry<int, bool> value) {
    list = list
        .map(
          (entry) => entry.key == value.key ? MapEntry(value.key, true) : entry,
        )
        .toList();
  }

  static remove(MapEntry<int, bool> value) {
    list.removeWhere((element) => element.key == value.key);
  }

  // static bool checkExist(MapEntry<int,bool> value){
  //  return list.where((element) => element.key==value.key).toList().isNotEmpty;
  // }
}

class NewVersionAvailableDialogue extends StatelessWidget {
  final String newVersion;
  final String oldVersion;
  final String? apkLink;
  const NewVersionAvailableDialogue({
    super.key,
    required this.newVersion,
    required this.apkLink,
    required this.oldVersion,
  });
  static Future<T?> showTimeoutException<T>(
    BuildContext context, {
    required ForceUpdateException exception,
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return NewVersionAvailableDialogue(
          apkLink: exception.apkLink,
          newVersion: exception.newVersion,
          oldVersion: exception.oldVersion,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppGlobal.newVersionAvailable(newVersion)),
      content: Text(AppGlobal.newVersionAvailableMsg(newVersion, oldVersion)),
      actions: [
        TextButton(
          onPressed: () async {
            try {
              if (apkLink != null) {
                // ignore: deprecated_member_use
                // await launch(apkLink!);
              } else {
                Fluttertoast.showToast(msg: 'Can\'t launch app link');
              }
            } on Exception catch (_) {
              Fluttertoast.showToast(msg: 'Can\'t launch app link');
            }
          },
          child: Text(AppGlobal.ok.toUpperCase()),
        ),
      ],
    );
  }
}

class AppWarningDialogue extends StatelessWidget {
  final String title;
  final String content;

  const AppWarningDialogue({
    super.key,
    required this.title,
    required this.content,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String content,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AppWarningDialogue(
          title: AppGlobal.connectTimeOut,
          content: AppGlobal.timeoutWarningmsg,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          child: Text(AppGlobal.ok.toUpperCase()),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
