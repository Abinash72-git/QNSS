import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:soapy/util/colors.dart';
import 'package:soapy/util/style.dart';

class OrderListCard extends StatelessWidget {
  final String? imagePath;
  final String serviceName;
  final String timeRange;
  final VoidCallback onStartPressed;
  final VoidCallback onFinishPressed;
  final VoidCallback? onImageTap;
  final bool started;
  final bool isSubcategory;
  final bool isExpanded;
  final bool enabled;
  final bool completed;
  final bool finishEnabled;
  final bool parentCategoryStarted;
  final bool anyOtherStarted;

  const OrderListCard({
    super.key,
    this.imagePath,
    required this.serviceName,
    required this.timeRange,
    required this.onStartPressed,
    required this.onFinishPressed,
    this.onImageTap,
    required this.started,
    this.isSubcategory = false,
    this.isExpanded = false,
    this.enabled = true,
    this.completed = false,
    this.finishEnabled = true,
    this.parentCategoryStarted = true,
    this.anyOtherStarted = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final bool isDisabled =
        isSubcategory && (anyOtherStarted && !started && !completed);

    // Category UI - Awesome Modern Design
    if (!isSubcategory) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          gradient: completed
              ? LinearGradient(
                  colors: [
                    const Color(0xFF4CAF50).withOpacity(0.8),
                    const Color(0xFF66BB6A).withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.grey.shade50,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(20),
          border: completed
              ? Border.all(color: const Color(0xFF4CAF50), width: 2.5)
              : Border.all(color: Colors.grey.shade200, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: completed
                  ? const Color(0xFF4CAF50).withOpacity(0.3)
                  : Colors.black.withOpacity(0.06),
              blurRadius: completed ? 12 : 8,
              offset: const Offset(0, 4),
              spreadRadius: completed ? 1 : 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Name with Icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: completed
                              ? Colors.white.withOpacity(0.3)
                              : AppColor.loginButton.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          completed ? Icons.check_circle : Icons.cleaning_services,
                          color: completed ? Colors.white : AppColor.loginButton,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          serviceName,
                          style: TextStyle(
                            fontSize: size.width * 0.048,
                            fontWeight: FontWeight.w800,
                            color: completed ? Colors.white : AppColor.blackColor,
                            letterSpacing: 0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textScaler: const TextScaler.linear(1),
                        ),
                      ),
                      const SizedBox(width: 70),
                    ],
                  ),

                  //const SizedBox(height: 5),

                  // Timer Section with Beautiful Card
                  Container(
                    margin: EdgeInsets.only(left: 50),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                     // vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: completed
                          ? Colors.white.withOpacity(0.25)
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(14),
                      // border: Border.all(
                      //   color: completed
                      //       ? Colors.white.withOpacity(0.4)
                      //       : Colors.orange.shade200,
                      //   width: 1.5,
                      // ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.timer_outlined,
                            size: 18,
                            color: Colors.deepOrange,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              timeRange,
                              style: TextStyle(
                                fontSize: size.width * 0.044,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.5,
                                color: completed 
                                    ? Colors.white 
                                    : const Color(0xFFD32F2F),
                                shadows: completed
                                    ? [
                                        const Shadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 1),
                                          blurRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                              textScaler: const TextScaler.linear(1),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [const SizedBox(width: 4),
                                _buildTimeLabel("hr", completed),
                                const SizedBox(width: 29),
                                _buildTimeLabel("min", completed),
                                const SizedBox(width: 23),
                                _buildTimeLabel("sec", completed),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Decorative corner accent (top right)
            if (!completed)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.loginButton.withOpacity(0.1),
                        Colors.transparent,
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // Subcategory UI (Original Layout - Unchanged)
    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
        left: isSubcategory ? 20 : 0,
        right: 0,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: completed
            ? const Color.fromARGB(108, 49, 212, 54)
            : const Color.fromARGB(195, 1, 21, 58),
        borderRadius: BorderRadius.circular(16),
        border: completed ? Border.all(color: Colors.green, width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image section
          GestureDetector(
            onTap: (imagePath != null && imagePath!.isNotEmpty && completed)
                ? onImageTap
                : null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imagePath != null && imagePath!.isNotEmpty
                  ? Image.file(
                      File(imagePath!),
                      width: size.width * 0.2,
                      height: size.width * 0.2,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: size.width * 0.2,
                          height: size.width * 0.2,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.broken_image,
                            size: 30,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: size.width * 0.2,
                      height: size.width * 0.2,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),

          const SizedBox(width: 5),

          // Content column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceName,
                  style: TextStyle(
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.w700,
                    color: AppColor.whiteColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textScaler: const TextScaler.linear(1),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 20,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          timeRange,
                          style: TextStyle(
                            fontSize: size.width * 0.033,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: AppColor.redColor,
                          ),
                          textScaler: const TextScaler.linear(1),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: const [
                            SizedBox(width: 2),
                            Text(
                              "hr",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w800,
                              ),
                              textScaler: TextScaler.linear(1),
                            ),
                            SizedBox(width: 22),
                            Text(
                              "m",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w800,
                              ),
                              textScaler: TextScaler.linear(1),
                            ),
                            SizedBox(width: 26),
                            Text(
                              "s",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w800,
                              ),
                              textScaler: TextScaler.linear(1),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 20),
                      child: GestureDetector(
                        onTap: isDisabled
                            ? () {
                                if (anyOtherStarted && !started && !completed) {
                                  Fluttertoast.showToast(
                                    msg: "Please finish the current task first",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.red,
                                  );
                                }
                              }
                            : (started ? onFinishPressed : onStartPressed),
                        child: Container(
                          width: size.width * 0.2,
                          height: size.height * 0.035,
                          decoration: BoxDecoration(
                            color: isDisabled
                                ? Colors.grey
                                : completed
                                    ? const Color.fromARGB(255, 219, 66, 39)
                                    : started
                                        ? AppColor.greenColor
                                        : AppColor.loginButton,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              completed
                                  ? "Closed"
                                  : (started ? "Finish" : "Start"),
                              style: Styles.textStyleSmall2(
                                context,
                                color: Colors.white,
                              ),
                              textScaler: const TextScaler.linear(1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for time labels
  Widget _buildTimeLabel(String label, bool isCompleted) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        color: isCompleted ? Colors.white.withOpacity(0.9) : Colors.grey.shade600,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.5,
      ),
      textScaler: const TextScaler.linear(1),
    );
  }
}