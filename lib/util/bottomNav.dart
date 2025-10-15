// import 'package:flutter/material.dart';
// import 'package:soapy/pages/calenderpage.dart';
// import 'package:soapy/pages/locationpage.dart';
// import 'package:soapy/util/colors.dart';
// import 'package:soapy/util/dottedLine.dart';
// import 'package:soapy/util/servicecard.dart';

// class VerticalDottedLine extends StatelessWidget {
//   final double width;
//   final double height;
//   final Color color;
//   final double dotRadius;
//   final double spacing;

//   const VerticalDottedLine({
//     Key? key,
//     this.width = 1,
//     this.height = 50,
//     this.color = Colors.grey,
//     this.dotRadius = 1,
//     this.spacing = 3,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: Size(width, height),
//       painter: VerticalDottedLinePainter(
//         color: color,
//         dotRadius: dotRadius,
//         spacing: spacing,
//       ),
//     );
//   }
// }

// class VerticalDottedLinePainter extends CustomPainter {
//   final Color color;
//   final double dotRadius;
//   final double spacing;

//   VerticalDottedLinePainter({
//     required this.color,
//     required this.dotRadius,
//     required this.spacing,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;

//     double startY = 0;
//     while (startY < size.height) {
//       canvas.drawCircle(
//         Offset(size.width / 2, startY + dotRadius),
//         dotRadius,
//         paint,
//       );
//       startY += dotRadius * 2 + spacing;
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// class CustomBottomNav extends StatelessWidget {
//   final int currentIndex;
//   final ValueChanged<int> onTap;
//   final List<Map<String, dynamic>> items;

//   const CustomBottomNav({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//     required this.items,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         DottedLine(
//           height: 1,
//           color: AppColor.whiteColor,
//           dotRadius: 1,
//           spacing: 2,
//         ),
//         Container(
//           height: 80,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.3),
//                 blurRadius: 10,
//                 offset: const Offset(0, -5),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildNavItem(
//                 context,
//                 'assets/icons/parchment.png',
//                 'History',
//                 0,
//                 () => _showHistoryBottomSheet(context),
//               ),
//               _buildVerticalDottedLine(),
//               _buildNavItem(
//                 context,
//                 'assets/icons/landline.png',
//                 'Support',
//                 1,
//                 () => _showSupportBottomSheet(context),
//               ),
//               _buildVerticalDottedLine(),
//               _buildNavItem(
//                 context,
//                 'assets/icons/calendar.png',
//                 'Calender',
//                 2,
//                 // () => _showLocationBottomSheet(context),
//                 () async {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const CalendarPage(),
//                     ),
//                   );
//                   Future.delayed(const Duration(milliseconds: 100), () {
//                     onTap(-1); 
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildVerticalDottedLine() {
//     return VerticalDottedLine(
//       height: 50,
//       width: 1,
//       color: AppColor.loginButton,
//       dotRadius: 1,
//       spacing: 2,
//     );
//   }

//   Widget _buildNavItem(
//     BuildContext context,
//     String imagePath,
//     String label,
//     int index,
//     VoidCallback onPressed,
//   ) {
//     final isSelected = currentIndex == index;

//     return GestureDetector(
//       onTap: () {
//         onTap(index); // Update selected index
//         onPressed(); // Open bottom sheet
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 28,
//               height: 28,
//               child: ColorFiltered(
//                 colorFilter: ColorFilter.mode(
//                   isSelected ? Colors.blue : Colors.black,
//                   BlendMode.srcIn,
//                 ),
//                 child: Image.asset(
//                   imagePath,
//                   width: 28,
//                   height: 28,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: isSelected ? Colors.blue : Colors.black,
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//               ),
//               textScaler: TextScaler.linear(1),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showHistoryBottomSheet(BuildContext context) {
//     // Filter only completed items
//     final completedItems = items
//         .where((item) => item["completed"] == true)
//         .toList();

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.9,
//         maxChildSize: 0.9,
//         minChildSize: 0.5,
//         builder: (context, scrollController) => Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             image: DecorationImage(
//               image: AssetImage("assets/Qnss-bg2.jpg"), // your background image
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Column(
//             children: [
//               // Header with back button
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withValues(alpha: 0.8),

//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(20),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back),
//                       onPressed: () {
//                         Navigator.pop(context);
//                         // Reset selection when closing
//                         Future.delayed(const Duration(milliseconds: 200), () {
//                           onTap(-1); // Reset to no selection
//                         });
//                       },
//                     ),
//                     const SizedBox(width: 8),
//                     const Text(
//                       'Services Histroy',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textScaler: TextScaler.linear(1),
//                     ),
//                   ],
//                 ),
//               ),

//               // Show message if no completed services
//               if (completedItems.isEmpty)
//                 Expanded(
//                   child: Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.history, size: 80, color: Colors.grey[400]),
//                         const SizedBox(height: 16),
//                         Text(
//                           'No completed services yet',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.grey[700],
//                           ),
//                           textScaler: TextScaler.linear(1),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Services will appear here once completed',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[600],
//                           ),
//                           textScaler: TextScaler.linear(1),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               else
//                 // Content - List of completed service cards
//                 Expanded(
//                   child: ListView.builder(
//                     controller: scrollController,
//                     padding: const EdgeInsets.all(10),
//                     itemCount: completedItems.length,
//                     itemBuilder: (context, index) {
//                       final item = completedItems[index];
//                       return ServiceCard(
//                         imagePath: item["image"]!,
//                         company: item["company"]!,
//                         subtitle: item["subtitle"]!,
//                         location: item["location"],
//                         timeRange: item["timeRange"],
//                         distance: item["distance"],
//                         lat: item["lat"],
//                         lng: item["lng"],
//                         isCompleted: true,
//                         inHistoryView: true,
//                         completedAt: item["completedAt"],
//                         onStartPressed: () {},
//                       );
//                     },
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showSupportBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.9,
//         maxChildSize: 0.9,
//         minChildSize: 0.5,
//         builder: (context, scrollController) => Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             image: DecorationImage(
//               image: AssetImage("assets/Call-office-bg1.png"),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Column(
//             children: [
//               // Header with back button
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withValues(alpha: 0.8),
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(20),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back),
//                       onPressed: () {
//                         Navigator.pop(context);
//                         Future.delayed(const Duration(milliseconds: 200), () {
//                           onTap(-1); // Reset to no selection
//                         });
//                       },
//                     ),
//                     const SizedBox(width: 8),
//                     const Text(
//                       'Customer Care Support',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textScaler: TextScaler.linear(1),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 200),
//               // Content area - properly centered
//               Expanded(
//                 child: Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Call Your Customer Care",
//                         style: TextStyle(
//                           color: AppColor.loginText,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textScaler: TextScaler.linear(1),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         "Need Help ?",
//                         style: TextStyle(
//                           color: AppColor.loginText,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textScaler: TextScaler.linear(1),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 20),
//                       Image.asset(
//                         "assets/Call-bg.png",
//                         width: 150,
//                         height: 150,
//                         fit: BoxFit.contain,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:soapy/pages/calenderpage.dart';
import 'package:soapy/pages/locationpage.dart';
import 'package:soapy/pages/scan_QR.dart';
import 'package:soapy/util/colors.dart';
import 'package:soapy/util/dottedLine.dart';
import 'package:soapy/util/servicecard.dart';
import 'package:url_launcher/url_launcher.dart';

class VerticalDottedLine extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double dotRadius;
  final double spacing;

  const VerticalDottedLine({
    Key? key,
    this.width = 1,
    this.height = 50,
    this.color = Colors.grey,
    this.dotRadius = 1,
    this.spacing = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: VerticalDottedLinePainter(
        color: color,
        dotRadius: dotRadius,
        spacing: spacing,
      ),
    );
  }
}

class VerticalDottedLinePainter extends CustomPainter {
  final Color color;
  final double dotRadius;
  final double spacing;

  VerticalDottedLinePainter({
    required this.color,
    required this.dotRadius,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawCircle(
        Offset(size.width / 2, startY + dotRadius),
        dotRadius,
        paint,
      );
      startY += dotRadius * 2 + spacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<Map<String, dynamic>> items;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  // Function to make phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'Could not launch $launchUri';
      }
    } catch (e) {
      print('Error making phone call: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DottedLine(
          height: 1,
          color: AppColor.whiteColor,
          dotRadius: 1,
          spacing: 2,
        ),
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                context,
                'assets/icons/parchment.png',
                'History',
                0,
                () => _showHistoryBottomSheet(context),
              ),
              _buildVerticalDottedLine(),
              _buildNavItem(
                context,
                'assets/icons/landline.png',
                'Support',
                1,
                () => _showSupportBottomSheet(context),
              ),
              _buildVerticalDottedLine(),
              _buildNavItem(
                context,
                'assets/icons/calendar.png',
                'Calender',
                2,
                () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CalendarPage(),
                    ),
                  );
                  Future.delayed(const Duration(milliseconds: 100), () {
                    onTap(-1); 
                  });
                },
              ),
              _buildVerticalDottedLine(),
              _buildNavItem(
                context,
                'assets/icons/qr-code.png',
                'Scan QR',
                2,
                () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QRScannerPage (),
                    ),
                  );
                  Future.delayed(const Duration(milliseconds: 100), () {
                    onTap(-1); 
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDottedLine() {
    return VerticalDottedLine(
      height: 50,
      width: 1,
      color: AppColor.loginButton,
      dotRadius: 1,
      spacing: 2,
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String imagePath,
    String label,
    int index,
    VoidCallback onPressed,
  ) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        onTap(index);
        onPressed();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  isSelected ? Colors.blue : Colors.black,
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  imagePath,
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.blue : Colors.black,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textScaler: TextScaler.linear(1),
            ),
          ],
        ),
      ),
    );
  }

  void _showHistoryBottomSheet(BuildContext context) {
    final completedItems = items
        .where((item) => item["completed"] == true)
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            image: DecorationImage(
              image: AssetImage("assets/Qnss-bg2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 200), () {
                          onTap(-1);
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Services History',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaler: TextScaler.linear(1),
                    ),
                  ],
                ),
              ),

              if (completedItems.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No completed services yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                          textScaler: TextScaler.linear(1),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Services will appear here once completed',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textScaler: TextScaler.linear(1),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(10),
                    itemCount: completedItems.length,
                    itemBuilder: (context, index) {
                      final item = completedItems[index];
                      return ServiceCard(
                        imagePath: item["image"]!,
                        company: item["company"]!,
                        subtitle: item["subtitle"]!,
                        location: item["location"],
                        timeRange: item["timeRange"],
                        distance: item["distance"],
                        lat: item["lat"],
                        lng: item["lng"],
                        isCompleted: true,
                        inHistoryView: true,
                        completedAt: item["completedAt"],
                        onStartPressed: () {},
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSupportBottomSheet(BuildContext context) {
    const String supportPhoneNumber = '+62 89681619918';
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            image: DecorationImage(
              image: AssetImage("assets/Call-office-bg1.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // Header with back button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 200), () {
                          onTap(-1);
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Customer Care Support',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaler: TextScaler.linear(1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 150),
              
              // Content area with clickable call button
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Call Your Customer Care",
                        style: TextStyle(
                          color: AppColor.loginText,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textScaler: TextScaler.linear(1),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Need Help ?",
                        style: TextStyle(
                          color: AppColor.loginText,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textScaler: TextScaler.linear(1),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      
                      // Clickable call image with animation
                      GestureDetector(
                        onTap: () => _makePhoneCall(supportPhoneNumber),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            "assets/Call-bg.png",
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Phone number display
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: 20,
                      //     vertical: 10,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white.withOpacity(0.9),
                      //     borderRadius: BorderRadius.circular(25),
                      //     border: Border.all(
                      //       color: Colors.green,
                      //       width: 2,
                      //     ),
                      //   ),
                        // child: Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     const Icon(
                        //       Icons.phone,
                        //       color: Colors.green,
                        //       size: 20,
                        //     ),
                        //     const SizedBox(width: 10),
                        //     Text(
                        //       supportPhoneNumber,
                        //       style: const TextStyle(
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.black87,
                        //         letterSpacing: 1.2,
                        //       ),
                        //       textScaler: const TextScaler.linear(1),
                        //     ),
                        //   ],
                        // ),
                      //),
                      
                      const SizedBox(height: 15),
                      
                      // Tap instruction
                      Text(
                        "Tap the image to call",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                        textScaler: const TextScaler.linear(1),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}