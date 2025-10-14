import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:soapy/custom/dual_type.dart';
import 'package:soapy/util/colors.dart';
import 'package:soapy/util/extension.dart';
import 'package:soapy/widgets/init_state_widget.dart';



class AppDialogue {
  static snackBar(
    BuildContext context, {
    required String content,
    bool clearOther = true,
  }) async {
    if (clearOther) {
      ScaffoldMessenger.of(context).clearSnackBars();
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(content)));
  }

  // static Future<R> openLoadingDialogAfterClose<T, R>(
  //   BuildContext context, {
  //   required String text,
  //   required Future<T> Function() load,
  //   double? percentage,
  //   FutureOr<R> Function(T value)? afterComplete,
  //   // R Function(T value)? afterFinish,
  // }) async {
  //   try {
  //     DualTypeModel? value = await showDialog<DualTypeModel>(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (ctx) {
  //         return _LoadingDialogue(
  //           text,
  //           load: load,
  //           percentage: percentage,
  //         );
  //       },
  //     );
  //     if (afterComplete != null) {
  //       if (value?.value2 != null) {
  //         throw value?.value2;
  //       }
  //       return await afterComplete(value?.value1);
  //     } else {
  //       if (value?.value2 != null) {
  //         throw value?.value2;
  //       } else {
  //         return value?.value1;
  //       }
  //     }
  //   } on Exception {
  //     rethrow;
  //   }
  // }
  static Future<R> openLoadingDialogAfterClose<T, R>(
    BuildContext context, {
    required String text,
    required Future<T> Function() load,
    double? percentage,
    FutureOr<R> Function(T value)? afterComplete,
    // R Function(T value)? afterFinish,
  }) async {
    try {
      DualTypeModel? value = await showDialog<DualTypeModel>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return _LoadingDialogue(text, load: load, percentage: percentage);
        },
      );
      if (afterComplete != null) {
        if (value?.value2 != null) {
          throw value?.value2;
        }
        return await afterComplete(value?.value1);
      } else {
        if (value?.value2 != null) {
          throw value?.value2;
        } else {
          return value?.value1;
        }
      }
    } on Exception {
      rethrow;
    }
  }

  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    String? content,
    FutureOr<T> Function()? load,
  }) async {
    var value = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _AlertDialogue(content: content, title: title, load: load);
      },
    );
    return value;
  }

  static Future<T?> showSingleButtonAlert<T>(
    BuildContext context, {
    String? title,
    String? content,
    FutureOr<T> Function()? load,
  }) async {
    var value = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _AlertDialogueWithSingleButton(
          content: content,
          title: title,
          load: load,
        );
      },
    );
    return value;
  }

  static Future<T?> delete<T>(
    BuildContext context, {
    String? title,
    String? content,
    FutureOr<T> Function()? load,
  }) async {
    var value = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _AlertDialogue(content: content, title: title, load: load);
      },
    );
    return value;
  }

  static void toast(
    String msg, {
    Duration duration = const Duration(seconds: 1),
  }) {
    // Widget toast = Container(
    //   padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(25.0),
    //     color: AppKey.navigatorKey.currentContext!.colorScheme.onBackground,
    //   ),
    //   child:  Text(msg,style: TextStyle(
    //       color: AppKey.navigatorKey.currentContext!.colorScheme.background
    //   ),),
    // );
    // FToast().init(AppKey.navigatorKey.currentContext!).showToast(
    //   child: toast,
    //   gravity: ToastGravity.BOTTOM,
    //   toastDuration: duration,
    // );
    Fluttertoast.showToast(msg: msg);
  }

  static void toastContext(
    BuildContext context, {
    required String msg,
    Duration? duration,
  }) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: context.colorScheme.onSurface,
      ),
      child: Text(msg, style: TextStyle(color: context.colorScheme.surface)),
    );
    FToast()
        .init(context)
        .showToast(
          child: toast,
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
  }

  // static Future<DateTime?> showDatePickers(
  //   BuildContext context, {
  //   DateTime? initialDate,
  //   DateTime? firstDate,
  // }) async {
  //   return await showDatePicker(
  //     context: context,
  //     firstDate: firstDate ?? AppConstants.firstDate,
  //     lastDate: AppConstants.lastDate,
  //     initialDate: initialDate,
  //   );
  // }

  static Future<DateTimeRange?> showDateRangePickers(
    BuildContext context, {
    DateTimeRange? initialDateRange,
  }) async {
    return await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: context.themeData.copyWith(
            colorScheme: context.colorScheme.copyWith(
              secondaryContainer: context.colorScheme.primaryContainer,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  static Future<TimeOfDay?> timePicker(
    BuildContext context, {
    required TimeOfDay initialTime,
  }) async {
    return await showTimePicker(context: context, initialTime: initialTime);
  }
}

class _LoadingDialogue extends StatefulWidget {
  final String text;
  final double? percentage;
  final Future Function() load;
  const _LoadingDialogue(this.text, {required this.load, this.percentage});

  @override
  State<_LoadingDialogue> createState() => _LoadingDialogueState();
}

class _LoadingDialogueState extends State<_LoadingDialogue> {
  String loadingText = ".";
  late Timer _timer;
  int dotCount = 1;
  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          dotCount = (dotCount % 3) + 1; // Cycles through 1, 2, 3
          loadingText = '. ' * dotCount; // Updates loadingText to ., .., or ...
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        return;
      },
      child: InitStateWidget(
        initState: () async {
          try {
            await widget.load().then((value) {
              if (mounted) {
                Navigator.pop(
                  context,
                  DualTypeModel(value1: value, value2: null),
                );
              }
            });
          } on Exception catch (e) {
            if (mounted) {
              Navigator.pop(context, DualTypeModel(value1: null, value2: e));
            }
          }
        },
        child: AlertDialog(
          content: Row(
            children: <Widget>[
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  value: widget.percentage,
                  color: AppColor.loginButton,
                  //valueColor:Colors.yellow,
                  // AlwaysStoppedAnimation(context.colorScheme.primary),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  "${widget.text} $loadingText",
                  // style: Styles.headingStyle4(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertDialogue<T> extends StatelessWidget {
  final String? title;
  final String? content;
  final FutureOr<T> Function()? load;
  const _AlertDialogue({super.key, this.title, this.content, this.load});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null ? Text(title!) : null,
      content: content != null ? Text(content!) : null,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            "Cancel",
            style: TextStyle(color: context.colorScheme.secondary),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (load != null) {
              final value = await load!();
              // ignore: use_build_context_synchronously
              Navigator.pop(context, value);
            } else {
              Navigator.pop(context, true);
            }
          },
          child: Text(
            "Ok",
            style: TextStyle(color: context.colorScheme.secondary),
          ),
        ),
      ],
    );
  }
}

class _AlertDialogueWithSingleButton<T> extends StatelessWidget {
  final String? title;
  final String? content;
  final FutureOr<T> Function()? load;
  const _AlertDialogueWithSingleButton({
    super.key,
    this.title,
    this.content,
    this.load,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null
          ? Text(title!, style: context.textTheme.titleLarge)
          : null,
      content: content != null ? Text(content!) : null,
      actions: [
        // TextButton(
        //   onPressed: () {
        //     Navigator.of(context).pop(false);
        //   },
        //   child: Text(
        //     "Cancel",
        //     style: TextStyle(color: context.colorScheme.secondary),
        //   ),
        // ),
        TextButton(
          onPressed: () async {
            if (load != null) {
              final value = await load!();
              // ignore: use_build_context_synchronously
              Navigator.pop(context, value);
            } else {
              Navigator.pop(context, true);
            }
          },
          child: Text(
            "Ok",
            style: TextStyle(color: context.colorScheme.secondary),
          ),
        ),
      ],
    );
  }
}
