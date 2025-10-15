import 'package:flutter/material.dart';
import 'package:soapy/pages/detailpage.dart';
import 'package:soapy/util/colors.dart';
import 'package:soapy/util/style.dart';

class ServiceCard extends StatelessWidget {
  final String imagePath;
  final String company;
  final String subtitle;
  final String? location;
  final String? timeRange;
  final String? distance;
  final double? lat;
  final double? lng;
  final bool isCompleted;
  final bool inHistoryView;
  final String? completedAt;
  final VoidCallback? onStartPressed;

  const ServiceCard({
    super.key,
    required this.imagePath,
    required this.company,
    required this.subtitle,
    this.location,
    this.timeRange,
    this.distance,
    this.lat,
    this.lng,
    this.isCompleted = false,
    this.inHistoryView = false,
    this.completedAt,
    this.onStartPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFFEDF7ED) : const Color(0xFFFDF7ED),
        borderRadius: BorderRadius.circular(20),
        border: isCompleted
            ? Border.all(color: Colors.green, width: 1.0)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    width: size.width * 0.25,
                    height: size.width * 0.3,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),

                // Right content - Fixed with Expanded
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title with proper width constraint
                        Text(
                          company,
                          style: TextStyle(
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                          maxLines: 2, // Allow 2 lines for title
                          overflow: TextOverflow.ellipsis,
                          textScaler: TextScaler.linear(1),
                        ),
                        const SizedBox(height: 6),

                        // Subtitle/location
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFFFF9800),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                location ?? '',
                                style: TextStyle(
                                  fontSize: size.width * 0.033,
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textScaler: TextScaler.linear(1),
                              ),
                            ),
                          ],
                        ),

                        // Show completed date in history view
                        SizedBox(height: 5),
                        // Bottom row: time + Details/Closed button
                        Row(
                          children: [
                            // Time range container - with Flexible
                            if (timeRange != null)
                              Flexible(
                                flex: 3,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[600],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.timer,
                                        size: 14,
                                        color: AppColor.loginText,
                                      ),
                                      const SizedBox(width: 3),
                                      Flexible(
                                        child: Text(
                                          timeRange!,
                                          style: TextStyle(
                                            fontSize: size.width * 0.028,
                                            fontWeight: FontWeight.w900,
                                            color: AppColor.whiteColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          textScaler: TextScaler.linear(1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            // Spacer with flexible width
                            const SizedBox(width: 8),

                            // Details button - with Flexible
                            Flexible(
                              flex: 2,
                              child: GestureDetector(
                                onTap: isCompleted
                                    ? null // Disable tap if completed
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => Detailpage(
                                              imagePath: imagePath,
                                              title: company,
                                              subtitle: subtitle,
                                              location: location ?? "",
                                              timeRange: timeRange ?? "",
                                              distance: distance ?? "",
                                              lat: lat ?? 0.0,
                                              lng: lng ?? 0.0,
                                            ),
                                          ),
                                        );
                                      },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isCompleted
                                        ? AppColor.greenColor
                                        : AppColor.loginButton,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      isCompleted ? "Finished" : "Details",
                                      style: TextStyle(
                                        fontSize: size.width * 0.035,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      textScaler: TextScaler.linear(1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //SizedBox(height: 5),
                        if (inHistoryView && completedAt != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green[700],
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Completed: ${_formatCompletedDate(completedAt!)}",
                                  style: TextStyle(
                                    fontSize: size.width * 0.035,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.green[700],
                                  ),
                                  textScaler: TextScaler.linear(1),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Distance badge (top-right)
          //if (distance != null && !isCompleted)
          Positioned(
            top: 0,
            right: 20,
            child: Container(
              height: size.height * 0.03,
              decoration: const BoxDecoration(
                color: Color(0xFFFFB300),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                distance!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),textScaler: TextScaler.linear(1),
              ),
            ),
          ),

          // Completed badge
          // if (isCompleted && !inHistoryView)
          //   Positioned(
          //     top: 5,
          //     right: 5,
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //       decoration: BoxDecoration(
          //         color: Colors.green,
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //       child: Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: const [
          //           Icon(Icons.check_circle, color: Colors.white, size: 12),
          //           SizedBox(width: 4),
          //           Text(
          //             "COMPLETED",
          //             style: TextStyle(
          //               fontSize: 8,
          //               color: Colors.white,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  // Helper method to format completed date
  String _formatCompletedDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return "Recently";
    }
  }
}
