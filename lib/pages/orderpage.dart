import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soapy/dialogbox/imagepreviewdialog.dart';
import 'package:soapy/pages/homepage.dart';
import 'package:soapy/util/appconstant.dart';
import 'package:soapy/util/colors.dart';
import 'package:soapy/util/dottedLine.dart';
import 'package:soapy/util/orderlistcard.dart';
import 'package:soapy/util/style.dart';

class Orderpage extends StatefulWidget {
  const Orderpage({super.key});

  @override
  State<Orderpage> createState() => _OrderpageState();
}

class _OrderpageState extends State<Orderpage> {
  String? company;
  String? location;

  // Overall timer
  int _seconds = 0;
  Timer? _overallTimer;

  File? _selectedImage;

  // Services with subcategories
  final List<Map<String, dynamic>> services = [
    {
      "category": "Car Parking",
      "seconds": 0,
      "timer": null,
      "started": false,
      "expanded": false,
      "subcategories": [
        {
          "name": "Car Shutter",
          "seconds": 0,
          "timer": null,
          "started": false,
          "imagePath": "",
          "enabled": false,
          "completed": false,
        },
        {
          "name": "Parking Wall",
          "seconds": 0,
          "timer": null,
          "started": false,
          "imagePath": "",
          "enabled": false,
          "completed": false,
        },
      ],
      "completed": false,
    },

    {
      "category": "Conference Room",
      "seconds": 0,
      "timer": null,
      "started": false,
      "expanded": false,
      "subcategories": [
        {
          "name": "Projector Setup",
          "seconds": 0,
          "timer": null,
          "started": false,
          "imagePath": "",
          "enabled": false,
          "completed": false,
        },
        {
          "name": "AC Unit",
          "seconds": 0,
          "timer": null,
          "started": false,
          "imagePath": "",
          "enabled": false,
          "completed": false,
        },
      ],
      "completed": false,
    },
    // {
    //   "category": "Office Room",
    //   "seconds": 0,
    //   "timer": null,
    //   "started": false,
    //   "expanded": false,
    //   "subcategories": [
    //     {
    //       "name": "Desk Cleaning",
    //       "seconds": 0,
    //       "timer": null,
    //       "started": false,
    //       "imagePath": "",
    //       "enabled": false,
    //       "completed": false,
    //     },
    //     {
    //       "name": "Windows",
    //       "seconds": 0,
    //       "timer": null,
    //       "started": false,
    //       "imagePath": "",
    //       "enabled": false,
    //       "completed": false,
    //     },
    //   ],
    //   "completed": false,
    // },
    // {
    //   "category": "Rest Room",
    //   "seconds": 0,
    //   "timer": null,
    //   "started": false,
    //   "expanded": false,
    //   "subcategories": [
    //     {
    //       "name": "Mirror Cleaning",
    //       "seconds": 0,
    //       "timer": null,
    //       "started": false,
    //       "imagePath": "",
    //       "enabled": false,
    //       "completed": false,
    //     },
    //     {
    //       "name": "Floor Mopping",
    //       "seconds": 0,
    //       "timer": null,
    //       "started": false,
    //       "imagePath": "",
    //       "enabled": false,
    //       "completed": false,
    //     },
    //   ],
    //   "completed": false,
    // },
  ];

  @override
  void initState() {
    super.initState();
    getDetails();
    updateOverallTimeDisplay();

    // Initialize: Enable only the first subcategory in each category
    for (var service in services) {
      bool firstFound = false;
      for (var sub in service["subcategories"]) {
        if (!firstFound && sub["completed"] != true) {
          sub["enabled"] = true;
          firstFound = true;
        } else {
          sub["enabled"] = false;
        }
      }
    }
  }

  void updateOverallTimeDisplay() {
    setState(() {
      _seconds = calculateTotalTime();
    });
  }

  int calculateTotalTime() {
    int totalSeconds = 0;
    for (var service in services) {
      totalSeconds += service["seconds"] as int;
    }
    return totalSeconds;
  }

  @override
  void dispose() {
    _overallTimer?.cancel();
    for (var service in services) {
      for (var sub in service["subcategories"]) {
        (sub["timer"] as Timer?)?.cancel();
      }
    }
    super.dispose();
  }

  Future<void> getDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      company = prefs.getString(AppConstants.COMPANY);
      location = prefs.getString(AppConstants.location);
    });
  }

  void startOverallTimer() {
    if (_overallTimer != null) return;

    _overallTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  int calculateCategoryTotalTime(int index) {
    int totalSeconds = 0;
    for (var sub in services[index]["subcategories"]) {
      totalSeconds += sub["seconds"] as int;
    }
    return totalSeconds;
  }

  void showCheckoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text("Cleaning Done", textScaler: TextScaler.linear(1)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "All cleaning tasks for $company have been completed successfully.",
              style: const TextStyle(fontSize: 16),
              textScaler: TextScaler.linear(1),
            ),
            const SizedBox(height: 15),
            Text(
              "Total Time: ${formatTime(_seconds)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textScaler: TextScaler.linear(1),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "CANCEL",
              style: TextStyle(color: Colors.red),
              textScaler: TextScaler.linear(1),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "Cleaning job completed and checked out!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(
              //     content: Text(
              //       "Cleaning job completed and checked out!",
              //       textScaler: TextScaler.linear(1),
              //     ),
              //     backgroundColor: Colors.green,
              //   ),
              // );

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Homepage(completedCompany: company),
                ),
                (Route<dynamic> route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              "CONFIRM CHECKOUT",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textScaler: TextScaler.linear(1),
            ),
          ),
        ],
      ),
    );
  }

  void startSubServiceTimer(int categoryIndex, int subIndex) {
    print("Starting timer for category $categoryIndex, subcategory $subIndex");
    final sub = services[categoryIndex]["subcategories"][subIndex];

    // Cancel existing timer if any
    if (sub["timer"] != null) {
      (sub["timer"] as Timer?)?.cancel();
    }

    // Start a new timer
    sub["timer"] = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        sub["seconds"] = (sub["seconds"] as int) + 1;
        services[categoryIndex]["seconds"] = calculateCategoryTotalTime(
          categoryIndex,
        );
        updateOverallTimeDisplay();
        print("Timer tick: ${sub["seconds"]} seconds");
      });
    });

    print("Timer started successfully");
  }

  bool areAllCategoriesCompleted() {
    for (var service in services) {
      if (service["completed"] != true) {
        return false;
      }
    }
    return true;
  }

  bool areAllSubcategoriesFinished(int index) {
    for (var sub in services[index]["subcategories"]) {
      if (sub["started"] == true) {
        return false;
      }
    }
    return true;
  }

  bool areAllSubcategoriesCompleted(int index) {
    for (var sub in services[index]["subcategories"]) {
      if (sub["completed"] != true) {
        return false;
      }
    }
    return true;
  }

  bool isAnySubcategoryStarted(int index) {
    for (var sub in services[index]["subcategories"]) {
      if (sub["started"] == true) {
        return true;
      }
    }
    return false;
  }

  int getCompletedCategoriesCount() {
    return services.where((service) => service["completed"] == true).length;
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(hours)} : ${twoDigits(minutes)} : ${twoDigits(secs)}";
  }

  Widget buildCategorySection(int index) {
    final service = services[index];
    final isExpanded = service["expanded"];
    final isCategoryStarted = service["started"];
    final isAnySubStarted = isAnySubcategoryStarted(index);
    final areAllSubsFinished = areAllSubcategoriesFinished(index);
    final areAllSubsCompleted = areAllSubcategoriesCompleted(index);
    final isCompleted = service["completed"] == true;

    service["seconds"] = calculateCategoryTotalTime(index);

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Allow expanding/collapsing even for completed categories
            setState(() {
              service["expanded"] = !service["expanded"];
            });
          },
          child: Stack(
            children: [
              OrderListCard(
                serviceName: service["category"],
                timeRange: formatTime(service["seconds"]),
                imagePath: service["imagePath"],
                started: isCategoryStarted,
                isExpanded: isExpanded,
                completed: isCompleted,
                finishEnabled: areAllSubsCompleted,
                onStartPressed: () {
                  // Category doesn't have a Start button anymore
                },
                onFinishPressed: () {
                  // Category doesn't have a Finish button anymore
                },
              ),

              // Expand/collapse button - show even for completed categories
              Positioned(
                right: 30,
                top: 45,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      service["expanded"] = !service["expanded"];
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.green
                          : (isAnySubStarted
                                ? Colors.green
                                : AppColor.loginButton),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),

              // Status badge - show for both in-progress and completed
              Positioned(
                right: 20,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.green
                        : (isAnySubStarted && !areAllSubsFinished
                              ? Colors.orange
                              : Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: isCompleted
                      ? const Text(
                          "COMPLETED",
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textScaler: TextScaler.linear(1),
                        )
                      : (isAnySubStarted && !areAllSubsFinished
                            ? const Text(
                                "IN PROGRESS",
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textScaler: TextScaler.linear(1),
                              )
                            : Container()),
                ),
              ),
            ],
          ),
        ),

        if (isExpanded) ...[
          const SizedBox(height: 5),
          ...List.generate(
            service["subcategories"].length,
            (subIndex) => Padding(
              padding: const EdgeInsets.only(right: 20),
              child: buildSubcategoryWithOrderCard(index, subIndex),
            ),
          ),
        ],
      ],
    );
  }

  int? findNextSubcategoryToEnable(int categoryIndex) {
    final subcategories = services[categoryIndex]["subcategories"];
    for (int i = 0; i < subcategories.length; i++) {
      if (subcategories[i]["completed"] != true) {
        return i; // Return the index of the first non-completed subcategory
      }
    }
    return null; // All completed
  }

  Widget buildSubcategoryWithOrderCard(int categoryIndex, int subIndex) {
    final sub = services[categoryIndex]["subcategories"][subIndex];
    // Get the parent service so we can reference it properly
    final service = services[categoryIndex];

    // Check if any other subcategory is started in this category
    bool anyOtherStarted = false;
    for (int i = 0; i < services[categoryIndex]["subcategories"].length; i++) {
      if (i != subIndex &&
          services[categoryIndex]["subcategories"][i]["started"] == true) {
        anyOtherStarted = true;
        break;
      }
    }

    final isCompleted = sub["completed"] == true;
    final isCategoryCompleted = services[categoryIndex]["completed"] == true;
    return OrderListCard(
      serviceName: sub["name"],
      timeRange: formatTime(sub["seconds"]),
      imagePath: sub["imagePath"],
      started: sub["started"],
      isSubcategory: true,
      enabled: true,
      completed: sub["completed"] == true,
      anyOtherStarted: anyOtherStarted || isCategoryCompleted,
      onImageTap: () {
        // Show the enlarged image when the image is tapped
        if (sub["imagePath"] != null &&
            sub["imagePath"].toString().isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) => ImagePreviewDialog(
              imagePath: sub["imagePath"],
              taskName: sub["name"],
            ),
          );
        }
      },
      onStartPressed: () {
        // Show a toast to confirm the action
        if (isCategoryCompleted) {
          Fluttertoast.showToast(
            msg: "Category already completed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.orange,
          );
          return;
        }
        Fluttertoast.showToast(
          msg: "Starting ${sub["name"]}...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );

        startSubServiceTimer(categoryIndex, subIndex);
        setState(() {
          sub["started"] = true;
          services[categoryIndex]["expanded"] = true;
          services[categoryIndex]["started"] = true;
        });
      },
      onFinishPressed: () {
        (sub["timer"] as Timer?)?.cancel();
        showFinishDialog(
          context,
          formatTime(sub["seconds"]),
          sub["name"],
          company,
          onImageCaptured: (imagePath) {
            setState(() {
              sub["started"] = false;
              sub["completed"] = true;
              sub["imagePath"] = imagePath;
              services[categoryIndex]["seconds"] = calculateCategoryTotalTime(
                categoryIndex,
              );
              updateOverallTimeDisplay();

              // Check if all subcategories are completed to auto-complete the category
              if (areAllSubcategoriesCompleted(categoryIndex)) {
                services[categoryIndex]["completed"] = true;
                services[categoryIndex]["started"] = false;
                // Now use the service variable we defined at the top of the method
                Fluttertoast.showToast(
                  msg: "All tasks completed for ${service["category"]}!",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.green,
                );
              }
            });
          },
        );
      },
    );
  }

  // Future<void> showFinishDialog(
  //   BuildContext context,
  //   String endTime,
  //   String serviceName,
  //   String? company, {
  //   Function(String)? onImageCaptured,
  //   bool isCategory = false,
  //   int? categoryIndex,
  // }) async {
  //   File? localSelectedImage;

  //   await showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setDialogState) {
  //           bool isImageSelected = localSelectedImage != null;
  //           return Dialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(16),
  //             ),
  //             insetPadding: const EdgeInsets.all(20),
  //             child: Stack(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(16.0),
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         company ?? "Company",
  //                         style: const TextStyle(
  //                           color: AppColor.loginButton,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 18,
  //                         ),
  //                         textScaler: TextScaler.linear(1),
  //                       ),
  //                       const SizedBox(height: 6),
  //                       Text(
  //                         serviceName,
  //                         style: const TextStyle(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w800,
  //                           color: Colors.black87,
  //                         ),
  //                         textScaler: TextScaler.linear(1),
  //                       ),
  //                       const SizedBox(height: 16),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           const Icon(
  //                             Icons.timer,
  //                             color: AppColor.loginButton,
  //                           ),
  //                           const SizedBox(width: 6),
  //                           Column(
  //                             children: [
  //                               Text(
  //                                 endTime,
  //                                 style: const TextStyle(
  //                                   fontSize: 20,
  //                                   color: Colors.blue,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                                 textScaler: TextScaler.linear(1),
  //                               ),
  //                               const SizedBox(height: 2),
  //                               const Text(
  //                                 "hr   :   min   :   sec",
  //                                 style: TextStyle(
  //                                   fontSize: 10,
  //                                   color: Colors.grey,
  //                                 ),
  //                                 textScaler: TextScaler.linear(1),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                       const SizedBox(height: 20),
  //                       const Text(
  //                         "Finished Cleaning",
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16,
  //                         ),
  //                         textScaler: TextScaler.linear(1),
  //                       ),
  //                       const SizedBox(height: 8),
  //                       GestureDetector(
  //                         onTap: () async {
  //                           final picker = ImagePicker();
  //                           final picked = await picker.pickImage(
  //                             source: ImageSource.camera,
  //                           );
  //                           if (picked != null) {
  //                             final cropped = await ImageCropper().cropImage(
  //                               sourcePath: picked.path,
  //                               uiSettings: [
  //                                 AndroidUiSettings(
  //                                   toolbarTitle: 'Crop Image',
  //                                   toolbarColor: Colors.deepOrange,
  //                                   toolbarWidgetColor: Colors.white,
  //                                 ),
  //                                 IOSUiSettings(title: 'Crop Image'),
  //                               ],
  //                             );
  //                             if (cropped != null) {
  //                               setDialogState(() {
  //                                 localSelectedImage = File(cropped.path);
  //                               });
  //                             }
  //                           }
  //                         },
  //                         child: localSelectedImage == null
  //                             ? Container(
  //                                 width: 100,
  //                                 height: 100,
  //                                 decoration: BoxDecoration(
  //                                   color: Colors.orange,
  //                                   borderRadius: BorderRadius.circular(12),
  //                                 ),
  //                                 child: const Icon(
  //                                   Icons.add_photo_alternate,
  //                                   color: Colors.white,
  //                                   size: 40,
  //                                 ),
  //                               )
  //                             : ClipRRect(
  //                                 borderRadius: BorderRadius.circular(12),
  //                                 child: Image.file(
  //                                   localSelectedImage!,
  //                                   width: 100,
  //                                   height: 100,
  //                                   fit: BoxFit.cover,
  //                                 ),
  //                               ),
  //                       ),
  //                       const SizedBox(height: 20),
  //                       SizedBox(
  //                         width: double.infinity,
  //                         child: ElevatedButton(
  //                           onPressed: () {
  //                             if (localSelectedImage != null) {
  //                               if (isCategory && categoryIndex != null) {
  //                                 setState(() {
  //                                   services[categoryIndex]["imagePath"] =
  //                                       localSelectedImage!.path;
  //                                   services[categoryIndex]["completed"] = true;
  //                                   services[categoryIndex]["started"] = false;
  //                                 });
  //                               } else if (onImageCaptured != null) {
  //                                 onImageCaptured(localSelectedImage!.path);
  //                               }
  //                             } else {
  //                               if (isCategory && categoryIndex != null) {
  //                                 setState(() {
  //                                   services[categoryIndex]["completed"] = true;
  //                                   services[categoryIndex]["started"] = false;
  //                                 });
  //                               } else if (onImageCaptured != null) {
  //                                 onImageCaptured("");
  //                               }
  //                             }

  //                             Navigator.pop(context);
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                               SnackBar(
  //                                 content: Text(
  //                                   "$serviceName finished for $company",
  //                                   textScaler: TextScaler.linear(1),
  //                                 ),
  //                                 backgroundColor: Colors.green,
  //                               ),
  //                             );
  //                           },

  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Colors.green,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(8),
  //                             ),
  //                             padding: const EdgeInsets.symmetric(vertical: 12),
  //                           ),
  //                           child: const Text(
  //                             "FINISH",
  //                             style: TextStyle(
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.white,
  //                             ),
  //                             textScaler: TextScaler.linear(1),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Positioned(
  //                   right: 8,
  //                   top: 0,
  //                   child: GestureDetector(
  //                     onTap: () => Navigator.pop(context),
  //                     child: const CircleAvatar(
  //                       radius: 12,
  //                       backgroundColor: Colors.red,
  //                       child: Icon(Icons.close, color: Colors.white, size: 14),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Future<void> showFinishDialog(
    BuildContext context,
    String endTime,
    String serviceName,
    String? company, {
    Function(String)? onImageCaptured,
    bool isCategory = false,
    int? categoryIndex,
  }) async {
    File? localSelectedImage;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Check if an image is selected to enable/disable the FINISH button
            bool isImageSelected = localSelectedImage != null;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          company ?? "Company",
                          style: const TextStyle(
                            color: AppColor.loginButton,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textScaler: TextScaler.linear(1),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          serviceName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                          textScaler: TextScaler.linear(1),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.timer,
                              color: AppColor.loginButton,
                            ),
                            const SizedBox(width: 6),
                            Column(
                              children: [
                                Text(
                                  endTime,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textScaler: TextScaler.linear(1),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  "hr   :   min   :   sec",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                  textScaler: TextScaler.linear(1),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Finished Cleaning",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textScaler: TextScaler.linear(1),
                        ),
                        const SizedBox(height: 8),

                        // Image selector with visual indicator
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final picker = ImagePicker();
                                final picked = await picker.pickImage(
                                  source: ImageSource.camera,
                                );
                                if (picked != null) {
                                  final cropped = await ImageCropper()
                                      .cropImage(
                                        sourcePath: picked.path,
                                        uiSettings: [
                                          AndroidUiSettings(
                                            toolbarTitle: 'Crop Image',
                                            toolbarColor: Colors.deepOrange,
                                            toolbarWidgetColor: Colors.white,
                                          ),
                                          IOSUiSettings(title: 'Crop Image'),
                                        ],
                                      );
                                  if (cropped != null) {
                                    setDialogState(() {
                                      localSelectedImage = File(cropped.path);
                                    });
                                  }
                                }
                              },
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: localSelectedImage == null
                                      ? Colors.orange
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: localSelectedImage == null
                                        ? Colors.transparent
                                        : Colors.green,
                                    width: 3,
                                  ),
                                ),
                                child: localSelectedImage == null
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.add_a_photo,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "Take a Photo",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textScaler: TextScaler.linear(1),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "(Required)",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                            textScaler: TextScaler.linear(1),
                                          ),
                                        ],
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          localSelectedImage!,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ),

                            // Checkmark badge when image is selected
                            if (localSelectedImage != null)
                              Positioned(
                                right: 5,
                                top: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 5),

                        // Image requirement text
                        if (!isImageSelected)
                          const Text(
                            "Please take a photo to complete",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                            textScaler: TextScaler.linear(1),
                          ),

                        const SizedBox(height: 20),

                        // Finish button - disabled when no image
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isImageSelected
                                ? () {
                                    if (isCategory && categoryIndex != null) {
                                      setState(() {
                                        services[categoryIndex]["imagePath"] =
                                            localSelectedImage!.path;
                                        services[categoryIndex]["completed"] =
                                            true;
                                        services[categoryIndex]["started"] =
                                            false;
                                      });
                                    } else if (onImageCaptured != null) {
                                      onImageCaptured(localSelectedImage!.path);
                                    }

                                    Navigator.pop(context);
                                    Fluttertoast.showToast(
                                      msg: "$serviceName finished for $company",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   SnackBar(
                                    //     content: Text(
                                    //       "$serviceName finished for $company",
                                    //       textScaler: TextScaler.linear(1),
                                    //     ),
                                    //     backgroundColor: Colors.green,
                                    //   ),
                                    // );
                                  }
                                : null, // Disable button when no image

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              disabledBackgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              isImageSelected ? "FINISH" : "TAKE PHOTO FIRST",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textScaler: TextScaler.linear(1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 2,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.close, color: Colors.white, size: 14),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final allCompleted = areAllCategoriesCompleted();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              company ?? "Company",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textScaler: TextScaler.linear(1),
            ),
            if (location != null)
              Text(
                location!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textScaler: TextScaler.linear(1),
              ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Qnss-bg2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            DottedLine(
              height: 1,
              color: Colors.white,
              dotRadius: 1,
              spacing: 2,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white.withOpacity(0.9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Job Sheet :",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      //color: Colors.grey[700],
                      color: AppColor.loginText,
                    ),
                    textScaler: TextScaler.linear(1),
                  ),
                  Text(
                    "${getCompletedCategoriesCount()} of ${services.length} Total Jobs",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                    textScaler: TextScaler.linear(1),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 8,
              color: Colors.white.withOpacity(0.9),
              // padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LinearProgressIndicator(
                value: getCompletedCategoriesCount() / services.length,
                backgroundColor: Colors.grey[300],
                color: Colors.green,
                minHeight: 8,
              ),
            ),

            Container(
              width: size.width * 0.45,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: AppColor.titleButton,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'TIMER',
                    style: Styles.textStyleSmall2(
                      context,
                      color: AppColor.whiteColor,
                    ),
                    textScaler: TextScaler.linear(1),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    formatTime(_seconds),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColor.loginText,
                      letterSpacing: 2,
                    ),
                    textScaler: TextScaler.linear(1),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildCategorySection(index),
                  );
                },
              ),
            ),

            // Checkout button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: allCompleted
                    ? () {
                        showCheckoutConfirmation(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: allCompleted ? Colors.green : Colors.grey,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  "CHECKOUT",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: allCompleted ? Colors.white : Colors.grey.shade700,
                  ),
                  textScaler: TextScaler.linear(1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
